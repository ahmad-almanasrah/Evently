import 'dart:io';
import 'package:evently/providers/profile-provider.dart';
import 'package:evently/providers/auth/login-provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final VoidCallback toggleTheme;
  const Profile({super.key, required this.toggleTheme});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  bool isDark = false;
  static final Color fixedIconColor = Colors.grey.shade700;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.fetchProfile().catchError((e) {
        _showError(context, e.toString());
      });
      setState(() {
        isDark = Theme.of(context).brightness == Brightness.dark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color!;
    final subTextColor = theme.textTheme.bodySmall!.color!;
    final cardColor = theme.cardColor;
    final primaryColor = theme.primaryColor;

    return Consumer<ProfileProvider>(
      builder: (context, profile, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// -------- HEADER --------
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final picked = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (picked != null) {
                            await profile.updateProfilePicture(
                              File(picked.path),
                            );
                          }
                        } catch (e) {
                          _showError(context, e.toString());
                        }
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: cardColor,
                        child: ClipOval(
                          child: profile.profileImage != null
                              ? Image.file(
                                  profile.profileImage!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : (profile.pictureURL.isNotEmpty
                                    ? Image.network(
                                        profile.pictureURL,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.person,
                                                  size: 60,
                                                ),
                                      )
                                    : const Icon(Icons.person, size: 60)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "@${profile.username}",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// -------- STATS --------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: textColor.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _stat("Friends", profile.friendsCount, textColor),
                      _divider(textColor),
                      _stat("Photos", profile.pictureCount, textColor),
                      _divider(textColor),
                      _stat("Galleries", profile.galleriesCount, textColor),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// -------- ACCOUNT --------
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: subTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                _settingTile(
                  context,
                  icon: Icons.person_outline,
                  title: "Change Username",
                  value: profile.username,
                  onTap: () => _changeText(
                    context,
                    title: "Change Username",
                    initial: profile.username,
                    onSave: profile.updateUsername,
                  ),
                ),
                const SizedBox(height: 10),

                _settingTile(
                  context,
                  icon: Icons.email_outlined,
                  title: "Change Email",
                  value: profile.email,
                  onTap: () => _changeText(
                    context,
                    title: "Change Email",
                    initial: profile.email,
                    onSave: profile.updateEmail,
                  ),
                ),
                const SizedBox(height: 10),

                _settingTile(
                  context,
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  value: "••••••",
                  onTap: () => _changePassword(context, profile),
                ),
                const SizedBox(height: 10),

                /// -------- DARK MODE --------
                ListTile(
                  leading: _iconBox(Icons.dark_mode_outlined),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  trailing: Switch(
                    value: isDark,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() => isDark = value);
                      widget.toggleTheme();
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// -------- LOGOUT --------
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('jwt_token');
                      context.read<LoginProvider>().reset();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'Login',
                        (_) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.05),
                      side: BorderSide(color: Colors.red.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  /// -------- HELPERS --------
  Widget _iconBox(IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, size: 22, color: fixedIconColor),
  );

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color!;
    final subTextColor = theme.textTheme.bodySmall!.color!;
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: subTextColor)),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: subTextColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value, Color textColor) => Column(
    children: [
      Text(
        value.toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      const SizedBox(height: 4),
      Text(label),
    ],
  );

  Widget _divider(Color color) =>
      Container(width: 1, height: 40, color: color.withOpacity(0.1));

  /// -------- CHANGE TEXT HANDLER --------
  Future<void> _changeText(
    BuildContext context, {
    required String title,
    required String initial,
    required Future<void> Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        await onSave(result);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Updated successfully")));
      } catch (e) {
        _showError(context, e.toString());
      }
    }
  }

  /// -------- CHANGE PASSWORD HANDLER --------
  Future<void> _changePassword(
    BuildContext context,
    ProfileProvider profile,
  ) async {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Old Password"),
            ),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await profile.updatePassword(oldCtrl.text, newCtrl.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );
      } catch (e) {
        _showError(context, e.toString());
      }
    }
  }

  /// -------- SNACKBAR ERROR --------
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceFirst("Exception: ", "")),
        backgroundColor: Colors.red,
      ),
    );
  }
}
