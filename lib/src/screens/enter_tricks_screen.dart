import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class EnterTricksScreen extends StatelessWidget {
  static const _smallSpace = _defaultSpace / 2;
  static const _defaultSpace = 10.0;
  static const _largeSpace = _defaultSpace * 2;

  final Stream<GameRound> stream;
  final Function(GameEvent) callback;

  const EnterTricksScreen({
    Key? key,
    required this.stream,
    required this.callback,
  }) : super(key: key);

  Widget _buildLionsSlider(int number, Function(int) updateValue) => Row(
        children: [
          Slider(
            value: number.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (double value) => updateValue(value.toInt()),
          ),
          Text(number.toString()),
        ],
      );

  Widget _buildBody(BuildContext context, GameRound state) => ListView(
        children: [
          for (int i = 0; i < state.result.length; i++)
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: _smallSpace,
                horizontal: _defaultSpace,
              ),
              child: Padding(
                padding: const EdgeInsets.all(_defaultSpace),
                child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(flex: 0.2),
                  },
                  children: [
                    TableRow(children: [
                      Text(
                        '${i + 1}.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        state.result[i],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ]),
                    TableRow(children: [
                      Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: _largeSpace),
                          Row(children: [
                            Checkbox(
                              value:
                                  state.hasHedgehogs.contains(state.result[i]),
                              onChanged: (bool? value) => callback(HasHedgehogs(
                                  player: state.result[i], value: value!)),
                            ),
                            const Text('Heeft egels'),
                          ]),
                          const SizedBox(height: _largeSpace),
                          const Text('Aantal leeuwen:'),
                          _buildLionsSlider(
                            state.numberOfLions[state.result[i]]!,
                            (value) => callback(NumberOfLions(
                              player: state.result[i],
                              number: value,
                            )),
                          ),
                          if (i == state.result.length - 1) ...[
                            const SizedBox(height: _defaultSpace),
                            const Text('Aantal leeuwen in de hand:'),
                            _buildLionsSlider(
                              state.lionsInHandLastPlayer,
                              (value) => callback(LionsInHandLastPlayer(
                                number: value,
                              )),
                            ),
                          ],
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Slagen invoeren',
        action: TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: () {
            try {
              callback(FinalizeRound());
            } on InvalidScoreException catch (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ongeldige score.'),
                ),
              );
            }
          },
        ),
        body: StreamBuilder<GameRound>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return _buildBody(context, snapshot.data!);
          },
        ),
      );
}
