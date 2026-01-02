class EventDetailsModel {
  final int id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final DateTime createdDate;
  final bool isPublic;
  final String creatorName;
  final String? creatorProfileImage;
  final List<String> photos;
  final int photoCount;
  final bool isOwner;

  EventDetailsModel({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    required this.createdDate,
    required this.isPublic,
    required this.creatorName,
    this.creatorProfileImage,
    required this.photos,
    required this.photoCount,
    required this.isOwner,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      createdDate: DateTime.parse(json['createdDate']),
      // Backend sends "isPublic", ensure map key matches
      isPublic: json['isPublic'] ?? false,
      creatorName: json['creatorName'],
      creatorProfileImage: json['creatorProfileImage'],
      // Safely convert list
      photos: List<String>.from(json['photos'] ?? []),
      photoCount: json['photoCount'] ?? 0,
      isOwner: json['isOwner'] ?? false,
    );
  }
}
