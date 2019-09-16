import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/Constants.dart';
import 'package:palpites_da_loteria/ui/HomePage.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void _switchTheme(BuildContext context) {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    bool isSwitched = Theme.of(context).brightness == Brightness.dark;

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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Configurações"),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          leading: Icon(Theme.of(context).brightness == Brightness.dark
              ? Icons.brightness_3
              : Icons.brightness_high),
          title: Row(
            children: <Widget>[
              Text("Modo noturno"),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  _switchTheme(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
