import 'package:flutter/cupertino.dart';
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
    AdUnits.instatiateBannerAd();
    AdUnits.concursosBanner.load();
    AdUnits.showBannerAd();
    _usersConcursosFuture = ConcursoService.getUsersConcursosFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    AdUnits.showBannerAd();
    var reorderableWrap = FutureBuilder(
      future: _usersConcursosFuture,
      builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _concursos = snapshot.data;
          _cards = _concursos.concursosBean
              .map((concurso) => CardConcursos(concurso))
              .toList();

          return Center(
            child: GridView(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
              ),
              children: _cards,
            )
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
        padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
        child: reorderableWrap,
      ),
    );
  }
}
