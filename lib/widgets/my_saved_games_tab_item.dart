import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/contest.dart';

import '../model/saved_game.dart';
import '../pages/saved_game_edit_page.dart';
import '../service/format_service.dart';
import '../service/saved_game_service.dart';

typedef ContestDeletedResolver = Function(bool wasDeleted);

class MySavedGamesTabItem extends StatefulWidget {
  final Contest contest;
  final ContestDeletedResolver notifyParent;

  const MySavedGamesTabItem(
      {super.key, required this.contest, required this.notifyParent});

  @override
  _MySavedGamesTabItemState createState() => _MySavedGamesTabItemState();
}

class _MySavedGamesTabItemState extends State<MySavedGamesTabItem> {
  SavedGameService _savedGameService = SavedGameService();

  List<SavedGame> _savedGames = [];

  Future<bool> _asyncInit() async {
    _savedGames =
        await _savedGameService.getSavedGamesByContest(widget.contest);
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
          body = ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: this._savedGames.length,
            itemBuilder: (context, index) =>
                _itemToListTile(this._savedGames[index]),
          );
        }
        return Scaffold(
          floatingActionButton: _buildFloatingActionButton(),
          body: body,
        );
      },
    );
  }

  Future<void> _updateUI() async {
    _savedGames =
        await _savedGameService.getSavedGamesByContest(widget.contest);
    setState(() {});
    widget.notifyParent(_savedGames.isEmpty);
  }

  ListTile _itemToListTile(SavedGame savedGame) => ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (savedGame.title != null) Text(savedGame.title!),
            Wrap(
              children: savedGame.numbers
                  .split("|")
                  .map(
                    (e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formatarDezena(e),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: widget.contest.getColor(context),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        subtitle: Text('Criado em: ${formatarDataHora(savedGame.createdAt!)}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _showDialogConfirm(savedGame),
        ),
        iconColor: widget.contest.getColor(context),
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (BuildContext context) =>
                  SavedGameEditPage(widget.contest, savedGame, _updateUI),
              fullscreenDialog: true),
        ),
      );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute(
            builder: (BuildContext context) => SavedGameEditPage(
                widget.contest, SavedGame.empty(widget.contest.id), _updateUI),
            fullscreenDialog: true),
      ),
      child: const Icon(Icons.add, color: Colors.white),
      backgroundColor: widget.contest.getColor(context),
    );
  }

  void _showDialogConfirm(SavedGame savedGame) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text("Deseja realmente excluir o jogo?"),
            // content: Text(savedGame.numbers),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _savedGameService.deleteSavedGameById(savedGame.id!);
                  _updateUI();
                  Navigator.of(context).pop();
                },
                child: Text("Excluir"),
              ),
            ],
          ),
        );
      },
    );
  }
}
