import 'package:flutter/material.dart';

class CardConcursos extends StatelessWidget {
  CardConcursos({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.adb),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  MaterialButton(
                    child: const Text('SHOW SNACKBAR'),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Snackbar'),
                      ));
                    },
                  ),
                  FlatButton(
                    child: const Text('HIDE SNACKBAR'),
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
