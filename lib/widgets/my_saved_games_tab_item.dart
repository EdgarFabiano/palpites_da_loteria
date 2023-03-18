import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/contest.dart';
import 'package:palpites_da_loteria/service/contest_service.dart';

import '../model/saved_game.dart';
import '../service/format_service.dart';
import '../service/saved_game_service.dart';

class MySavedGamesTabItem extends StatefulWidget {
  final Contest contest;
  final Function notifyParent;

  const MySavedGamesTabItem(
      {super.key, required this.contest, required this.notifyParent});

  @override
  _MySavedGamesTabItemState createState() => _MySavedGamesTabItemState();
}

class _MySavedGamesTabItemState extends State<MySavedGamesTabItem> {
  SavedGameService _savedGameService = SavedGameService();

  List<SavedGame> _savedGames = [];

  Future<bool> _asyncInit() async {
    _savedGames = await _savedGameService.getSavedGames(widget.contest);
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
        return SafeArea(
          child: Scaffold(
            floatingActionButton: _buildFloatingActionButton(),
            body: body,
            // floatingActionButton: _buildFloatingActionButton(),
          ),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    _savedGames = await _savedGameService.getSavedGames(widget.contest);
    setState(() {});
    widget.notifyParent();
  }

  ListTile _itemToListTile(SavedGame savedGame) => ListTile(
        title: Wrap(
          children: savedGame.numbers
              .split("|")
              .map(
                (e) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e, style: TextStyle(color: Colors.white)),
                  ),
                  color: widget.contest.getColor(context),
                ),
              )
              .toList(),
        ),
        subtitle: Text('Criado em: ${formatarDataHora(savedGame.createdAt)}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await _savedGameService.deleteSavedGame(savedGame);
            _updateUI();
          },
        ),
        iconColor: widget.contest.getColor(context),
      );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await _savedGameService.addSavedGame(
          SavedGame(
            contestId: widget.contest.id,
            numbers: '1|2|3|4|5|6|7|8',
            createdAt: DateTime.now(),
          ),
        );
        _updateUI();
      },
      child: const Icon(Icons.add, color: Colors.white),
      backgroundColor: widget.contest.getColor(context),
    );
  }
}
