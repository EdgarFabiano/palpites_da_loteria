import 'package:flutter/material.dart';

import '../model/contest.dart';

class GuessNumberLoading extends StatefulWidget {
  final int amount;
  final Contest _contest;

  const GuessNumberLoading(this.amount, this._contest, {Key? key})
      : super(key: key);

  @override
  State<GuessNumberLoading> createState() => _GuessNumberLoadingState();
}

class _GuessNumberLoadingState extends State<GuessNumberLoading> {
  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    var width = MediaQuery.of(context).size.width;
    List<Widget> guessNumbers = List.filled(
        widget.amount,
        Card(
          elevation: 2,
          color: widget._contest.getColor(context),
          shape: CircleBorder(),
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ));
    return Flexible(
      child: GridView.extent(
        maxCrossAxisExtent: (width * textScale) / 5,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        children: guessNumbers,
      ),
    );
  }
}
