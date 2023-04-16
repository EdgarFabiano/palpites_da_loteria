import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../model/saved_game.dart';
import '../service/saved_game_service.dart';

class SavedGameEditPage extends StatefulWidget {
  final Contest contest;
  final SavedGame savedGame;
  final Function onSaved;

  SavedGameEditPage(this.contest, this.savedGame, this.onSaved, {Key? key})
      : super(key: key);

  @override
  _SavedGameEditPageState createState() => _SavedGameEditPageState();
}

class _SavedGameEditPageState extends State<SavedGameEditPage> {
  SavedGameService _savedGameService = SavedGameService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();


  @override
  void initState() {
    _titleController.text = widget.savedGame.title ?? '';
    _notesController.text = widget.savedGame.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: widget.contest.getColor(context),
        title: Text(buildTitle()),
        actions: <Widget>[
          TextButton(
            onPressed: _saveGame,
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Título",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Anotações",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Dezenas'),
              )
            ],
          ),
        ),
      ),
    );
  }

  String buildTitle() =>
      widget.savedGame.id == null ? "Novo jogo" : "Editar jogo";

  Future<void> _saveGame() async {
    widget.savedGame.title = _titleController.value.text;
    widget.savedGame.notes = _notesController.value.text;
    await _savedGameService.updateSavedGame(widget.savedGame);
    widget.onSaved();
    Navigator.of(context).pop();
  }
}
