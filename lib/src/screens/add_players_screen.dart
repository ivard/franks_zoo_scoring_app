import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class AddPlayersScreen extends StatefulWidget {
  final Function(Set<String>) onPlayersSelected;

  const AddPlayersScreen({
    Key? key,
    required this.onPlayersSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  final List<String> _players = [];

  final _inputController = TextEditingController();

  void _addPlayer() {
    final newPlayer = _inputController.text;
    String? snackBarText;
    if (newPlayer.isEmpty) {
      snackBarText = 'Speler moet een naam hebben.';
    } else if (_players.contains(newPlayer)) {
      snackBarText = 'Deze speler bestaat al.';
    }

    if (snackBarText != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarText),
        ),
      );
    } else {
      setState(() => _players.add(newPlayer));
      _inputController.clear();
    }
  }

  void _onContinue() {
    if (_players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Te weinig spelers gevonden. Het minimale aantal spelers is 3.',
          ),
        ),
      );
    } else {
      widget.onPlayersSelected(_players.toSet());
    }
  }

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Spelers toevoegen',
        action: TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.onPrimary),
          child: const Text('Doorgaan'),
          onPressed: _onContinue,
        ),
        body: ListView(
          children: _players
              .asMap()
              .entries
              .map(
                (entry) => Dismissible(
                    key: Key(entry.key.toString()),
                    background: Container(
                      color: Theme.of(context).errorColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.filled(
                          2,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (_) =>
                        setState(() => _players.remove(entry.value)),
                    child: ListTile(title: Text(entry.value))),
              )
              .toList(),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Naam van speler',
                  ),
                  controller: _inputController,
                  onSubmitted: (_) => _addPlayer(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                splashRadius: 30,
                onPressed: _addPlayer,
              ),
            ],
          ),
        ),
      );
}
