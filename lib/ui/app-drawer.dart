import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/ui/home-page.dart';
import 'package:palpites_da_loteria/ui/settings-page.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  Constants.logoTransparentAssetPath,
                  width: 100,
                ),
                Text(
                  "Palpites da loteria",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        ListTile(
          leading: Icon(Icons.view_list),
          title: Text("Concursos"),
          onTap: () {
            Navigator.of(context).pop();
            if (ModalRoute.of(context).settings.name !=
                Strings.concursosRoute) {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => HomePage()));
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Configurações"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SettingsPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Jogos salvos"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SettingsPage()));
          },
        ),
      ],
    );
  }
}