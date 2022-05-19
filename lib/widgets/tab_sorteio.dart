import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:palpites_da_loteria/model/enum/filtro_periodo.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/format_service.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

import '../model/enum/estrategia_geracao.dart';
import '../model/sorteio_frequencia.dart';
import 'dezenas_loading.dart';

class TabSorteio extends StatefulWidget {
  final ConcursoBean concursoBean;

  const TabSorteio(this.concursoBean, {Key? key}) : super(key: key);

  @override
  _TabSorteioState createState() => _TabSorteioState();
}

class _TabSorteioState extends State<TabSorteio>
    with AutomaticKeepAliveClientMixin {
  EstrategiaGeracao estrategiaGeracao = EstrategiaGeracao.ALEATORIO;
  AbstractSorteioGenerator _sorteioGenerator =
      EstrategiaGeracao.ALEATORIO.sorteioGenerator;
  double _numeroDeDezenasASortear = 0;
  int _chance = 3;
  Future<SorteioFrequencia>? _futureSorteio;
  GroupButtonController _buttonGroupController = GroupButtonController();
  FiltroPeriodo _dropdownValueFiltroPeriodo = FiltroPeriodo.TRES_MESES;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  DateTimeRange _dateTimeRange =
  DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void _sortear(double increment) {
    _numeroDeDezenasASortear += increment;
    _futureSorteio = _sorteioGenerator.sortear(
        widget.concursoBean, _numeroDeDezenasASortear.toInt(), _dateTimeRange);
  }

  void _sortearComAnuncio(double increment) {
    setState(() {
      _sortear(increment);
      _chance++;
      if (_chance >= 5) {
        AdMobService.showSorteioInterstitialAd();
        _chance = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    AdMobService.createSorteioInterstitialAd();
    _buttonGroupController.selectIndex(0);
    WidgetsBinding.instance?.addPostFrameCallback(((timeStamp) => _sortear(0)));
    _numeroDeDezenasASortear = widget.concursoBean.minSize.toDouble();
    _updateDateTimeRange(_dropdownValueFiltroPeriodo.startDate, _dropdownValueFiltroPeriodo.endDate);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var refreshButton = RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        label: Text(
          "Gerar novamente",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: widget.concursoBean.colorBean.getColor(context),
        onPressed: () => _sortearComAnuncio(0));

    var minSize = widget.concursoBean.minSize.toDouble();
    var maxSize = widget.concursoBean.maxSize.toDouble();
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Column(
      children: [
        Visibility(
          visible: maxSize != minSize,
          child: Padding(
            padding: EdgeInsets.only(top: 5, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible:
                  _numeroDeDezenasASortear > widget.concursoBean.minSize,
                  child: FlatButton.icon(
                      onPressed: () =>
                          setState(() {
                            _sortear(-1);
                          }),
                      icon: Icon(Icons.exposure_neg_1),
                      label: Text("")),
                ),
                Text(
                  _numeroDeDezenasASortear.toInt().toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible:
                  _numeroDeDezenasASortear < widget.concursoBean.maxSize,
                  child: FlatButton.icon(
                      onPressed: () =>
                          setState(() {
                            _sortear(1);
                          }),
                      icon: Icon(Icons.exposure_plus_1),
                      label: Text("")),
                ),
              ],
            ),
          ),
        ),
        Visibility(
            visible: maxSize != minSize,
            child: Divider(
              height: 10,
            )),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: GroupButton(
            isRadio: false,
            controller: _buttonGroupController,
            onSelected: (value, index, isSelected) {
              _buttonGroupController.unselectAll();
              _buttonGroupController.selectIndex(index);
              estrategiaGeracao = EstrategiaGeracao.values[index];
              _sorteioGenerator = estrategiaGeracao.sorteioGenerator;
              _sortearComAnuncio(0);
            },
            buttons:
            EstrategiaGeracao.values.map((e) => e.displayTitle).toList(),
            options: GroupButtonOptions(
              selectedShadow: const [],
              selectedTextStyle: TextStyle(
                color: Colors.white,
              ),
              selectedColor: widget.concursoBean.colorBean.getColor(context),
              unselectedTextStyle: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
              borderRadius: BorderRadius.circular(10),
              groupingType: GroupingType.wrap,
              direction: Axis.horizontal,
              mainGroupAlignment: MainGroupAlignment.start,
              crossGroupAlignment: CrossGroupAlignment.start,
              groupRunAlignment: GroupRunAlignment.start,
              textAlign: TextAlign.center,
              textPadding: EdgeInsets.zero,
              alignment: Alignment.center,
              elevation: 2,
            ),
          ),
        ),
        Visibility(
          visible: estrategiaGeracao != EstrategiaGeracao.ALEATORIO,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_dropdownValueFiltroPeriodo.labelValue),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton<FiltroPeriodo>(
                    value: _dropdownValueFiltroPeriodo,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: widget.concursoBean.colorBean.getColor(context),
                    ),
                    onChanged: (FiltroPeriodo? newValue) {
                      setState(() {
                        _dropdownValueFiltroPeriodo = newValue!;
                        if (_dropdownValueFiltroPeriodo == FiltroPeriodo.CUSTOMIZADO) {
                          _updateDateTimeRange(
                              _dateTimeRange.start,
                              _dateTimeRange.end);
                        } else {
                          _updateDateTimeRange(
                              _dropdownValueFiltroPeriodo.startDate,
                              _dropdownValueFiltroPeriodo.endDate);
                        }
                        _sortearComAnuncio(0);
                      });
                    },
                    items: FiltroPeriodo.values
                        .map<DropdownMenuItem<FiltroPeriodo>>(
                            (FiltroPeriodo value) {
                          return DropdownMenuItem<FiltroPeriodo>(
                            value: value,
                            child: Text(value.displayTitle),
                          );
                        }).toList(),
                  ),
                ],
              ),
              Visibility(
                visible: _dropdownValueFiltroPeriodo == FiltroPeriodo.CUSTOMIZADO,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Data início",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dateTimeRange.start,
                              firstDate: DateTime(1994),
                              lastDate: DateTime.now());
                          _updateDateTimeRange(pickedDate!, _dateTimeRange.end);
                        },
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Data fim"
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dateTimeRange.end,
                              firstDate: DateTime(1994),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now());
                          _updateDateTimeRange(_dateTimeRange.start, pickedDate!);
                        },
                      ),
                      flex: 1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 10,
        ),
        Expanded(
          child: FutureBuilder<SorteioFrequencia>(
            future: _futureSorteio,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                SorteioFrequencia sorteioFrequencia = snapshot.data!;
                List<Dezena> dezenas = sorteioFrequencia.frequencias
                    .map((value) =>
                    Dezena(value.dezena.toString(),
                        widget.concursoBean.colorBean.getColor(context)))
                    .toList();
                List<Dezena> dezenas2 = [];
                if (sorteioFrequencia.frequencias2 != null) {
                  dezenas2 = sorteioFrequencia.frequencias2!
                      .map((value) =>
                      Dezena(value.dezena.toString(),
                          widget.concursoBean.colorBean.getColor(context)))
                      .toList();
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.extent(
                        maxCrossAxisExtent: width / 8 + 20,
                        shrinkWrap: false,
                        padding: EdgeInsets.all(10),
                        children: dezenas,
                      ),
                    ),
                    Visibility(
                        visible: widget.concursoBean.name == "D. SENA",
                        child: Expanded(
                          child: Column(
                            children: [
                              Divider(
                                height: 0,
                              ),
                              Expanded(
                                child: GridView.extent(
                                  maxCrossAxisExtent: width / 8 + 20,
                                  shrinkWrap: false,
                                  padding: EdgeInsets.all(10),
                                  children: dezenas2,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: refreshButton,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Expanded(child: Center(child: Icon(Icons.signal_wifi_off))),
                  ],
                );
              }
              return Column(
                children: <Widget>[
                  DezenasLoading(_numeroDeDezenasASortear.toInt(), widget.concursoBean),
                  Visibility(
                      visible: widget.concursoBean.name == "D. SENA",
                      child: Expanded(
                        child: Column(
                          children: [
                            Divider(
                              height: 0,
                            ),
                            DezenasLoading(_numeroDeDezenasASortear.toInt(), widget.concursoBean),
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: refreshButton,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _updateDateTimeRange(DateTime startDate, DateTime endDate) {
    _dateTimeRange = DateTimeRange(
        start: startDate,
        end: endDate);
    _startDateController.text = formatarData(_dateTimeRange.start);
    _endDateController.text = formatarData(_dateTimeRange.end);
  }

  @override
  bool get wantKeepAlive => true;
}
