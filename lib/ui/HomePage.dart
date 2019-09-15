import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/Strings.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/service/ConcursoService.dart';
import 'package:palpites_da_loteria/widgets/CardConcursos.dart';
import 'package:reorderables/reorderables.dart';

import 'AppDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardConcursos> _cards;
  Concursos _concursos;

  void _onReorder(int oldIndex, int newIndex) {
    Widget movedCard = _cards.removeAt(oldIndex);
    _cards.insert(newIndex, movedCard);

    var movedConcurso = _concursos.concursosBean.removeAt(oldIndex);
    _concursos.concursosBean.insert(newIndex, movedConcurso);
    ConcursoService.save(_concursos);
  }

  void switchTheme() {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    var reorderableWrap = FutureBuilder(
      future: ConcursoService.getUsersConcursosFuture(context),
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _concursos = snapshot.data;
          _cards = _concursos.concursosBean
              .map((concurso) => CardConcursos(concurso))
              .toList();

          return Center(
            child: ReorderableWrap(
              spacing: 8.0,
              runSpacing: 8.0,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              children: _cards,
              onReorder: _onReorder,
            ),
          );
        } else {
          return Text("");
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_3
                : Icons.brightness_high),
            onPressed: switchTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: reorderableWrap,
    );
  }
}
