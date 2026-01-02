import 'package:evently/data/model/event_details_model.dart';
import 'package:evently/data/services/home-service.dart';
import 'package:evently/presentation/home/upload_image_screen.dart';
import 'package:evently/presentation/home/invite_friends_screen.dart'; // Import Invite Screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import QR Flutter

class EventDetailsScreen extends StatefulWidget {
  final int eventId;
  static const String routeName = 'event_details';

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final HomeService _homeService = HomeService();
  late Future<EventDetailsModel> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    setState(() {
      _detailsFuture = _homeService.getEventDetails(widget.eventId);
    });
  }

  // --- SHOW QR CODE DIALOG ---
  void _showQrCode(BuildContext context, int eventId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Scan to Join", textAlign: TextAlign.center),
        content: SizedBox(
          width: 250,
          height: 250,
          child: Center(
            child: QrImageView(
              data: eventId.toString(), // The payload is just the Event ID
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor = theme.textTheme.bodyMedium!.color!;
    final Color cardColor = theme.cardColor;
    final Color greyColor = theme.textTheme.bodySmall!.color!;
    final Color primaryColor = theme.primaryColor;

    return FutureBuilder<EventDetailsModel>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        // --- 1. LOADING STATE ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // --- 2. ERROR STATE ---
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(leading: const BackButton()),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // --- 3. DATA LOADED ---
        final event = snapshot.data!;
        final bool isOwner = event.isOwner;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          // ✅ OWNER ONLY: Show Floating Action Button (Upload Photos)
          floatingActionButton: isOwner
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    final bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UploadImageScreen(eventId: widget.eventId),
                      ),
                    );

                    if (result == true && mounted) {
                      _fetchDetails();
                    }
                  },
                  label: const Text("Add Photos"),
                  icon: const Icon(Icons.add_a_photo),
                )
              : null, // VISITOR: No button

          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- APP BAR ---
              SliverAppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                pinned: true,
                leading: BackButton(color: textColor),
                actions: [
                  // ✅ OWNER ONLY: Show Edit/Delete Menu
                  if (isOwner)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded, color: textColor),
                      color: cardColor,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            'Edit',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // --- CONTENT ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Creator Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: cardColor,
                            backgroundImage: event.creatorProfileImage != null
                                ? NetworkImage(event.creatorProfileImage!)
                                : null,
                            child: event.creatorProfileImage == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.creatorName,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Created on ${DateFormat('MMM d').format(event.createdDate)}",
                                style: TextStyle(
                                  color: greyColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      if (event.description != null &&
                          event.description!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            event.description!,
                            style: TextStyle(
                              color: textColor.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // ===============================================
                      // ✅ NEW BUTTONS: INVITE & QR CODE (Owner Only)
                      // ===============================================
                      if (isOwner)
                        Row(
                          children: [
                            // 1. Invite Friends Button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InviteFriendsScreen(
                                        eventId: widget.eventId,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.person_add_alt_1),
                                label: const Text("Invite"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 2. Show QR Code Button
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showQrCode(
                                  context,
                                  widget.eventId,
                                  event.title,
                                ),
                                icon: const Icon(Icons.qr_code),
                                label: const Text("QR Code"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),

                      // ===============================================
                      const SizedBox(height: 24),

                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- PHOTO GRID ---
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildClickableImage(
                      context,
                      event.photos[index],
                      index,
                    );
                  }, childCount: event.photos.length),
                ),
              ),

              // Spacing for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClickableImage(
    BuildContext context,
    String imageUrl,
    int index,
  ) {
    final String uniqueHeroTag = "$imageUrl-$index";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              imageUrl: imageUrl,
              heroTag: uniqueHeroTag,
            ),
          ),
        );
      },
      child: Hero(
        tag: uniqueHeroTag,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// --- FULL SCREEN VIEWER ---
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(child: Image.network(imageUrl)),
        ),
      ),
    );
  }
}
