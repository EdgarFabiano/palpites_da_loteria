import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/enum/filtro_periodo.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/format_service.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

import '../model/enum/estrategia_geracao.dart';
import '../model/sorteio_frequencia.dart';
import '../service/generator_strategies/abstract_sorteio_generator.dart';
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
  bool _showFrequencia = true;

  void _sortear(double increment) {
    _numeroDeDezenasASortear += increment;
    _futureSorteio = _sorteioGenerator.sortear(
        widget.concursoBean, _numeroDeDezenasASortear.toInt(), _dateTimeRange);
  }

  void sortearComAnuncio(double increment) {
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
    _numeroDeDezenasASortear = widget.concursoBean.minSize.toDouble();
    _sortear(0);
    _updateDateTimeRange(_dropdownValueFiltroPeriodo.startDate,
        _dropdownValueFiltroPeriodo.endDate);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        _buildIncrementors(),
        Visibility(
          visible: widget.concursoBean.maxSize != widget.concursoBean.minSize,
          child: Divider(
            height: 10,
          ),
        ),
        _buildStrategySelector(),
        _buildPeriodSelector(),
        Divider(
          height: 10,
        ),
        _buildBalls(),
      ],
    );
  }

  _buildStrategySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GroupButton(
          isRadio: false,
          controller: _buttonGroupController,
          onSelected: (value, index, isSelected) {
            _buttonGroupController.unselectAll();
            _buttonGroupController.selectIndex(index);
            estrategiaGeracao = EstrategiaGeracao.values[index];
            _sorteioGenerator = estrategiaGeracao.sorteioGenerator;
            sortearComAnuncio(0);
          },
          buttons: EstrategiaGeracao.values.map((e) => e.displayTitle).toList(),
          options: GroupButtonOptions(
            selectedShadow: const [],
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedColor: widget.concursoBean.colorBean.getColor(context),
            unselectedTextStyle: Theme.of(context).textTheme.bodyLarge,
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
    );
  }

  _buildPeriodSelector() {
    return Visibility(
      visible: estrategiaGeracao != EstrategiaGeracao.ALEATORIO,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dropdownValueFiltroPeriodo.labelValue),
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
                            if (_dropdownValueFiltroPeriodo ==
                                FiltroPeriodo.CUSTOMIZADO) {
                              _updateDateTimeRange(
                                  _dateTimeRange.start, _dateTimeRange.end);
                            } else {
                              _updateDateTimeRange(
                                  _dropdownValueFiltroPeriodo.startDate,
                                  _dropdownValueFiltroPeriodo.endDate);
                            }
                            sortearComAnuncio(0);
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Mostrar frequências"),
                      Switch(
                          value: _showFrequencia,
                          onChanged: (value) => _onChangeShowFrequencia(value)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _dropdownValueFiltroPeriodo == FiltroPeriodo.CUSTOMIZADO,
            child: Row(
              children: [
                Expanded(
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
                          firstDate: DateTime(1990),
                          lastDate: _dateTimeRange.end);
                      _updateDateTimeRange(pickedDate!, _dateTimeRange.end);
                      sortearComAnuncio(0);
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Data fim"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dateTimeRange.end,
                          firstDate: _dateTimeRange.start,
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime.now());
                      _updateDateTimeRange(_dateTimeRange.start, pickedDate!);
                      sortearComAnuncio(0);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildIncrementors() {
    return Visibility(
      visible: widget.concursoBean.maxSize != widget.concursoBean.minSize,
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _numeroDeDezenasASortear > widget.concursoBean.minSize,
              child: IconButton(
                onPressed: () => setState(() {
                  _sortear(-1);
                }),
                icon: Icon(Icons.exposure_neg_1),
                style: DefaultThemes.flatButtonStyle(context),
              ),
            ),
            Text(
              _numeroDeDezenasASortear.toInt().toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _numeroDeDezenasASortear < widget.concursoBean.maxSize,
              child: IconButton(
                onPressed: () => setState(() {
                  _sortear(1);
                }),
                icon: Icon(Icons.exposure_plus_1),
                style: DefaultThemes.flatButtonStyle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBalls() {
    var width = MediaQuery.of(context).size.width;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Expanded(
      child: FutureBuilder<SorteioFrequencia>(
        future: _futureSorteio,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            SorteioFrequencia sorteioFrequencia = snapshot.data!;
            List<Dezena> dezenas = sorteioFrequencia.frequencias
                .map((value) => Dezena(
                      value.dezena.toString(),
                      widget.concursoBean.colorBean.getColor(context),
                      _showFrequencia,
                      value.quantidade,
                    ))
                .toList();
            List<Dezena> dezenas2 = [];
            if (sorteioFrequencia.frequencias2 != null) {
              dezenas2 = sorteioFrequencia.frequencias2!
                  .map((value) => Dezena(
                        value.dezena.toString(),
                        widget.concursoBean.colorBean.getColor(context),
                        _showFrequencia,
                        value.quantidade,
                      ))
                  .toList();
            }
            var textColor = DefaultThemes.textColor(context);
            var textStyle = TextStyle(color: textColor);
            return Column(
              children: <Widget>[
                Flexible(
                  child: GridView.extent(
                    maxCrossAxisExtent: (width * textScale) / 5,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    children: dezenas,
                  ),
                  flex: 1,
                ),
                Visibility(
                    visible: widget.concursoBean.name == "D. SENA",
                    child: Divider(
                      height: 0,
                    )),
                Visibility(
                    visible: widget.concursoBean.name == "D. SENA",
                    child: Flexible(
                      child: GridView.extent(
                        maxCrossAxisExtent: (width * textScale) / 5,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        children: dezenas2,
                      ),
                    )),
                Visibility(
                  visible: sorteioFrequencia.qtdConcursos > 0,
                  child: Column(
                    children: [
                      RichText(
                        overflow: TextOverflow.fade,
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(text: 'Com base em ', style: textStyle),
                        TextSpan(
                            text:
                                '${formatNumber(sorteioFrequencia.qtdConcursos)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor)),
                        TextSpan(text: ' sorteios', style: textStyle),
                      ])),
                      RichText(
                          overflow: TextOverflow.fade,
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(text: 'De ', style: textStyle),
                        TextSpan(
                            text: '${formatarData(_dateTimeRange.start)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor)),
                        TextSpan(text: ' a ', style: textStyle),
                        TextSpan(
                            text: '${formatarData(_dateTimeRange.end)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor)),
                      ]))
                    ],
                  ),
                ),
                _buildRefreshButton(),
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
              DezenasLoading(
                  _numeroDeDezenasASortear.toInt(), widget.concursoBean),
              Visibility(
                  visible: widget.concursoBean.name == "D. SENA",
                  child: Divider(
                    height: 0,
                  )),
              Visibility(
                  visible: widget.concursoBean.name == "D. SENA",
                  child: DezenasLoading(
                      _numeroDeDezenasASortear.toInt(), widget.concursoBean)),
            ],
          );
        },
      ),
    );
  }

  _buildRefreshButton() {
    final ButtonStyle style = TextButton.styleFrom(
      backgroundColor: widget.concursoBean.colorBean.getColor(context),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
    return Visibility(
      visible: estrategiaGeracao == EstrategiaGeracao.ALEATORIO,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                Text(
                  "Gerar novamente",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ]),
        ),
        onPressed: () => sortearComAnuncio(0),
        style: style,
      ),
    );
  }

  _onChangeShowFrequencia(bool value) {
    setState(() {
      _showFrequencia = value;
    });
  }

  void _updateDateTimeRange(DateTime startDate, DateTime endDate) {
    _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
    _startDateController.text = formatarData(_dateTimeRange.start);
    _endDateController.text = formatarData(_dateTimeRange.end);
  }

  @override
  bool get wantKeepAlive => true;
}
