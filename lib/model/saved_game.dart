// Data class for the mini savedGame application.
import 'package:palpites_da_loteria/model/contest.dart';

class SavedGame {
  final int? id;
  final int contestId;
  late final DateTime createdAt;
  String numbers;

  SavedGame({
    this.id,
    required this.contestId,
    required this.createdAt,
    required this.numbers,
  }) {
    if (this.createdAt == null) {
      this.createdAt = DateTime.now();
    }
  }

  SavedGame.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        contestId = map['contestId'] as int,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        numbers = map['numbers'] as String;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'contestId': contestId,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'numbers': numbers,
      };
}
