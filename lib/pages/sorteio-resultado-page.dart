
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model-export.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/widgets/popup-menu.dart';
import 'package:palpites_da_loteria/widgets/tab-resultado.dart';
import 'package:palpites_da_loteria/widgets/tab-sorteio.dart';

class SorteioResultadoPage extends StatelessWidget {
  final ConcursoBean _concurso;
  const SorteioResultadoPage(this._concurso, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabSorteio = TabSorteio(_concurso,);
    var tabResultado = TabResultado(_concurso,);

    return Padding(
      padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: _concurso.colorBean.getColor(context),
              bottom: TabBar(
                tabs: [
                  Tab(child: Text("Sorteio")),
                  Tab(child: Text("Resultado")),
                ],
              ),
              title: Text(_concurso.name),
              actions: <Widget>[
                PopUpMenu(),
              ]),
          body: TabBarView(
            children: [
              tabSorteio,
              tabResultado,
            ],
          ),
        ),
      ),
    );
  }
}
