import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/termos_de_uso_form.dart';

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
        padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
        child: TermosDeUsoForm(),
      ),
    );
  }
}

