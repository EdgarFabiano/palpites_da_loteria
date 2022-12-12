// Data class for the mini savedGame application.
class SavedGame {
  final int? id;
  final String content;
  // SQLite doesn't supprot boolean. Use INTEGER/BIT (0/1 values).
  final bool isDone;
  // SQLite doesn't supprot DateTime. Store them as INTEGER (millisSinceEpoch).
  final DateTime createdAt;

  SavedGame({
    this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
  });

  SavedGame.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        content = map['content'] as String,
        isDone = map['isDone'] == 1,
        createdAt =
        DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int);

  Map<String, dynamic> toJsonMap() => {
    'id': id,
    'content': content,
    'isDone': isDone ? 1 : 0,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
}