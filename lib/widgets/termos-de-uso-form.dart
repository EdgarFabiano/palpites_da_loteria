import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/ui/home-page.dart';

class TermosDeUsoForm extends StatefulWidget {
  @override
  _TermosDeusoState createState() => _TermosDeusoState();
}

class _TermosDeusoState extends State<TermosDeUsoForm> {
  void _switchTheme(BuildContext context) {
    var b = Theme.of(context).brightness;
    DynamicTheme.of(context).setBrightness(
        b == Brightness.dark ? Brightness.light : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              "Termos de uso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "O aplicativo \"Palpites da Loteria\" serve apenas para gerar e manter números para sorteios dos concursos da loteria. "
              "Não garante que os números sejam realmente sorteados nos concursos que você apostar, exonerando-se de qualquer responsabilidade para com o uso "
              "das dezenas aqui sorteadas.",
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            child: Text("Experimente o aplicativo também no modo noturno"),
          ),
          ListTile(
            leading: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.brightness_3
                : Icons.brightness_high),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modo noturno"),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
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
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("Entendi!"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
