class FriendModel {
  final int id;
  final String fullName;
  final String username;
  final String profilePicture;

  FriendModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.profilePicture,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? "",
      username: json['username'] ?? "",
      // Matches the "profilePicture" key from your search result JSON
      profilePicture: json['profilePicture'] ?? "",
    );
  }
}
