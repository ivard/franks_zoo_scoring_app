import 'package:flutter/cupertino.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/bloc.dart';

import 'enter_result_screen.dart';

class GameRoundScreen extends StatelessWidget {
  final GameRoundBloc bloc;
  final GameScore prevScore;

  const GameRoundScreen({
    Key? key,
    required this.bloc,
    required this.prevScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Player>>(
        future: bloc.result,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return EnterResultScreen(
              prevScore: prevScore,
              callback: bloc.add,
            );
          }

          final result = snapshot.data;

          throw UnsupportedError('Screen not implemented');
        },
      );
}
