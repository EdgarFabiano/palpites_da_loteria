import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../model/saved_game.dart';
import '../service/saved_game_service.dart';

class SavedGameEditPage extends StatefulWidget {
  final Contest contest;
  final SavedGame savedGame;
  final Function onSaved;

  SavedGameEditPage(this.contest, this.savedGame, this.onSaved, {Key? key}) : super(key: key);

  @override
  _SavedGameEditPageState createState() => _SavedGameEditPageState();
}

class _SavedGameEditPageState extends State<SavedGameEditPage> {
  SavedGameService _savedGameService = SavedGameService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: widget.contest.getColor(context),
        title: Text(buildTitle()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: Container(),
    );
  }

  String buildTitle() =>
      widget.savedGame.id == null ? "Novo jogo" : "Editar jogo";
}
