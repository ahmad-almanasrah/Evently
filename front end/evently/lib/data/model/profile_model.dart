class ProfileModel {
  final String profileImageUrl;
  final String name;
  final String username;
  final int friendsCount; // Dart uses 'int', not 'Long'
  final int eventsCount;
  final int postsCount;

  ProfileModel({
    required this.profileImageUrl,
    required this.name,
    required this.username,
    required this.friendsCount,
    required this.eventsCount,
    required this.postsCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileImageUrl: json['pictureURL'] ?? "",
      name: json['name'] ?? "Unknown",
      username: json['userName'] ?? "",
      friendsCount: json['friendsCount'] ?? 0,
      eventsCount: json['galleriesCount'] ?? 0,
      postsCount: json['pictureCount'] ?? 0,
    );
  }
}
