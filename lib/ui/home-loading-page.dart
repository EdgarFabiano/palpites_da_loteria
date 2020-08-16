

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';

class HomeLoadingPage extends StatelessWidget {
  final spacing;
  final tileSize;

  const HomeLoadingPage({Key key, this.spacing, this.tileSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
      child: Center(
          child: GridView(
            padding: EdgeInsets.all(spacing),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              maxCrossAxisExtent: tileSize,
            ),
            children: [
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos(),
              EmptyCardConcursos()
            ],
          )),
    );
  }
}

class EmptyCardConcursos extends StatelessWidget {
  const EmptyCardConcursos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness b = DynamicTheme.of(context).brightness;
    var cardColor = b == Brightness.light ? Colors.white : Colors.black12;
    var layoutBuilder = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Card(
            color: cardColor,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Loading(indicator: BallSpinFadeLoaderIndicator(), color: Colors.grey,),
                ],
              ),
            ),
          );
        });

    return layoutBuilder;
  }
}

