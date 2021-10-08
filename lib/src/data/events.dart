import 'model.dart';

abstract class GameEvent {}

class EnterRoundResult extends GameEvent {
  final List<Player> result;

  EnterRoundResult(this.result);
}

class HasHedgehogs extends GameEvent {
  final Player player;
  final bool value;

  HasHedgehogs({
    required this.player,
    this.value = true,
  });
}

class NumberOfLions extends GameEvent {
  final Player player;
  final int number;

  NumberOfLions({
    required this.player,
    required this.number,
  });
}

class LionsInHandLastPlayer extends GameEvent {
  final int number;

  LionsInHandLastPlayer({
    required this.number,
  });
}

class FinalizeRound extends GameEvent {}
