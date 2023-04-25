class Constants {
  static bool showAds = true;

  static const String appName = "Palpites da loteria";
  static const String concursosSharedPreferencesKey = 'concursos';
  static const String concursosBaselineJson = 'assets/json/baseline.json';

  static const String logoTransparentAssetPath =
      'assets/images/logo-transparent.png';
  static const String lotteryIconAssetPath = 'assets/images/loterica.png';

  static const String refreshWhiteAssetPath = 'assets/images/refresh-white.png';
  static const String refreshDarkAssetPath = 'assets/images/refresh-dark.png';

  static const double tileMaxSize = 260.0;

  static const DBFileName = 'palpites_da_loteria.db';

  //Firebase Analytics events
  static const String ev_UpdateContestHomeScreen = 'update_contest_home';
  static const String pm_Contest = 'contest';
  static const String pm_Enabled = 'enabled';
  static const String pm_SortOrder = 'sort_order';

  static const String ev_SortContestHomeScreen = 'sort_contest_home';
  static const String pm_from = 'from';
  static const String pm_to = 'to';

  static const String ev_addSavedGame = 'add_saved_game';
  static const String ev_updateSavedGame = 'update_saved_game';
  static const String ev_removeSavedGame = 'remove_saved_game';
  static const String pm_game = 'game';
  static const String pm_title = 'title';

  static const String ev_inAppReviewIntent = 'in_app_review_intent';

  static const String ev_gameGenerated = 'game_generated';
  static const String pm_type = 'type';
  static const String pm_size = 'size';
  static const String pm_showFrequencies = 'show_frequencies';

  static const String ev_contestResult = 'contest_result';
  static const String pm_ContestName = 'contest_name';
  static const String pm_ContestNumber = 'contest_number';
  static const String pm_date = 'date';
}
