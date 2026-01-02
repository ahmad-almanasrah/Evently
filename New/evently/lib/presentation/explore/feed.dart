import 'package:evently/data/model/event_model.dart';
import 'package:evently/data/services/explore_service.dart';
import 'package:evently/providers/friend-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'dart:async';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color mainColor = theme.primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search events...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                )
              : Text(
                  "Discover",
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: mainColor,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchQuery = "";
                  }
                });
              },
            ),
          ],
          bottom: TabBar(
            labelColor: mainColor,
            unselectedLabelColor: theme.textTheme.bodySmall?.color,
            indicatorColor: mainColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: "My Events"), // Renamed for clarity
              Tab(text: "Explore"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. UPDATED FRIENDS/JOINED FEED
            const _FriendsFeedTab(),
            // 2. EXISTING PUBLIC FEED
            _PublicExploreTab(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}

// =========================================================
//  UPDATED: FRIENDS / JOINED EVENTS TAB
// =========================================================
class _FriendsFeedTab extends StatefulWidget {
  const _FriendsFeedTab();

  @override
  State<_FriendsFeedTab> createState() => _FriendsFeedTabState();
}

class _FriendsFeedTabState extends State<_FriendsFeedTab> {
  @override
  void initState() {
    super.initState();
    // Fetch joined events when this tab loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FriendProvider>(context, listen: false).fetchJoinedEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<FriendProvider>(
      builder: (context, provider, child) {
        // 1. Loading State
        // Note: checking joinedEvents.isEmpty ensures we show loader only on first fetch
        if (provider.isLoading && provider.joinedEvents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error State
        if (provider.errorMessage != null && provider.joinedEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 10),
                Text(provider.errorMessage!),
                TextButton(
                  onPressed: () => provider.fetchJoinedEvents(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        // 3. Empty State
        if (provider.joinedEvents.isEmpty) {
          return const Center(
            child: Text(
              "You haven't joined any events yet.\nCheck the Explore tab to find some!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // 4. Data State
        return RefreshIndicator(
          onRefresh: () => provider.fetchJoinedEvents(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.joinedEvents.length,
            itemBuilder: (context, index) {
              final event = provider.joinedEvents[index];

              return GestureDetector(
                onTap: () {
                  // Navigate to Event Details
                  Navigator.pushNamed(
                    context,
                    'EventDetails',
                    arguments: event.id,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Cover Image
                        Image.network(
                          event.coverImageUrl ??
                              'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Event Title
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "JOINED",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// =========================================================
//  EXISTING: PUBLIC EXPLORE TAB (UNCHANGED)
// =========================================================

class _PublicExploreTab extends StatefulWidget {
  final String searchQuery;
  const _PublicExploreTab({required this.searchQuery});

  @override
  State<_PublicExploreTab> createState() => _PublicExploreTabState();
}

class _PublicExploreTabState extends State<_PublicExploreTab> {
  final ExploreService _exploreService = ExploreService();
  final ScrollController _scrollController = ScrollController();

  final List<EventModel> _allEvents = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _pageCounter = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchPage();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // We only fetch more pages when NOT searching locally
    if (widget.searchQuery.isEmpty &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoading && _hasMore) {
        _fetchPage();
      }
    }
  }

  Future<void> _fetchPage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newEvents = await _exploreService.getPublicFeed(
        page: _pageCounter,
        size: _pageSize,
      );

      setState(() {
        _pageCounter++;
        if (newEvents.length < _pageSize) _hasMore = false;
        _allEvents.addAll(newEvents);
      });
    } catch (e) {
      debugPrint("Explore Feed Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter events locally based on the search query
    final displayedEvents = _allEvents.where((event) {
      return event.title.toLowerCase().contains(
        widget.searchQuery.toLowerCase(),
      );
    }).toList();

    if (displayedEvents.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (displayedEvents.isEmpty) {
      return const Center(child: Text("No events found"));
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      // Spinner only shows if we are on the main feed (not searching) and have more data
      itemCount:
          displayedEvents.length +
          (widget.searchQuery.isEmpty && _hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayedEvents.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = displayedEvents[index];

        return GestureDetector(
          onTap: () {
            // ✅ MATCHES 'EventDetails' in main.dart
            Navigator.pushNamed(context, 'EventDetails', arguments: event.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.coverImageUrl ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
