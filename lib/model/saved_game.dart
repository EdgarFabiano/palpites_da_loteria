// Data class for the mini savedGame application.
import 'package:palpites_da_loteria/model/contest.dart';

class SavedGame {
  final int? id;
  final int contestId;
  DateTime? createdAt;
  String numbers;
  String? title;
  String? notes;

  SavedGame(
      {this.id,
      required this.contestId,
      this.createdAt,
      required this.numbers,
      this.title,
      this.notes}) {
    if (this.createdAt == null) {
      this.createdAt = DateTime.now();
    }
  }

  static SavedGame empty(int contestId) {
    return SavedGame(contestId: contestId, numbers: '');
  }

  SavedGame.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        contestId = map['contestId'] as int,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        numbers = map['numbers'] as String,
        title = map['title'] as String?,
        notes = map['notes'] as String?;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'contestId': contestId,
        'createdAt': createdAt?.millisecondsSinceEpoch,
        'numbers': numbers,
        'title': title,
        'notes': notes,
      };

  @override
  String toString() {
    return 'SavedGame{id: $id, contestId: $contestId, numbers: $numbers, title: $title}';
  }
}
