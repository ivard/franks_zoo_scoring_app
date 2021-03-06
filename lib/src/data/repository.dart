import 'dart:async';

import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class GameRepository {
  final BehaviorSubject<GameScore> _scoreSubject;

  GameRepository({required Set<Player> players})
      : _scoreSubject = BehaviorSubject.seeded(GameScore(players: players));

  Stream<GameScore> getScores() => _scoreSubject.stream;

  GameRoundBloc startNewRound({Function()? onFinished}) => GameRoundBloc(
        pairs: _scoreSubject.value.getPairsForNextRound(),
        callback: (round) {
          _scoreSubject.add(_scoreSubject.value.addRound(round));
          if (onFinished != null) onFinished();
        },
      );
}
