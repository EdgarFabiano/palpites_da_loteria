import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../defaults/defaults_export.dart';
import '../service/auth_service.dart';

class UserInfoPopup extends StatelessWidget {
  UserInfoPopup({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('dismissibleKey'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Dialog(
          alignment: Alignment.topCenter,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => _closePopup(context),
                        child: Icon(Icons.close)),
                    Expanded(
                      child: Center(
                        child: Text(
                          Strings.appName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.close, color: Colors.transparent),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _authService.getProfileImage(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _authService.getCurrentUser()!.displayName!,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _authService.getCurrentUser()!.email!,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1.5, height: 0),
              ListTile(
                leading: Icon(Icons.logout, size: 20),
                title: Text(
                  Strings.logout,
                ),
                onTap: () => _signOut(context),
              ),
              Divider(thickness: 1.5, height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _launchUrlByParam("privacy_policy_url"),
                    child: Text(
                      Strings.politicaDePrivacidade,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text("     •     "),
                  TextButton(
                    onPressed: () => _launchUrlByParam("use_terms_url"),
                    child: Text(
                      Strings.termosDeUso,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _closePopup(BuildContext context) {
    Navigator.pop(context);
  }

  void _signOut(BuildContext context) {
    _authService.signOut();
    _closePopup(context);
  }

  _launchUrlByParam(String param) async {
    var url = _remoteConfig.getString(param);
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
