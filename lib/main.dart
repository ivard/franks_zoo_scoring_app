import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/screens/add_players_screen.dart';

void main() {
  runApp(const FranksZooScoringApp());
}

class FranksZooScoringApp extends StatelessWidget {
  const FranksZooScoringApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Frank's zoo scoring app",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddPlayersScreen(
        onPlayersSelected: (players) => debugPrint(players.toString()),
      ),
    );
  }
}
