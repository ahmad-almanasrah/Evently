class FriendRequestModel {
  final int requestId;
  final String senderName;
  final String senderUsername;
  final String senderPp;

  FriendRequestModel({
    required this.requestId,
    required this.senderName,
    required this.senderUsername,
    required this.senderPp,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: json['requestId'] ?? 0,
      senderName: json['senderName'] ?? "",
      senderUsername: json['senderUsername'] ?? "",
      // Matches the "senderPp" key from your pending requests JSON
      senderPp: json['senderPp'] ?? "",
    );
  }
}