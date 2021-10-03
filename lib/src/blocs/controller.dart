import 'dart:async';

import 'package:franks_zoo_scoring_app/src/blocs/model.dart';
import 'package:franks_zoo_scoring_app/src/blocs/events.dart';
import 'package:rxdart/rxdart.dart';

class GameController {
  final BehaviorSubject<GameScore> _scoreSubject;

  GameController({required Set<Player> players})
      : _scoreSubject = BehaviorSubject.seeded(GameScore(players: players));

  Stream<GameScore> getScores() => _scoreSubject.stream;

  Stream<GameEvent> startNewRound() async* {
    final enterResultEvent = EnterResult();
    yield enterResultEvent;
    final result = await enterResultEvent.future;

    final enterHedgehogsEvent = EnterHedgehogs();
    yield enterHedgehogsEvent;
    final hasHedgehogs = await enterHedgehogsEvent.future;

    final enterLionsEvent = EnterLions();
    yield enterLionsEvent;
    final numberOfLions = await enterLionsEvent.future;

    final newRound = _scoreSubject.value.addRound(GameRound(
      result: result,
      hasHedgehogs: hasHedgehogs,
      numberOfLions: numberOfLions,
    ));
    _scoreSubject.add(newRound);
  }
}
