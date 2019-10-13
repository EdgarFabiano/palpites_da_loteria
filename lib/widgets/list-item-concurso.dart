import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemConcurso extends StatefulWidget {
  final ConcursoBean _concursoBean;

  ListItemConcurso(this._concursoBean, {Key key}) : super(key: key);

  ConcursoBean get concursoBean => _concursoBean;

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
            onChanged: (value) {
              setState(() {
                widget._concursoBean.enabled = value;
                ConcursoService.saveConcurso(widget._concursoBean);
                Future<SharedPreferences> preferences = SharedPreferences
                    .getInstance();
                preferences.then((onValue) {
                  onValue.setBool(
                      Constants.updateHomeSharedPreferencesKey, true);
                });
              });
            },
          )
        ],
      ),
    );
  }
}
