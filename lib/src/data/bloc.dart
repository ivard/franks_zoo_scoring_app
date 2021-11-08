import 'dart:async';

import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:rxdart/rxdart.dart';

enum GameRoundStatus {
  enterResult,
  enterTricks,
  done,
}

class GameRoundBloc {
  final Pairs? pairs;
  final Function(GameRound) callback;

  final _subject = BehaviorSubject<GameRound>();
  final _statusSubject = BehaviorSubject.seeded(GameRoundStatus.enterResult);

  late GameRound _gameRound;

  GameRoundBloc({required this.callback, this.pairs});

  Stream<GameRound> get stream => _subject.stream;
  Stream<GameRoundStatus> get status => _statusSubject.stream;

  void add(GameEvent event) {
    switch (event.runtimeType) {
      case EnterRoundResult:
        event = event as EnterRoundResult;
        _gameRound = GameRound(pairs: pairs, result: event.result);
        // When having three players, lions and hedgehogs count in the first round.
        _statusSubject.add(pairs == null && event.result.length > 3
            ? GameRoundStatus.done
            : GameRoundStatus.enterTricks);
        break;
      case HasHedgehogs:
        event = event as HasHedgehogs;
        _gameRound.setHasHedgehogs(event.player, event.value);
        break;
      case NumberOfLions:
        event = event as NumberOfLions;
        _gameRound.setNumberOfLions(event.player, event.number);
        break;
      case LionsInHandLastPlayer:
        event = event as LionsInHandLastPlayer;
        _gameRound.setLionsInHandLastPlayer(event.number);
        break;
      case FinalizeRound:
        _statusSubject.add(GameRoundStatus.done);
        break;
      default:
        throw UnsupportedError('Unknown game event');
    }
    _subject.add(_gameRound);
    if (_statusSubject.value == GameRoundStatus.done) {
      _gameRound.validate();
      callback(_gameRound);
      _subject.close();
      _statusSubject.close();
    }
  }
}
