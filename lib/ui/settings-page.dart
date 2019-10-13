import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:palpites_da_loteria/widgets/list-item-concurso.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<ListItemConcurso> _items;
  Concursos _concursos;
  Widget _reorderableListView;

  void _switchTheme(BuildContext context) {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  void _onReorder(int start, int current) {
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

    _concursos.concursosBean.clear();
    _items.forEach((listitem) {
      _concursos.concursosBean.add(listitem.concursoBean);
    });
    ConcursoService.saveConcursos(_concursos);
    setState(() {
      Future<SharedPreferences> preferences = SharedPreferences.getInstance();
      preferences.then((onValue) {
        onValue.setBool(Constants.updateHomeSharedPreferencesKey, true);
      });
    });
  }

  @override
  void initState() {
    _reorderableListView = FutureBuilder(
      key: Key("future"),
      future: ConcursoService.getUsersConcursosFuture(context),
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          _concursos = snapshot.data;
          _items = _concursos.concursosBean
              .map((concurso) =>
              ListItemConcurso(concurso, key: Key("listItem" + concurso.name),))
              .toList();

          return ReorderableListView(
            children: _items,
            onReorder: _onReorder,
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
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
                  child: _reorderableListView,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
