import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/repository.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/screens/add_players_screen.dart';
import 'package:franks_zoo_scoring_app/src/screens/game_round_screen.dart';

void main() {
  runApp(FranksZooScoringApp());
}

class FranksZooScoringApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  FranksZooScoringApp({Key? key}) : super(key: key);

  void _startGame(Set<Player> players) {
    final repository = GameRepository(players: players);
    _navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => StreamBuilder<GameScore>(
        stream: repository.getScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final score = snapshot.data!;
          return GameRoundScreen(
            bloc: repository.startNewRound(),
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
