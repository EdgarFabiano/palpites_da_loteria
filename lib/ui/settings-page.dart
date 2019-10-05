import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:palpites_da_loteria/widgets/list-item-concurso.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<Concursos> _usersConcursosFuture;
  List<ListItemConcurso> _items;
  Concursos _concursos;

  void _onReorder(int oldIndex, int newIndex) {
    Widget movedCard = _items.removeAt(oldIndex);
    _items.insert(newIndex, movedCard);

    var movedConcurso = _concursos.concursosBean.removeAt(oldIndex);
    _concursos.concursosBean.insert(newIndex, movedConcurso);
    ConcursoService.save(_concursos);
  }

  void _switchTheme(BuildContext context) {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }


  @override
  void initState() {
    _usersConcursosFuture = ConcursoService.getUsersConcursosFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    var reorderableListView = FutureBuilder(
      key: Key("future"),
      future: _usersConcursosFuture,
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          _concursos = snapshot.data;
          _items = _concursos.concursosBean
              .map((concurso) => ListItemConcurso(concurso, key: Key("listItem"),))
              .toList();

          return ReorderableListView(
            children: _items,
            onReorder: _onReorder,
          );
        } else {
          return Text("Recarregar para preencher");
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
      ),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(Theme.of(context).brightness == Brightness.dark
              ? Icons.brightness_3
              : Icons.brightness_high),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Modo noturno"),
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  _switchTheme(context);
                },
              ),
            ],
          ),
          onTap: () {
            _switchTheme(context);
          },
        ),
        Divider(),
        ListTile(
          title: Text("Tela inicial"),
        ),
        Divider(),
//        reorderableListView
      ]),
    );
  }
}
