import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';

import '../defaults/strings.dart';
import '../model/contest.dart';
import '../widgets/contests_settings_change_notifier.dart';
import '../widgets/list_tem_concurso.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<ListItemContest> _items = [];
  GroupButtonController _buttonGroupController = GroupButtonController();
  var _isDark = false;

  void _switchTheme(BuildContext context, String value) {
    setState(() {
      var dynamicTheme = EasyDynamicTheme.of(context);
      switch (value) {
        case 'Claro':
          dynamicTheme.changeTheme(dark: false);
          break;
        case 'Escuro':
          dynamicTheme.changeTheme(dark: true);
          break;
        default:
          dynamicTheme.changeTheme(dynamic: true);
          break;
      }
      _isDark = Theme.of(context).brightness == Brightness.dark;
    });
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
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var index = EasyDynamicTheme.of(context).themeMode!.index;
    _buttonGroupController.selectIndex(index);
    _isDark = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    var reorderableListView;
    var contestProvider = Provider.of<ContestsSettingsChangeNotifier>(context);
    List<Contest> _contests = contestProvider.getContests();

    _items = _contests
        .map((c) => ListItemContest(
              c,
              key: Key("listItem" + c.name),
            ))
        .toList();
    reorderableListView = ReorderableListView(
      children: _items,
      onReorder: (start, current) {
        _onReorder(start, current);
        contestProvider.onReorder(start, current);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
      ),
      body: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading:
                    Icon(_isDark ? Icons.brightness_3 : Icons.brightness_high),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Tema"),
                  ],
                ),
                subtitle: GroupButton(
                  controller: _buttonGroupController,
                  onSelected: (value, index, isSelected) {
                    _buttonGroupController.unselectAll();
                    _buttonGroupController.selectIndex(index);
                    _switchTheme(context, value);
                  },
                  buttons: ['Auto', 'Claro', 'Escuro'],
                  options: GroupButtonOptions(
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    unselectedTextStyle: Theme.of(context).textTheme.bodyMedium,
                    borderRadius: BorderRadius.circular(10),
                    mainGroupAlignment: MainGroupAlignment.start,
                    crossGroupAlignment: CrossGroupAlignment.start,
                    groupRunAlignment: GroupRunAlignment.start,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Tela inicial e Notificações"),
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
    );
  }
}
