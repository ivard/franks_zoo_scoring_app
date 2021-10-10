import 'dart:async';

import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';

class GameRoundBloc {
  final Pairs? pairs;
  final Function(GameRound) callback;

  final _resultCompleter = Completer<List<Player>>();
  final _streamController = StreamController<GameRound>();

  late GameRound _gameRound;

  GameRoundBloc({required this.callback, this.pairs});

  Stream<GameRound> get stream => _streamController.stream;

  // Only state this bloc has is whether the result is known or not.
  // We return this as a future.
  Future<List<Player>> get result => _resultCompleter.future;

  void add(GameEvent event) {
    switch (event.runtimeType) {
      case EnterRoundResult:
        event = event as EnterRoundResult;
        _gameRound = GameRound(pairs: pairs, result: event.result);
        _resultCompleter.complete(event.result);
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
        _gameRound.validate();
        callback(_gameRound);
        break;
      default:
        throw UnsupportedError('Unknown game event');
    }
    _streamController.add(_gameRound);
  }
}
