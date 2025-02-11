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
  Widget build(BuildContext context) => StreamBuilder<GameRoundStatus>(
        stream: bloc.status,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case GameRoundStatus.enterResult:
              return EnterResultScreen(
                prevScore: prevScore,
                callback: bloc.add,
              );
            case GameRoundStatus.enterTricks:
              return EnterTricksScreen(
                stream: bloc.stream,
                callback: bloc.add,
              );
            default:
              return const Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      );
}
