import 'package:evently/providers/home-provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  static const String routeName = 'create_event';

  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? _selectedDate;
  bool _isPublic = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final theme = Theme.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              onSurface: theme.textTheme.bodyMedium?.color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    final provider = context.read<HomeProvider>();

    final eventData = {
      "title": _titleController.text.trim(),
      "description": _descController.text.trim(),
      "eventDate": _selectedDate!.toIso8601String(),
      "isPublic": _isPublic,
    };

    final success = await provider.createEvent(
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      eventDate: _selectedDate!,
      isPublic: _isPublic,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event created successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Failed to create event"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color mainColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyMedium!.color!;
    final Color labelColor = theme.textTheme.bodySmall!.color!;
    final Color borderColor = theme.iconTheme.color!.withOpacity(0.3);

    InputDecoration inputDecoration(String label, {String? hint}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: labelColor),
        floatingLabelStyle: TextStyle(
          color: mainColor,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(color: labelColor.withOpacity(0.7)),
        filled: true,
        fillColor: theme.cardColor,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: mainColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: theme.iconTheme.color),
        title: Text(
          "Create Event",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                "Event Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: inputDecoration(
                  "Event Title",
                  hint: "e.g. Summer Beach Party",
                ),
                style: TextStyle(color: textColor),
                validator: (value) =>
                    value == null || value.isEmpty ? "Title is required" : null,
              ),

              const SizedBox(height: 24),

              /// DATE
              Text(
                "Date",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedDate == null ? borderColor : mainColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: mainColor),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? "Select Date"
                            : DateFormat(
                                'EEE, MMM d, yyyy',
                              ).format(_selectedDate!),
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// PUBLIC SWITCH
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: SwitchListTile(
                  title: Text(
                    "Public Event",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Visible to everyone",
                    style: TextStyle(color: labelColor),
                  ),
                  value: _isPublic,
                  activeColor: mainColor,
                  onChanged: (val) => setState(() => _isPublic = val),
                ),
              ),

              const SizedBox(height: 24),

              /// DESCRIPTION
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: inputDecoration(
                  "Event Description",
                  hint: "Tell people about your event",
                ),
                style: TextStyle(color: textColor),
              ),

              const SizedBox(height: 40),

              /// SUBMIT
              Consumer<HomeProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _submitEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: provider.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              "Create Event",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
