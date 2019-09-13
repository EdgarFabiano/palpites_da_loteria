import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/widgets/CardConcursos.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData switchThemeIcon = Icons.brightness_3;

  void switchTheme() {
    var b = Theme.of(context).brightness;
    switchThemeIcon =
        b == Brightness.dark ? Icons.brightness_3 : Icons.brightness_high;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(switchThemeIcon),
              onPressed: () {
                switchTheme();
              },
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            CardConcursos(Colors.blue),
            CardConcursos(Colors.green),
            CardConcursos(Colors.pink),
            CardConcursos(Colors.yellow),
            CardConcursos(Colors.deepOrange)
          ],
        ));
  }
}
