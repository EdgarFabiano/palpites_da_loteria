import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/model/loteria_banner_ad.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/auth_service.dart';
import 'package:palpites_da_loteria/widgets/my_saved_games.dart';
import 'package:palpites_da_loteria/widgets/user_info_popup.dart';

class MySavedGamesPage extends StatefulWidget {
  MySavedGamesPage({Key? key}) : super(key: key);

  @override
  State<MySavedGamesPage> createState() => _MySavedGamesPageState();
}

class _MySavedGamesPageState extends State<MySavedGamesPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.meusJogosBannerId);

  @override
  void initState() {
    super.initState();
    _authService
        .getFirebaseAuthInstance()
        .authStateChanges()
        .listen((User? user) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (user == null) {
            print('User is currently signed out!');
          } else {
            print('User is signed in!');
          }
        });
      }
    });

    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.mySavedGames),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: _authService.getProfileImage(),
              onTap: _showDialog,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_authService.getCurrentUser() == null)
                    if (!_isLoading)
                      buildLoginForm()
                    else
                      Center(child: CircularProgressIndicator())
                  else
                    Center(
                      child: MySavedGames(),
                    )
                ],
              ),
            ),
            AdMobService.getBannerAdWidget(_bannerAd),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return UserInfoPopup();
        });
  }

  Widget buildLoginForm() {
    var theme = Theme.of(context);
    Buttons loginButtonStyle = theme.brightness == Brightness.light
        ? Buttons.GoogleDark
        : Buttons.Google;
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Faça o login para ", style: theme.textTheme.headline5),
                Text("acessar seus jogos salvos",
                    style: theme.textTheme.headline5),
              ],
            ),
          ),
          SignInButton(
            loginButtonStyle,
            padding: EdgeInsets.all(5),
            text: Strings.googleLogin,
            onPressed: () {
              if (mounted)
                setState(() {
                  _isLoading = true;
                });
              return _authService
                  .signInWithGoogle()
                  .then((value) => _isLoading = false);
            },
          ),
        ],
      ),
    );
  }
}
