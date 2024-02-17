import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../defaults/defaults_export.dart';
import '../model/loteria_banner_ad.dart';
import '../model/model_export.dart';
import '../service/admob_service.dart';
import '../service/contest_service.dart';
import '../widgets/contest_card.dart';
import '../widgets/contests_settings_change_notifier.dart';
import 'app_drawer.dart';
import 'generate_guess_result_page.dart';
import 'home_loading_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ContestCard>? cards;
  ContestsSettingsChangeNotifier? contestsProvider;
  LotteryBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.contestsBannerId);
  final ContestService _contestService = ContestService();
  List<Contest>? _contests = [];

  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    var lotteryMessage = message.data['lottery'];
    if (lotteryMessage != '') {
      List<Contest> contests = await _contestService.initContests();
      if (contests.isNotEmpty) {
        var lotteryContest = contests
            .firstWhere((element) => element.getEndpoint() == lotteryMessage);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return GenerateGuessResult(
                lotteryContest,
                initialTab: 1,
              );
            },
          ),
        );
      }
    }
  }

  Future<void> _updateContests() async {
    contestsProvider = Provider.of<ContestsSettingsChangeNotifier>(context);
    _contests = contestsProvider?.getContests();
    if(_contests != null && _contests!.isEmpty) {
      _contests = await _contestService.initContests();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var isPortrait = mediaQueryData.orientation == Orientation.portrait;

    var screenWidth = mediaQueryData.size.width;
    var portraitSize = screenWidth / 2;
    var landscapeSize = screenWidth / 4;
    var tileSize = isPortrait
        ? (portraitSize > Constants.tileMaxSize
            ? Constants.tileMaxSize
            : portraitSize)
        : (landscapeSize > Constants.tileMaxSize
            ? Constants.tileMaxSize
            : landscapeSize);

    var spacing = mediaQueryData.size.height / 100;

    _updateContests();

    if (contestsProvider != null && _contests != null) {
      cards = _contests
          ?.where((element) => element.enabled)
          .map((c) => ContestCard(c))
          .toList();

      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: Center(
          child: Column(
            children: [
              if (cards!.isNotEmpty)
                Flexible(
                  child: GridView(
                    padding: EdgeInsets.all(spacing),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      maxCrossAxisExtent: tileSize,
                    ),
                    children: cards!,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                  ),
                ),
              if (cards!.isEmpty)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: DefaultThemes.textColor(context),
                              ),
                              Text(
                                "Recarregar",
                                style: TextStyle(
                                    color: DefaultThemes.textColor(context)),
                              ),
                            ]),
                      ),
                      onPressed: () => setState(() {}),
                    ),
                  ),
                ),
              AdMobService.getBannerAdWidget(_bannerAd),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: HomeLoadingPage(spacing: spacing, tileSize: tileSize),
      );
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
