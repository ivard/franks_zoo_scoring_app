import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/bloc.dart';

import 'enter_result_screen.dart';
import 'enter_tricks_screen.dart';

class GameRoundScreen extends StatelessWidget {
  final GameRoundBloc bloc;
  final GameScore prevScore;

  const GameRoundScreen({
    Key? key,
    required this.bloc,
    required this.prevScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<GameRound>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return EnterResultScreen(
              prevScore: prevScore,
              callback: bloc.add,
            );
          }

          // TODO: This logic should not be handled directly in a screen.
          if (snapshot.data!.pairs == null &&
              snapshot.data!.result.length > 3) {
            return const CircularProgressIndicator();
          }

          return EnterTricksScreen(
            stream: bloc.stream,
            callback: bloc.add,
          );
        },
      );
}
