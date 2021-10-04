import 'dart:async';

import 'package:franks_zoo_scoring_app/src/data/model.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';

class GameRoundBloc {
  final Function(GameRound) callback;

  final _resultCompleter = Completer<List<Player>>();

  late EnterRoundResult? _resultEvent;
  late EnterRoundTricks? _tricksEvent;

  GameRoundBloc(this.callback);

  // Only state this bloc has is whether the result is known or not.
  // We return this as a future.
  Future<List<Player>> get result => _resultCompleter.future;

  void add(GameEvent event) {
    switch (event.runtimeType) {
      case EnterRoundResult:
        _resultEvent = event as EnterRoundResult;
        _resultCompleter.complete(event.result);
        break;
      case EnterRoundTricks:
        _tricksEvent = event as EnterRoundTricks;
        break;
      default:
        throw UnsupportedError('Unknown game event');
    }

    // If all events are in, we can determine the result.
    if (_resultEvent != null && _tricksEvent != null) {
      callback(GameRound(
        result: _resultEvent!.result,
        hasHedgehogs: _tricksEvent!.hasHedgehogs,
        numberOfLions: _tricksEvent!.numberOfLions,
        lionsInHandLastPlayer: _tricksEvent!.lionsInHandLastPlayer,
      ));
    }
  }
}
