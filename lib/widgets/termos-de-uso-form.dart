import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/ui/home-page.dart';

class TermosDeUsoForm extends StatefulWidget {
  TermosDeUsoForm();

  @override
  _TermosDeusoState createState() => _TermosDeusoState();
}

class _TermosDeusoState extends State<TermosDeUsoForm> {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Termos de uso",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "O aplicativo \"" + Strings.appName +
                  "\" serve apenas para gerar e manter números para sorteios dos concursos da loteria. "
                      "Não garante que os números sejam realmente sorteados nos concursos que você apostar, exonerando-se de qualquer responsabilidade para com o uso "
                      "das dezenas aqui sorteadas.",
              textAlign: TextAlign.justify,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Política de Privacidade",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Esta Política de Privacidade serve para descrever como é fluxo de informação pelo aplicativo \"" +
                  Strings.appName + "\", e como a utilizaremos."
                  "Nenhum dado pessoal sobre você ou seu dispositivo será coletado no ato do download ou utilização do aplicativo. "
                  "Os anúncios aqui exibidos são mostrados de acordo com o seu perfil de usuário. "
                  "O Google se encarrega de trazer todas as informações dos anúncios, bem como manter os dados para estatísticas de cliques, visualização, etc. ",
              textAlign: TextAlign.justify,
            ),
          ),
        ],
        )
    );
  }
}
