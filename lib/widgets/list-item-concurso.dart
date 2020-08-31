import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:provider/provider.dart';

import 'concursos-settings-change-notifier.dart';

class ListItemConcurso extends StatefulWidget {
  final ConcursoBean _concursoBean;
  final Concursos _concursos;

  ListItemConcurso(this._concursoBean, this._concursos, {Key key}) : super(key: key);

  ConcursoBean get concursoBean => _concursoBean;

  @override
  _ListItemConcursoState createState() => _ListItemConcursoState();
}

class _ListItemConcursoState extends State<ListItemConcurso> {

  void changeEnabled(ConcursosSettingsChangeNotifier concursosProvider) {
    return setState(() {
              widget._concursoBean.enabled = !widget._concursoBean.enabled;
              var index = widget._concursos.concursosBeanList.indexOf(widget.concursoBean);
              widget._concursos.concursosBeanList.fillRange(index, index, widget.concursoBean);
              concursosProvider.setConcursos(widget._concursos);
            });
  }

  @override
  Widget build(BuildContext context) {
    var concursosProvider = Provider.of<ConcursosSettingsChangeNotifier>(context);
    return ListTile(
      key: Key(widget._concursoBean.name),
      leading: Icon(Icons.reorder),
      title: GestureDetector(
        onTap: () => changeEnabled( concursosProvider),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  Constants.loteriasIconAssetPath,
                  width: 25,
                  color: widget._concursoBean.colorBean.getColor(context)
                      .withAlpha(255),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text("    "),
                Text(widget._concursoBean.name)
              ],
            ),
            Switch(
              value: widget._concursoBean.enabled,
              onChanged: (value) => changeEnabled( concursosProvider),
            )
          ],
        ),
      ),
    );
  }
}
