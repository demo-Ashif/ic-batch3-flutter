class Task {
  final int? id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Task({this.id, required this.title, this.isDone = false, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  Task copyWith({int? id, String? title, bool? isDone, DateTime? createdAt}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  //SQLite <-> Map

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'is_done': isDone ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    isDone: (map['is_done'] as int) == 1,
    createdAt:
    DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
  );
}
