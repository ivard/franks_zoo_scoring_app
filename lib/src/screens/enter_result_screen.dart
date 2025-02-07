import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class EnterResultScreen extends StatefulWidget {
  final GameScore prevScore;
  final Function(EnterRoundResult) callback;

  const EnterResultScreen({
    Key? key,
    required this.prevScore,
    required this.callback,
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
        title: 'Invoeren uitslag ronde ${widget.prevScore.numberOfRounds + 1}',
        action: TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: () => widget.callback(EnterRoundResult(_result)),
        ),
        body: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: _result.length,
          itemBuilder: (context, index) => ReorderableDragStartListener(
            key: Key(index.toString()),
            index: index,
            child: ListTile(
              leading: Text('${index + 1}.'),
              title: Text(_result[index]),
              trailing: const Icon(Icons.drag_handle),
            ),
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
