import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';
import 'package:franks_zoo_scoring_app/src/widgets/padded_table_row.dart';

class ScoreOverviewScreen extends StatelessWidget {
  static final _teamColors = [
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.blue.shade200,
  ];

  final GameScore score;
  final Function() onContinue;

  const ScoreOverviewScreen({
    Key? key,
    required this.score,
    required this.onContinue,
  }) : super(key: key);

  Map<Player, Color> _determineTeamColors() {
    final pairs = score.getPairsForNextRound();
    final Map<String, Color> map = {};
    for (final player in score.players) {
      if (pairs == null || !pairs.hasTeamMate(player)) {
        map[player] = Colors.transparent;
      } else {
        final teamMate = pairs.getTeamMate(player);
        map[player] = map.containsKey(teamMate)
            ? map[teamMate]!
            : _teamColors.firstWhere((color) => !map.values.contains(color));
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final teamColors = _determineTeamColors();
    return AppContainer(
      title: 'Tussenstand',
      action: TextButton(
        style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.onPrimary),
        child: const Text('Doorgaan'),
        onPressed: onContinue,
      ),
      body: ListView(
        children: [
          if (score.getPairsForNextRound() != null)
            Card(
              margin: const EdgeInsets.only(top: 10),
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryTextTheme.bodyText1?.color,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'De teamleden voor de volgende ronde zijn met kleur gemarkeerd.',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                  ),
                ]),
              ),
            ),
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(flex: 0.2),
              2: IntrinsicColumnWidth(flex: 0.2),
            },
            children: [
              PaddedTableRow(
                padding: const EdgeInsets.all(20),
                children: const [
                  Text('#'),
                  Text('Speler'),
                  Text('Score'),
                ],
              ),
              ...score
                  .getRanking()
                  .asMap()
                  .entries
                  .map((entry) => PaddedTableRow(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: teamColors[entry.value],
                          ),
                          children: [
                            Text((entry.key + 1).toString()),
                            Text(entry.value),
                            Text(score.getScore(entry.value).toString()),
                          ])),
            ],
          ),
        ],
      ),
    );
  }
}
