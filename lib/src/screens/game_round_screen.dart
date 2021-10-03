import 'package:flutter/cupertino.dart';
import 'package:franks_zoo_scoring_app/src/blocs/events.dart';
import 'package:franks_zoo_scoring_app/src/blocs/model.dart';

import 'enter_result_screen.dart';

class GameRoundScreen extends StatelessWidget {
  final Stream<GameEvent> stream;
  final GameScore prevScore;

  const GameRoundScreen({
    Key? key,
    required this.stream,
    required this.prevScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<GameEvent>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          final event = snapshot.data;

          switch (event.runtimeType) {
            case EnterResult:
              return EnterResultScreen(
                prevScore: prevScore,
                completer: event as EnterResult,
              );
            default:
              throw UnsupportedError('Unknown game event');
          }
        },
      );
}
