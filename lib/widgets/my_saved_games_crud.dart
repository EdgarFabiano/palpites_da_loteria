import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../model/saved_game.dart';
import '../service/saved_game_service.dart';

class SqliteExample extends StatefulWidget {
  const SqliteExample({super.key});

  @override
  _SqliteExampleState createState() => _SqliteExampleState();
}

class _SqliteExampleState extends State<SqliteExample> {
  SavedGameService _savedGameService = SavedGameService();
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  List<SavedGame> _savedGames = [];

  Future<bool> _asyncInit() async {
    // Avoid this function to be called multiple times,
    // cf. https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
    await _memoizer.runOnce(() async {
      await _savedGameService.initDb();
      _savedGames = await _savedGameService.getSavedGames();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var body;
        if (this._savedGames.isEmpty) {
          body = const Center(
            child: Text("Nenhum jogo salvo"),
          );
        } else {
          body = ListView(
            children: this._savedGames.map(_itemToListTile).toList(),
          );
        }
        return Scaffold(
          body: body,
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    _savedGames = await _savedGameService.getSavedGames();
    setState(() {});
  }

  ListTile _itemToListTile(SavedGame savedGame) => ListTile(
    title: Text(
      savedGame.content,
      style: TextStyle(
        fontStyle: savedGame.isDone ? FontStyle.italic : null,
        color: savedGame.isDone ? Colors.grey : null,
        decoration: savedGame.isDone ? TextDecoration.lineThrough : null,
      ),
    ),
    subtitle: Text('id=${savedGame.id}\ncreated at ${savedGame.createdAt}'),
    isThreeLine: true,
    leading: IconButton(
      icon: Icon(
        savedGame.isDone ? Icons.check_box : Icons.check_box_outline_blank,
      ),
      onPressed: () async {
        await _savedGameService.toggleSavedGame(savedGame);
        _updateUI();
      },
    ),
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        await _savedGameService.deleteSavedGame(savedGame);
        _updateUI();
      },
    ),
  );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await _savedGameService.addSavedGame(
          SavedGame(
            content: "Bla",
            createdAt: DateTime.now(),
          ),
        );
        _updateUI();
      },
      child: const Icon(Icons.add),
    );
  }
}
