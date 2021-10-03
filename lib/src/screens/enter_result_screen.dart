import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/blocs/events.dart';
import 'package:franks_zoo_scoring_app/src/blocs/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class EnterResultScreen extends StatefulWidget {
  final GameScore prevScore;
  final EnterResult completer;

  const EnterResultScreen({
    Key? key,
    required this.prevScore,
    required this.completer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnterResultScreenState();
}

class _EnterResultScreenState extends State<EnterResultScreen> {
  late List<Player> _result;

  @override
  void initState() {
    super.initState();
    _result = widget.prevScore.getRanking();
  }

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Uitslag ronde ${widget.prevScore.numberOfRounds + 1}',
        action: TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: () => widget.completer.complete(_result),
        ),
        body: ReorderableListView.builder(
          itemCount: _result.length,
          itemBuilder: (context, index) => ListTile(
            key: Key(index.toString()),
            leading: Text('${index + 1}.'),
            title: Text(_result[index]),
          ),
          onReorder: (int oldIndex, int newIndex) => setState(() {
            if (oldIndex < newIndex) {
              // removing the item at oldIndex will shorten the list by 1.
              newIndex -= 1;
            }
            final Player player = _result.removeAt(oldIndex);
            _result.insert(newIndex, player);
          }),
        ),
      );
}
