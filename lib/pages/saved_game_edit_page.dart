import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../model/saved_game.dart';
import '../service/format_service.dart';
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
  var _isDezenasExpanded = false;
  var _game = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.savedGame.title ?? '';
    _notesController.text = widget.savedGame.notes ?? '';
    if (widget.savedGame.numbers.isNotEmpty)
      _game =
          widget.savedGame.numbers.split("|").map((e) => int.parse(e)).toList();
    _isDezenasExpanded = widget.savedGame.id == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: widget.contest.getColor(context),
        title: ListTile(
          textColor: Colors.white,
          title: Text(buildTitle()),
          subtitle: Text(widget.contest.name),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: buildForm(),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextFieldTitle(),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: buildTextFieldNotes(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text('Dezenas (${_game.length})'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: buildContainerDezenas(),
          ),
        ],
      ),
    );
  }

  Container buildContainerDezenas() {
    return Container(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isDezenasExpanded = !_isDezenasExpanded;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (!isExpanded) {
                return ListTile(
                  title: Wrap(
                    children: _game
                        .map(
                          (e) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                formatarDezena(e.toString()),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: widget.contest.getColor(context),
                          ),
                        )
                        .toList(),
                  ),
                );
              } else {
                var title ='';
                if (widget.contest.minSize != widget.contest.maxSize) {

                title = 'Selecione de ${widget.contest.minSize} a ${widget.contest.maxSize} dezenas';
                } else {
                  title = 'Selecione ${widget.contest.maxSize} dezenas';
                }
                return ListTile(
                  title: Text(
                    title,
                    overflow: TextOverflow.fade,
                  ),
                );
              }
            },
            body: buildContainerDezenasEditor(),
            isExpanded: _isDezenasExpanded,
          ),
        ],
      ),
    );
  }

  Container buildContainerDezenasEditor() {
    var options = [];
    for (int i = widget.contest.spaceStart; i <= widget.contest.spaceEnd; i++) {
      options.add(i);
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Wrap(
          children: options.map(
            (e) {
              if (_isInGame(e)) {
                return GestureDetector(
                  onTap: () => _removeFromGame(e),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatarDezena(e.toString()),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: widget.contest.getColor(context),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => _addToGame(e),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formatarDezena(e.toString()),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  bool _canAdd() {
    return _game.length < widget.contest.maxSize;
  }

  _addToGame(e) {
    if (_canAdd()) {
      _game.add(e);
    } else {
      _game.removeLast();
      _game.add(e);
    }
    _updateSavedGameNumbers();
    setState(() {});
  }

  void _updateSavedGameNumbers() {
    if (_game.isNotEmpty) {
      widget.savedGame.numbers =
          _savedGameService.getSortedNumbers(_game.join('|'));
    } else {
      widget.savedGame.numbers = '';
    }
  }

  _removeFromGame(int value) {
    _game.remove(value);
    _updateSavedGameNumbers();
    setState(() {});
  }

  bool _isInGame(int value) {
    return _game.contains(value);
  }

  TextField buildTextFieldNotes() {
    return TextField(
      controller: _notesController,
      minLines: 3,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Anotações",
      ),
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  TextField buildTextFieldTitle() {
    return TextField(
      maxLength: 50,
      controller: _titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Título",
      ),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
    );
  }

  String buildTitle() =>
      widget.savedGame.id == null ? "Novo jogo" : "Editar jogo";

  Future<void> _saveGame() async {
    var validationMessage = validateGame();
    if (validationMessage == '') {
      widget.savedGame.title = _titleController.value.text;
      widget.savedGame.notes = _notesController.value.text;
      await _savedGameService.createOrUpdateSavedGame(widget.savedGame);
      widget.onSaved();
      Navigator.of(context).pop();
    } else {
      var snackBar = SnackBar(
        content: Text(validationMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String validateGame() {
    var validationMessage = '';
    if (_game.length < widget.contest.minSize) {
      validationMessage =
          'Escolha pelo menos ${widget.contest.minSize} dezenas';
    } else if (_game.length > widget.contest.maxSize) {
      validationMessage = 'Escolha no máximo ${widget.contest.maxSize} dezenas';
    }
    return validationMessage;
  }
}
