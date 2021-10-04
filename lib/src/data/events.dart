import 'model.dart';

abstract class GameEvent {}

class EnterRoundResult extends GameEvent {
  final List<Player> result;

  EnterRoundResult(this.result);
}

class EnterRoundTricks extends GameEvent {
  final Set<Player> hasHedgehogs;
  final Map<Player, int> numberOfLions;
  final int lionsInHandLastPlayer;

  EnterRoundTricks({
    required this.hasHedgehogs,
    required this.numberOfLions,
    required this.lionsInHandLastPlayer,
  });
}
