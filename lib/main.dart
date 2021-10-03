import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/blocs/controller.dart';
import 'package:franks_zoo_scoring_app/src/blocs/model.dart';
import 'package:franks_zoo_scoring_app/src/screens/add_players_screen.dart';
import 'package:franks_zoo_scoring_app/src/screens/game_round_screen.dart';

void main() {
  runApp(FranksZooScoringApp());
}

class FranksZooScoringApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  FranksZooScoringApp({Key? key}) : super(key: key);

  void _startGame(Set<Player> players) {
    final controller = GameController(players: players);
    _navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => StreamBuilder<GameScore>(
        stream: controller.getScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final score = snapshot.data!;
          return GameRoundScreen(
            stream: controller.startNewRound(),
            prevScore: score,
          );
        },
      ),
    ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Frank's zoo scoring app",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: _navigatorKey,
      home: AddPlayersScreen(
        onPlayersSelected: (players) => _startGame(players),
      ),
    );
  }
}
