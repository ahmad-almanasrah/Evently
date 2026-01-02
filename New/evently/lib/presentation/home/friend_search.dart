import 'package:evently/providers/friend-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load pending requests immediately when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendProvider>().fetchPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friendProvider = context.watch<FriendProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Find Friends"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: Column(
        children: [
          // --- 1. SEARCH INPUT ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => friendProvider.searchUsers(val),
              decoration: InputDecoration(
                hintText: "Search username or name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                // --- 2. PENDING REQUESTS SECTION ---
                if (friendProvider.pendingRequests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "Pending Requests (${friendProvider.pendingRequests.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...friendProvider.pendingRequests.map(
                    (req) => ListTile(
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
                            onPressed: () => friendProvider.respondToRequest(
                              req.requestId,
                              "accept",
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => friendProvider.respondToRequest(
                              req.requestId,
                              "reject",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],

                // --- 3. SEARCH RESULTS ---
                if (friendProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (friendProvider.searchResults.isEmpty &&
                    _searchController.text.isNotEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No users found."),
                    ),
                  )
                else
                  ...friendProvider.searchResults.map(
                    (user) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePicture),
                      ),
                      title: Text(user.fullName),
                      subtitle: Text("@${user.username}"),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          friendProvider.sendRequest(user.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Request sent to ${user.username}"),
                            ),
                          );
                        },
                        child: const Text("Add"),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
