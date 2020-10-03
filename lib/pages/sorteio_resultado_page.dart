import 'dart:async';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/popup_menu.dart';
import 'package:palpites_da_loteria/widgets/tab_resultado.dart';
import 'package:palpites_da_loteria/widgets/tab_sorteio.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/service/loteria_api_service.dart';
import 'package:share/share.dart';

DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
Options _cacheOptions =
    buildCacheOptions(Duration(days: 7), forceRefresh: true);
Dio _dio = Dio();

Resultado parseResultado(Map<String, dynamic> responseBody) {
  return Resultado.fromJson(responseBody);
}

class SorteioResultadoPage extends StatefulWidget {
  final ConcursoBean _concurso;

  SorteioResultadoPage(this._concurso, {Key key}) : super(key: key);

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
  TabController _tabController;
  Resultado _resultado;

  fetchResultado(String concursoName) async {
    var url = LoteriaAPIService.getEndpointFor(concursoName);
    Response response = await _dio.get(url, options: _cacheOptions);

    if (response.statusCode == 200 && response.data is Map) {
      compute(parseResultado, response.data as Map<String, dynamic>)
          .then((value) => {
        _resultado = value
      }).whenComplete(() => setState(() {}));
    }
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(_dioCacheManager.interceptor);
    fetchResultado(widget._concurso.name);
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(_setActiveTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabSorteio = TabSorteio(
      widget._concurso,
    );
    var tabResultado = TabResultado(
      widget._concurso,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: widget._concurso.colorBean.getColor(context),
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              title: Text(widget._concurso.name),
              actions: <Widget>[
                _activeTabIndex == 0 ? PopUpMenu() : SizedBox.shrink(),
                _activeTabIndex == 1 && _resultado != null
                    ? IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Compartilhar resultado',
                        onPressed: () {
                          Share.share(_resultado?.shareString());
                        },
                      )
                    : SizedBox.shrink(),
              ]),
          body: TabBarView(
            controller: _tabController,
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
