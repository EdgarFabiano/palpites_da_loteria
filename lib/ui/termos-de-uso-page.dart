import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/widgets/termos-de-uso-form.dart';

class TermosDeUsoPage extends StatefulWidget {
  @override
  _TermosDeUsoPageState createState() => _TermosDeUsoPageState();
}

class _TermosDeUsoPageState extends State<TermosDeUsoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AdMobService.bannerPadding),
        child: TermosDeUsoForm(false),
      ),
    );
  }
}
