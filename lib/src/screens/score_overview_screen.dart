import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class ScoreOverviewScreen extends StatelessWidget {
  final GameScore score;
  final Function() onContinue;

  const ScoreOverviewScreen({
    Key? key,
    required this.score,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Tussenstand',
        action: TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: onContinue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(flex: 0.2),
              2: IntrinsicColumnWidth(flex: 0.2),
            },
            children: [
              const TableRow(children: [
                Text('#'),
                Text('Speler'),
                Text('Score'),
              ]),
              ...score.getRanking().asMap().entries.expand(
                    (entry) => [
                      const TableRow(children: [
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                      ]),
                      TableRow(children: [
                        Text((entry.key + 1).toString()),
                        Text(entry.value),
                        Text(score.getScore(entry.value).toString()),
                      ])
                    ],
                  ),
            ],
          ),
        ),
      );
}
