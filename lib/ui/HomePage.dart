import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/AdUnits.dart';
import 'package:palpites_da_loteria/defaults/Strings.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/service/ConcursoService.dart';
import 'package:palpites_da_loteria/widgets/CardConcursos.dart';
import 'package:reorderables/reorderables.dart';

import 'AppDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _concursosBanner;
  List<CardConcursos> _cards;
  Concursos _concursos;

  void _onReorder(int oldIndex, int newIndex) {
    Widget movedCard = _cards.removeAt(oldIndex);
    _cards.insert(newIndex, movedCard);

    var movedConcurso = _concursos.concursosBean.removeAt(oldIndex);
    _concursos.concursosBean.insert(newIndex, movedConcurso);
    ConcursoService.save(_concursos);
  }

  @override
  void initState() {
     _concursosBanner = BannerAd(
      size: AdSize.smartBanner,
      adUnitId: AdUnits.getConcursosBannerId(),
      targetingInfo: MobileAdTargetingInfo(testDevices: ["30B81A47E3005ADC205D4BCECC4450E1"]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _concursosBanner.load();
    _concursosBanner.show();
    var reorderableWrap = FutureBuilder(
      future: ConcursoService.getUsersConcursosFuture(context),
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _concursos = snapshot.data;
          _cards = _concursos.concursosBean
              .map((concurso) => CardConcursos(concurso))
              .toList();

          return Center(
            child: ReorderableWrap(
              spacing: 8.0,
              runSpacing: 8.0,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              children: _cards,
              onReorder: _onReorder,
            ),
          );
        } else {
          return Text("Recarregar para preencher");
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: reorderableWrap,
    );
  }

}
