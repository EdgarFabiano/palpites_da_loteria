import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/Constants.dart';
import 'package:palpites_da_loteria/ui/HomePage.dart';
import 'package:palpites_da_loteria/widgets/IconTextRow.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset(Constants.logoTransparentAssetPath, width: 100,),
                Text("Palpites da loteria")
              ],
            ),
          ),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        ListTile(
          title: IconTextRow(Icons.view_list, "Concursos"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        ListTile(
          title: IconTextRow(Icons.settings, "Configurações"),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );
  }
}
