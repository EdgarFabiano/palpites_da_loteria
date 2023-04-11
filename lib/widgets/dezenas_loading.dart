import 'package:flutter/material.dart';

import '../model/contest.dart';

class DezenasLoading extends StatefulWidget {
  final int amount;
  final Contest _contest;

  const DezenasLoading(this.amount, this._contest, {Key? key})
      : super(key: key);

  @override
  State<DezenasLoading> createState() => _DezenasLoadingState();
}

class _DezenasLoadingState extends State<DezenasLoading> {
  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    var width = MediaQuery.of(context).size.width;
    List<Widget> dezenas = List.filled(
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
        children: dezenas,
      ),
    );
  }
}
