import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/tab_resultado.dart';
import 'package:palpites_da_loteria/widgets/tab_sorteio.dart';
import 'package:share_plus/share_plus.dart';

import '../defaults/constants.dart';
import '../model/loteria_banner_ad.dart';

class SorteioResultadoPage extends StatefulWidget {
  final Contest _contest;

  SorteioResultadoPage(this._contest, {Key? key}) : super(key: key);

  @override
  _SorteioResultadoPageState createState() => _SorteioResultadoPageState();
}

class _SorteioResultadoPageState extends State<SorteioResultadoPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = <Tab>[
    Tab(child: Text("Sorteio")),
    Tab(child: Text("Resultado")),
  ];
  int _activeTabIndex = 0;
  TabController? _tabController;
  ResultadoAPI? _resultado;
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.sorteioBannerId);

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController!.index;
    });
  }

  void refreshResultado(ResultadoAPI? resultadoAPI) {
    setState(() {
      _resultado = resultadoAPI;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  void dispose() {
    print('Disposing $_tabController');
    _tabController!.dispose();
    print('Disposing $_bannerAd');
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabSorteio = TabSorteio(widget._contest);
    var tabResultado = TabResultado(widget._contest, refreshResultado);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: widget._contest.getColor(context),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              title: Text(widget._contest.name),
              actions: <Widget>[
                _activeTabIndex == 1 && _resultado != null
                    ? IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Compartilhar resultado',
                        onPressed: () {
                          Share.share(_resultado!.shareString());
                        },
                      )
                    : SizedBox.shrink(),
              ]),
          body: Column(
            children: [
              Flexible(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    tabSorteio,
                    tabResultado,
                  ],
                ),
              ),
              AdMobService.getBannerAdWidget(_bannerAd),
            ],
          ),
        ),
      ),
    );
  }
}
