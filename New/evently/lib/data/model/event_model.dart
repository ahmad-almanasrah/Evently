class EventModel {
  final int id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final bool isPublic;
  final String? coverImageUrl; // ✅ Added '?' to make it nullable

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    required this.isPublic,
    this.coverImageUrl, // ✅ This is now fine because the field above is nullable
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'],
      eventDate: DateTime.parse(json['eventDate']),
      isPublic: json['isPublic'] ?? true,
      // ✅ Improved null check for the string "null" vs actual null
      coverImageUrl:
          (json['coverImageUrl'] == null || json['coverImageUrl'] == "null")
          ? null
          : json['coverImageUrl'],
    );
  }
}
