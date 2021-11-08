import 'dart:async';

import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:rxdart/rxdart.dart';

class GameRoundBloc {
  final Pairs? pairs;
  final Function(GameRound) callback;

  final _subject = BehaviorSubject<GameRound>();

  late GameRound _gameRound;

  GameRoundBloc({required this.callback, this.pairs});

  Stream<GameRound> get stream => _subject.stream;

  void add(GameEvent event) {
    bool finalize = false;
    switch (event.runtimeType) {
      case EnterRoundResult:
        event = event as EnterRoundResult;
        _gameRound = GameRound(pairs: pairs, result: event.result);
        // When having three players, lions and hedgehogs count in the first round.
        if (pairs == null && event.result.length > 3) finalize = true;
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
        finalize = true;
        break;
      default:
        throw UnsupportedError('Unknown game event');
    }
    _subject.add(_gameRound);
    if (finalize) {
      _gameRound.validate();
      callback(_gameRound);
      _subject.close();
    }
  }
}
