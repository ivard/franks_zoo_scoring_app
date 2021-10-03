import 'dart:async';

import 'model.dart';

abstract class GameEvent<Result> {
  final _completer = Completer<Result>();

  Future<Result> get future => _completer.future;

  void complete(Result result) => _completer.complete(result);
}

class EnterResult extends GameEvent<List<Player>> {}

class EnterHedgehogs extends GameEvent<Set<Player>> {}

class EnterLions extends GameEvent<Map<Player, int>> {}
