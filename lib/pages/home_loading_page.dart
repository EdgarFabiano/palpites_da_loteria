import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class HomeLoadingPage extends StatelessWidget {
  final spacing;
  final tileSize;

  const HomeLoadingPage({Key? key, this.spacing, this.tileSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
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
        ));
  }
}

class EmptyCardConcursos extends StatelessWidget {
  const EmptyCardConcursos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeMode? themeMode = EasyDynamicTheme.of(context).themeMode;
    var cardColor = themeMode == ThemeMode.light ? Colors.white : Colors.black12;
    var layoutBuilder = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Card(
            color: cardColor,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator(backgroundColor: Colors.grey,)),
                ],
              ),
            ),
          );
        });

    return layoutBuilder;
  }
}

