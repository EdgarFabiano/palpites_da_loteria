import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/util/Strings.dart';
import 'package:palpites_da_loteria/widgets/card-concursos.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: new MyHomePage(title: Strings.appName),
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IconData switchThemeIcon = Icons.brightness_3;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void switchTheme() {
    var b = Theme.of(context).brightness;
    switchThemeIcon = b == Brightness.dark ? Icons.brightness_3 : Icons.brightness_high;
    DynamicTheme.of(context).setBrightness(b == Brightness.dark ? Brightness.light: Brightness.dark);
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions:<Widget>[
          IconButton(
            icon: Icon(switchThemeIcon),
            onPressed: () {
              switchTheme();
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Card(
              color: Colors.amber,
              elevation: 3,
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            CardConcursos(

            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}