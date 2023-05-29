import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/enum/period_filter.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/format_service.dart';
import 'package:palpites_da_loteria/service/saved_game_service.dart';
import 'package:palpites_da_loteria/widgets/guess_number_widget.dart';

import '../model/enum/generation_strategy.dart';
import '../model/frequency_draw.dart';
import '../service/generator_strategies/abstract_guess_generator.dart';
import 'guess_number_loading.dart';

typedef AlreadySavedResolver = Function(int? alreadySavedGameId);
typedef GeneratedGameResolver = Function(String generatedGame);

class TabGenerateGuess extends StatefulWidget {
  final Contest _contest;
  final AlreadySavedResolver notifyParent;
  final GeneratedGameResolver generatedGameResolver;

  const TabGenerateGuess(this._contest,
      {Key? key,
      required this.notifyParent,
      required this.generatedGameResolver})
      : super(key: key);

  @override
  _TabGenerateGuessState createState() => _TabGenerateGuessState();
}

class _TabGenerateGuessState extends State<TabGenerateGuess>
    with AutomaticKeepAliveClientMixin {
  GenerationStrategy generationStrategy = GenerationStrategy.RANDOM;
  AbstractGuessGenerator _guessGenerator =
      GenerationStrategy.RANDOM.guessGenerator;
  double _guessNumberQuantityToRaffle = 0;
  int _chance = 3;
  Future<FrequencyDraw>? _futureDraw;
  GroupButtonController _buttonGroupController = GroupButtonController();
  PeriodFilter _dropdownValuePeriodFilter = PeriodFilter.THREE_MONTHS;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  bool _showFrequency = false;
  SavedGameService _savedGameService = SavedGameService();

  void _generateGuess(double increment) async {
    _guessNumberQuantityToRaffle += increment;
    _futureDraw = _guessGenerator.generateGuess(
        widget._contest, _guessNumberQuantityToRaffle.toInt(), _dateTimeRange);
    _futureDraw!.then((value) => widget.generatedGameResolver(
        value.frequencies.map((e) => e.number).join('|')));
    _futureDraw!.then((value) => _savedGameService
        .existsSavedGame(
            widget._contest, value.frequencies.map((e) => e.number).toList())
        .then((value) => widget.notifyParent(value)));
    _futureDraw!.then((value) async {
      await FirebaseAnalytics.instance.logEvent(
        name: Constants.ev_gameGenerated,
        parameters: {
          Constants.pm_Contest: widget._contest.name,
          Constants.pm_type: generationStrategy.name,
          Constants.pm_from: formatBrDate(_dateTimeRange.start),
          Constants.pm_to: formatBrDate(_dateTimeRange.end),
          Constants.pm_showFrequencies: _showFrequency.toString(),
          Constants.pm_game:
              truncate(value.frequencies.map((e) => e.number).join('|'), 100),
          Constants.pm_size: value.frequencies.length,
        },
      );
    });
  }

  void _generateGuessWithAds(double increment) {
    setState(() {
      _generateGuess(increment);
      _chance++;
      if (_chance >= 5) {
        AdMobService.showGenerateGuessInterstitialAd();
        _chance = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    AdMobService.createGenerateGuessInterstitialAd();
    _buttonGroupController.selectIndex(0);
    _guessNumberQuantityToRaffle = widget._contest.minSize.toDouble();
    _generateGuess(0);
    _updateDateTimeRange(_dropdownValuePeriodFilter.startDate,
        _dropdownValuePeriodFilter.endDate);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        _buildIncrementors(),
        Visibility(
          visible: widget._contest.maxSize != widget._contest.minSize,
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
            generationStrategy = GenerationStrategy.values[index];
            _guessGenerator = generationStrategy.guessGenerator;
            _showFrequency = generationStrategy != GenerationStrategy.RANDOM;
            _generateGuessWithAds(0);
          },
          buttons:
              GenerationStrategy.values.map((e) => e.displayTitle).toList(),
          options: GroupButtonOptions(
            selectedShadow: const [],
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedColor: widget._contest.getColor(context),
            unselectedTextStyle: Theme.of(context).textTheme.bodyMedium,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  _buildPeriodSelector() {
    return Visibility(
      visible: generationStrategy != GenerationStrategy.RANDOM,
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
                      Text(_dropdownValuePeriodFilter.labelValue),
                      DropdownButton<PeriodFilter>(
                        value: _dropdownValuePeriodFilter,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: widget._contest.getColor(context),
                        ),
                        onChanged: (PeriodFilter? newValue) {
                          setState(() {
                            _dropdownValuePeriodFilter = newValue!;
                            if (_dropdownValuePeriodFilter ==
                                PeriodFilter.CUSTOM) {
                              _updateDateTimeRange(
                                  _dateTimeRange.start, _dateTimeRange.end);
                            } else {
                              _updateDateTimeRange(
                                  _dropdownValuePeriodFilter.startDate,
                                  _dropdownValuePeriodFilter.endDate);
                            }
                            _generateGuessWithAds(0);
                          });
                        },
                        items: PeriodFilter.values
                            .map<DropdownMenuItem<PeriodFilter>>(
                                (PeriodFilter value) {
                          return DropdownMenuItem<PeriodFilter>(
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
                        value: _showFrequency,
                        onChanged: (value) => _onChangeShowFrequency(value),
                        activeColor: widget._contest.getColor(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _dropdownValuePeriodFilter == PeriodFilter.CUSTOM,
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
                      _generateGuessWithAds(0);
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
                      _generateGuessWithAds(0);
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
      visible: widget._contest.maxSize != widget._contest.minSize,
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _guessNumberQuantityToRaffle > widget._contest.minSize,
              child: IconButton(
                onPressed: () => setState(() {
                  _generateGuess(-1);
                }),
                icon: Icon(Icons.exposure_neg_1),
                style: DefaultThemes.flatButtonStyle(context),
              ),
            ),
            Text(
              _guessNumberQuantityToRaffle.toInt().toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _guessNumberQuantityToRaffle < widget._contest.maxSize,
              child: IconButton(
                onPressed: () => setState(() {
                  _generateGuess(1);
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
      child: FutureBuilder<FrequencyDraw>(
        future: _futureDraw,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            FrequencyDraw frequencyDraw = snapshot.data!;
            List<GuessNumberWidget> guessNumbers = frequencyDraw.frequencies
                .map((value) => GuessNumberWidget(
                      value.number.toString(),
                      widget._contest.getColor(context),
                      _showFrequency,
                      value.quantity,
                    ))
                .toList();
            List<GuessNumberWidget> guessNumbers2 = [];
            if (frequencyDraw.frequencies_2 != null) {
              guessNumbers2 = frequencyDraw.frequencies_2!
                  .map((value) => GuessNumberWidget(
                        value.number.toString(),
                        widget._contest.getColor(context),
                        _showFrequency,
                        value.quantity,
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
                    children: guessNumbers,
                  ),
                  flex: 1,
                ),
                Visibility(
                    visible: widget._contest.name == "D. SENA",
                    child: Divider(
                      height: 0,
                    )),
                Visibility(
                    visible: widget._contest.name == "D. SENA",
                    child: Flexible(
                      child: GridView.extent(
                        maxCrossAxisExtent: (width * textScale) / 5,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        children: guessNumbers2,
                      ),
                    )),
                Visibility(
                  visible: frequencyDraw.contestQuantity > 0,
                  child: Column(
                    children: [
                      RichText(
                          overflow: TextOverflow.fade,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: 'Com base em ', style: textStyle),
                            TextSpan(
                                text:
                                    '${formatNumber(frequencyDraw.contestQuantity)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            TextSpan(text: ' sorteios', style: textStyle),
                          ])),
                      RichText(
                          overflow: TextOverflow.fade,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: 'De ', style: textStyle),
                            TextSpan(
                                text: '${formatBrDate(_dateTimeRange.start)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            TextSpan(text: ' a ', style: textStyle),
                            TextSpan(
                                text: '${formatBrDate(_dateTimeRange.end)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
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
              GuessNumberLoading(
                  _guessNumberQuantityToRaffle.toInt(), widget._contest),
              Visibility(
                  visible: widget._contest.name == "D. SENA",
                  child: Divider(
                    height: 0,
                  )),
              Visibility(
                  visible: widget._contest.name == "D. SENA",
                  child: GuessNumberLoading(
                      _guessNumberQuantityToRaffle.toInt(), widget._contest)),
            ],
          );
        },
      ),
    );
  }

  _buildRefreshButton() {
    final ButtonStyle style = TextButton.styleFrom(
      backgroundColor: widget._contest.getColor(context),
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
    return Visibility(
      visible: generationStrategy == GenerationStrategy.RANDOM,
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
        onPressed: () => _generateGuessWithAds(0),
        style: style,
      ),
    );
  }

  _onChangeShowFrequency(bool value) {
    setState(() {
      _showFrequency = value;
    });
  }

  void _updateDateTimeRange(DateTime startDate, DateTime endDate) {
    _dateTimeRange = DateTimeRange(start: startDate, end: endDate);
    _startDateController.text = formatBrDate(_dateTimeRange.start);
    _endDateController.text = formatBrDate(_dateTimeRange.end);
  }

  @override
  bool get wantKeepAlive => true;
}
