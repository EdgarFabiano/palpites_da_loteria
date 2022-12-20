import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:provider/provider.dart';

import 'concursos_settings_change_notifier.dart';

class ListItemConcurso extends StatefulWidget {
  final Contest _contest;

  ListItemConcurso(this._contest, {Key? key}) : super(key: key);

  Contest get concursoBean => _contest;

  @override
  _ListItemConcursoState createState() => _ListItemConcursoState();
}

class _ListItemConcursoState extends State<ListItemConcurso> {
  late ConcursosSettingsChangeNotifier _concursosProvider;

  void changeEnabled() {
    setState(() {
      widget._contest.enabled = !widget._contest.enabled;
    });
    _concursosProvider.updateContest(widget._contest);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _concursosProvider =
        Provider.of<ConcursosSettingsChangeNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(widget._contest.name),
      leading: Icon(Icons.reorder),
      title: GestureDetector(
        onTap: changeEnabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  Constants.loteriasIconAssetPath,
                  width: 25,
                  color: widget._contest.getColor(context).withAlpha(255),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text("    "),
                Text(widget._contest.name)
              ],
            ),
            Switch(
              value: widget._contest.enabled,
              onChanged: (value) => changeEnabled(),
            )
          ],
        ),
      ),
    );
  }
}
