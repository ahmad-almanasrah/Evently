import 'package:evently/providers/friend-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteFriendsScreen extends StatefulWidget {
  final int eventId;
  const InviteFriendsScreen({super.key, required this.eventId});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final Set<int> _selectedIds = {};
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Fetch fresh list of friends
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FriendProvider>(context, listen: false).fetchFriendsList();
    });
  }

  Future<void> _sendInvites() async {
    if (_selectedIds.isEmpty) return;

    setState(() => _isSending = true);

    try {
      // Access the service directly via Provider
      await Provider.of<FriendProvider>(
        context,
        listen: false,
      ).friendService.inviteFriends(widget.eventId, _selectedIds.toList());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invites Sent Successfully!")),
        );
        Navigator.pop(context); // Close screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invite Friends")),
      floatingActionButton: _selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isSending ? null : _sendInvites,
              label: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text("Invite (${_selectedIds.length})"),
              icon: _isSending ? null : const Icon(Icons.send),
            )
          : null,
      body: Consumer<FriendProvider>(
        builder: (context, provider, _) {
          if (provider.friendsList.isEmpty) {
            return const Center(
              child: Text("You don't have any friends to invite yet."),
            );
          }

          return ListView.builder(
            itemCount: provider.friendsList.length,
            itemBuilder: (context, index) {
              final friend = provider.friendsList[index];
              final isSelected = _selectedIds.contains(friend.id);

              return CheckboxListTile(
                value: isSelected,
                title: Text(friend.fullName),
                subtitle: Text("@${friend.username}"),
                secondary: CircleAvatar(
                  backgroundImage: NetworkImage(friend.profilePicture),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedIds.add(friend.id);
                    } else {
                      _selectedIds.remove(friend.id);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
