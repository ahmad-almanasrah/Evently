import 'package:evently/data/model/event_model.dart';
import 'package:evently/providers/friend-provider.dart';
import 'package:evently/providers/home-provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchEvents();
      context.read<FriendProvider>().fetchPendingRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- ✅ NEW: BOTTOM SHEET FOR REQUESTS ---
  void _showRequestsPanel(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Consumer<FriendProvider>(
          builder: (context, provider, _) {
            return Container(
              padding: const EdgeInsets.all(20),
              // Constrain height so it doesn't take full screen if list is short
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Friend Requests",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (provider.pendingRequests.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text("No new requests")),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.pendingRequests.length,
                        itemBuilder: (context, index) {
                          final req = provider.pendingRequests[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(req.senderPp),
                            ),
                            title: Text(req.senderName),
                            subtitle: Text("@${req.senderUsername}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => provider.respondToRequest(
                                    req.requestId,
                                    "accept",
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => provider.respondToRequest(
                                    req.requestId,
                                    "reject",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'CreateEvent').then((_) {
            if (context.mounted) {
              context.read<HomeProvider>().fetchEvents();
            }
          });
        },
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Event", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, home, _) {
            final filteredEvents = home.events.where((event) {
              return event.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Evently",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                            _buildNotificationBell(context, theme),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.textTheme.bodySmall!.color!
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              hintText: "Find an event...",
                              hintStyle: theme.textTheme.bodySmall,
                              prefixIcon: Icon(
                                Icons.search,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _searchQuery.isEmpty
                              ? "Your Events"
                              : "Search Results",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (home.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (home.errorMessage != null)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          home.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  )
                else if (filteredEvents.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          _searchQuery.isEmpty
                              ? "No events created yet"
                              : "No events match '$_searchQuery'",
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final event = filteredEvents[index];
                        return _buildEventCard(context, event, theme);
                      }, childCount: filteredEvents.length),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context, ThemeData theme) {
    return Consumer<FriendProvider>(
      builder: (context, friendProvider, child) {
        int count = friendProvider.pendingRequests.length;

        return GestureDetector(
          onTap: () =>
              _showRequestsPanel(context), // ✅ Opens the slide-up panel
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.textTheme.bodySmall!.color!.withOpacity(0.3),
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: theme.iconTheme.color,
                ),
              ),
              if (count > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    EventModel event,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'EventDetails', arguments: event.id);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.textTheme.bodySmall!.color!.withOpacity(0.1),
                  ),
                ),
                child:
                    event.coverImageUrl != null &&
                        event.coverImageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          event.coverImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (ctx, err, stack) => Icon(
                            Icons.broken_image,
                            color: theme.disabledColor,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              DateFormat('MMM d, yyyy').format(event.eventDate),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
