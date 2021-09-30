import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/widgets/app_container.dart';

class SelectPlayersScreen extends StatefulWidget {
  final Function(List<String>) onPlayersSelected;

  const SelectPlayersScreen({
    Key? key,
    required this.onPlayersSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectPlayersScreenState();
}

class _SelectPlayersScreenState extends State<SelectPlayersScreen> {
  final List<String> _players = [];

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) => AppContainer(
        title: 'Selecteer spelers',
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Naam van speler',
                    ),
                    controller: _inputController,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      setState(() => _players.add(_inputController.text)),
                ),
              ],
            ),
            ..._players.map((player) => Text(player)).toList(),
          ],
        ),
      );
}
