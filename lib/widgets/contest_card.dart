import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/pages/sorteio_resultado_page.dart';

class ContestCard extends StatefulWidget {
  final Contest _contest;

  const ContestCard(this._contest, {Key? key}) : super(key: key);

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  Widget build(BuildContext context) {
    var lotteryIconAssetPath = Constants.lotteryIconAssetPath;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SorteioResultadoPage(widget._contest),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var maxWidth = constraints.maxWidth;
          var maxHeight = constraints.maxHeight;

          return Card(
            elevation: 2,
            color: widget._contest.getColor(context),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    lotteryIconAssetPath,
                    height: maxWidth / 2,
                    width: maxWidth / 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: maxHeight / 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget._contest.name,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: maxHeight / 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
