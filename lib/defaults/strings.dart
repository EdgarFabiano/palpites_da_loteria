

import 'dart:math';

class Strings {

  ///App name
  static const String appName = "Palpites da Loteria";
  static const String settings = "Configurações";

  ///Assets
  //Fonts
  static const String fontRobotoBold = "MajorMonoDisplay-Regular.ttf";
  static const String fontRobotoRegular = "MajorMonoDisplay-Regular.ttf";

  ///routes
  static const String concursosRoute = "/";
  static const String sorteioRoute = "/Sorteio";
  static const String configuracoesRoute = "/Configuracoes";

  ///Strings
  //Titles
  static const String appBarTitle = "App Bar";
  static const String TabBarTitle = "Tab Bar with Tab Bar View";
  static const String bottomNavigationTitle = "Bottom Navigation with PageView";
  static const String buttonsTitle = "Buttons";
  static const String animatedIconsTitle = "Animated Icons";
  static const String animatedSizeTitle = "Animated Size";

  ///Notification bodies
  static const bodies = [
    'Confira se você acertou os jogos que fez',
    'Venha ver o resultado agora mesmo pelo aplicativo',
    'Veja agora as dezenas sorteadas',
    'Confira o resultado do último sorteio'
  ];

  static String randomNotificationBody() {
    return bodies[Random().nextInt(bodies.length-1)];
  }

}