import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class EnterTricksScreen extends StatelessWidget {
  static const _smallSpace = _defaultSpace / 2;
  static const _defaultSpace = 10.0;
  static const _largeSpace = _defaultSpace * 2;

  final List<Player> result;
  final Function(EnterRoundTricks) callback;

  const EnterTricksScreen({
    Key? key,
    required this.result,
    required this.callback,
  }) : super(key: key);

  Widget _buildLionsSlider() => Row(
        children: [
          Slider(
            value: 0,
            min: 0,
            max: 5,
            divisions: 1,
            onChanged: (double value) {},
          ),
          const Text('0'), // TODO: Make
        ],
      );

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Slagen invoeren',
        action: TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: () {},
        ),
        body: ListView(
          children: [
            for (int i = 0; i < result.length; i++)
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
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          result[i],
                          style: Theme.of(context).textTheme.headline6,
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
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                              const Text('Heeft egels'),
                            ]),
                            const SizedBox(height: _largeSpace),
                            const Text('Aantal leeuwen:'),
                            _buildLionsSlider(),
                            if (i == result.length - 1) ...[
                              const SizedBox(height: _defaultSpace),
                              const Text('Aantal leeuwen in de hand:'),
                              _buildLionsSlider(),
                            ],
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
}
