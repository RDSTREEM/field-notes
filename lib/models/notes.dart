class Notes {
  final String id;
  final String title;
  final String notes;
  final String category;
  final DateTime createdAt;

  final String? imagePath;
  final double? latitude;
  final double? longitude;

  const Notes({
    required this.id,
    required this.title,
    required this.notes,
    required this.category,
    required this.createdAt,
    this.imagePath,
    this.latitude,
    this.longitude,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      "title": title,
      "notes": notes,
      "category": category,
      "created_at": createdAt.toUtc().toIso8601String(),
      "image_path": imagePath,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory Notes.fromMap(Map<String, Object?> map) {
    return (Notes(
      id: map["id"] as String,
      title: map["title"] as String,
      notes: map["notes"] as String,
      category: map["category"] as String,
      createdAt: DateTime.parse(map["created_at"] as String).toUtc(),
      imagePath: map['image_path'] as String,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    ));
  }
}
