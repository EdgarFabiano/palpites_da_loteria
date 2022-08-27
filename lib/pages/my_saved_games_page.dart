import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:palpites_da_loteria/service/auth_service.dart';

import '../defaults/strings.dart';

class MySavedGamesPage extends StatefulWidget {
  MySavedGamesPage({Key? key}) : super(key: key);

  @override
  State<MySavedGamesPage> createState() => _MySavedGamesPageState();
}

class _MySavedGamesPageState extends State<MySavedGamesPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService
        .getFirebaseAuthInstance()
        .authStateChanges()
        .listen((User? user) {
      setState(() {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.mySavedGames),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [];
            },
            icon: _authService.getProfileImage(),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_authService.getCurrentUser() == null)
            Center(
              child: SignInButton(
                Buttons.Google,
                text: "Login com Google",
                onPressed: _authService.signInWithGoogle,
              ),
            )
          else
            Center(
              child: SignInButton(
                Buttons.GoogleDark,
                text: "Logout",
                onPressed: _authService.signOut,
              ),
            )
        ],
      ),
    );
  }
}
