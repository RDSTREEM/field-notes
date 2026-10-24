class Notes {
  final String id;
  final String title;
  final String notes;
  final String category;
  final DateTime createdAt;

  const Notes({
    required this.id,
    required this.title,
    required this.notes,
    required this.category,
    required this.createdAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      "title": title,
      "notes": notes,
      "category": category,
      "created_at": createdAt.toUtc().toIso8601String(),
    };
  }

  factory Notes.fromMap(Map<String, Object?> map) {
    return (Notes(
      id: map["id"] as String,
      title: map["title"] as String,
      notes: map["notes"] as String,
      category: map["category"] as String,
      createdAt: DateTime.parse(map["created_at"] as String).toUtc(),
    ));
  }
}
