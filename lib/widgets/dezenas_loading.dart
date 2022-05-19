import 'package:flutter/material.dart';

import '../model/concursos.dart';

class DezenasLoading extends StatefulWidget {
  final int amount;
  final ConcursoBean concursoBean;

  const DezenasLoading(this.amount, this.concursoBean, {Key? key}) : super(key: key);

  @override
  State<DezenasLoading> createState() => _DezenasLoadingState();
}

class _DezenasLoadingState extends State<DezenasLoading> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<Widget> dezenas = List.filled(widget.amount, Card(
      elevation: 2,
      color: widget.concursoBean.colorBean.getColor(context),
      shape: CircleBorder(),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    ));
    return Expanded(
      child: GridView.extent(
        maxCrossAxisExtent: width / 8 + 20,
        shrinkWrap: false,
        padding: EdgeInsets.all(10),
        children: dezenas,
      ),
    );
  }
}
