import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:palpites_da_loteria/widgets/card-concursos.dart';
import 'package:palpites_da_loteria/widgets/termos-de-uso-form.dart';

import 'app-drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Concursos> _usersConcursosFuture;
  List<CardConcursos> _cards;
  Concursos _concursos;

  @override
  void initState() {
    AdUnits.instatiateBannerAd();
    AdUnits.concursosBanner.load();
    AdUnits.showBannerAd();
    _usersConcursosFuture = ConcursoService.getUsersConcursosFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    AdUnits.showBannerAd();
    var gridView = FutureBuilder(
      future: _usersConcursosFuture,
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _concursos = snapshot.data;
          _cards = _concursos.concursosBean
              .map((concurso) => CardConcursos(concurso))
              .toList();

          var mediaQueryData = MediaQuery.of(context);
          var isPortrait = mediaQueryData.orientation == Orientation.portrait;

          var screenWidth = mediaQueryData.size.width;
          var portraitSize = screenWidth / 2;
          var landscapeSize = screenWidth / 4;
          var tileSize = isPortrait ?
          (portraitSize > Constants.tileMaxSize ? Constants.tileMaxSize: portraitSize)
              : (landscapeSize > Constants.tileMaxSize ? Constants.tileMaxSize: landscapeSize) ;

          var spacing = mediaQueryData.size.height / 100;
          return Center(
              child: GridView(
            padding: EdgeInsets.all(spacing),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              maxCrossAxisExtent: tileSize,
            ),
            children: _cards,
          ));
        } else {
          return TermosDeUsoForm();
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
        padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
        child: gridView,
      ),
    );
  }
}
