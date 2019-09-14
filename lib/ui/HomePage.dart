import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/widgets/CardConcursos.dart';
import 'package:reorderables/reorderables.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData switchThemeIcon = Icons.brightness_3;
  List<Widget> _tiles;

//  Future<Concursos> _loadConcursos() async {
//    return Concursos.baseline(context)
//        .then((onValue) => {
//      for (var concurso in onValue.concursosBean) {
//        _tiles.add(CardConcursos(concurso))
//      }
//    });
//  }

  @override
  void initState() {
    super.initState();
//    _loadConcursos();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Widget row = _tiles.removeAt(oldIndex);
      _tiles.insert(newIndex, row);
    });
  }

  void switchTheme() {
    var b = Theme.of(context).brightness;
    switchThemeIcon =
        b == Brightness.dark ? Icons.brightness_3 : Icons.brightness_high;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    var reorderableWrap = FutureBuilder(
      future: Concursos.getBaselineFuture(context),
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        Concursos concursos = snapshot.data;
        print(concursos.concursosBean);
        if(!snapshot.hasError) {
          return ReorderableWrap(
              spacing: 8.0,
              runSpacing: 8.0,
              minMainAxisCount: 1,
              children: concursos.concursosBean.map((e) => CardConcursos(e)).toList(),
              onReorder: _onReorder);
        } else {
          return Text("Erro");
        }

      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(switchThemeIcon),
            onPressed: switchTheme,
          ),
        ],
      ),
      body: reorderableWrap,
    );
  }
}
