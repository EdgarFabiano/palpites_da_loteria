import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:palpites_da_loteria/widgets/card-concursos.dart';
import 'package:reorderables/reorderables.dart';

import 'app-drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Concursos> _usersConcursosFuture;
  BannerAd _concursosBanner;
  List<CardConcursos> _cards;
  Concursos _concursos;
  double _bannerPadding = 50;

  void _onReorder(int oldIndex, int newIndex) {
    Widget movedCard = _cards.removeAt(oldIndex);
    _cards.insert(newIndex, movedCard);

    var movedConcurso = _concursos.concursosBean.removeAt(oldIndex);
    _concursos.concursosBean.insert(newIndex, movedConcurso);
    ConcursoService.save(_concursos);
  }

  void _instatiateBannerAd() {
    _concursosBanner = BannerAd(
      size: AdSize.smartBanner,
      adUnitId: AdUnits.getConcursosBannerId(),
      targetingInfo: MobileAdTargetingInfo(
    //          testDevices: [/*"30B81A47E3005ADC205D4BCECC4450E1"*/]
      ),
    );
  }

  void _showBannerAd() {
    _concursosBanner.isLoaded().then((isLoaded) {
        if (isLoaded) {
          _bannerPadding = 50;
          _concursosBanner.show();
        } else {
          _bannerPadding = 0;
          _instatiateBannerAd();
          _concursosBanner.load();
        }
    });

  }

  @override
  void initState() {
    _instatiateBannerAd();
    _concursosBanner.load();
    _showBannerAd();
    _usersConcursosFuture = ConcursoService.getUsersConcursosFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    _showBannerAd();
    var reorderableWrap = FutureBuilder(
      future: _usersConcursosFuture,
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
      body: Padding(
        padding: EdgeInsets.only(bottom: _bannerPadding),
        child: reorderableWrap,
      ),
    );
  }
}
