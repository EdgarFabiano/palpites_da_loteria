import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/concursos_settings_change_notifier.dart';
import 'package:palpites_da_loteria/widgets/list_tem_concurso.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<ListItemConcurso> _items;

  void _switchTheme(BuildContext context) {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  void _onReorder(int start, int current) {
    setState(() {
      // dragging from top to bottom
      if (start < current) {
        int end = current - 1;
        var startItem = _items[start];
        int i = 0;
        int local = start;
        do {
          _items[local] = _items[++local];
          i++;
        } while (i < end - start);
        _items[end] = startItem;
      }
      // dragging from bottom to top
      else if (start > current) {
        var startItem = _items[start];
        for (int i = start; i > current; i--) {
          _items[i] = _items[i - 1];
        }
        _items[current] = startItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var reorderableListView;

    var concursosProvider = Provider.of<ConcursosSettingsChangeNotifier>(context);
    Concursos _concursos = concursosProvider.getConcursos();

    if (concursosProvider != null && _concursos != null) {
      _items = _concursos.concursosBeanList
          .map((concurso) =>
          ListItemConcurso(concurso, _concursos, key: Key("listItem" + concurso.name),))
          .toList();
      reorderableListView = ReorderableListView(
        children: _items,
        onReorder: (start, current) {
          _onReorder(start, current);
          concursosProvider.onReorder(start, current);
        },
      );
    } else {
      reorderableListView = Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? Icons.brightness_3
                      : Icons.brightness_high),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Modo noturno"),
                      Switch(
                        value: Theme
                            .of(context)
                            .brightness == Brightness.dark,
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
                SizedBox(
                  height: 500,
                  child: reorderableListView,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
