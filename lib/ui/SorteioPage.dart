import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/service/generator/AbstractSorteioGenerator.dart';
import 'package:palpites_da_loteria/service/generator/RandomSorteioGenerator.dart';
import 'package:palpites_da_loteria/widgets/Dezena.dart';

class SorteioPage extends StatefulWidget {
  final ConcursoBean _concurso;

  SorteioPage(this._concurso, {Key key}) : super(key: key);

  @override
  _SorteioPageState createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  List<Dezena> _dezenas = List();
  AbstractSorteioGenerator _sorteioGenerator = new RandomSorteioGenerator();

  void _sortear() {
    var concurso = widget._concurso;
    _dezenas =
        _sorteioGenerator.sortear(concurso.minSize, concurso, context).toList();
  }

  @override
  Widget build(BuildContext context) {
    _sortear();

    var dezenas = GridView(
      padding: EdgeInsets.all(20),

      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 55,
      ),
      children: _dezenas.toList(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor: widget._concurso.colorBean.getColor(context),
        title: Text(widget._concurso.name),
      ),
      body: dezenas,
    );
  }
}
