import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';

import 'AppDrawer.dart';

class SorteioPage extends StatefulWidget {
  final ConcursoBean _concurso;

  const SorteioPage(this._concurso, {Key key}) : super(key: key);

  @override
  _SorteioPageState createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor: widget._concurso.colorBean.getColor(context),
        title: Text(widget._concurso.name),
      ),
      body: Text("deu certo"),
    );
  }
}
