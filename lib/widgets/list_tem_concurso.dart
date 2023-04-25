import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:provider/provider.dart';

import 'contests_settings_change_notifier.dart';

class ListItemContest extends StatefulWidget {
  final Contest _contest;

  ListItemContest(this._contest, {Key? key}) : super(key: key);

  Contest get contest => _contest;

  @override
  _ListItemContestState createState() => _ListItemContestState();
}

class _ListItemContestState extends State<ListItemContest> {
  late ContestsSettingsChangeNotifier _contestsProvider;

  void changeEnabled() {
    setState(() {
      widget._contest.enabled = !widget._contest.enabled;
    });
    _contestsProvider.updateContest(widget._contest);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contestsProvider = Provider.of<ContestsSettingsChangeNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(widget._contest.name),
      leading: Icon(Icons.reorder),
      title: GestureDetector(
        onTap: changeEnabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  Constants.lotteryIconAssetPath,
                  width: 25,
                  color: widget._contest.getColor(context),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text("    "),
                Text(widget._contest.name)
              ],
            ),
            Switch(
              value: widget._contest.enabled,
              onChanged: (value) => changeEnabled(),
            )
          ],
        ),
      ),
    );
  }
}
