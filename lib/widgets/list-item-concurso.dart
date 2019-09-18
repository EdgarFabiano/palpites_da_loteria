import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';

class ListItemConcurso extends StatefulWidget {
  final ConcursoBean _concursoBean;

  ListItemConcurso(this._concursoBean, {Key key}) : super(key: key);

  @override
  _ListItemConcursoState createState() => _ListItemConcursoState();
}

class _ListItemConcursoState extends State<ListItemConcurso> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(widget._concursoBean.name),
      leading: Icon(Icons.reorder),
      title: Row(
        children: <Widget>[
          Text(widget._concursoBean.name),
        ],
      ),
    );
  }
}
