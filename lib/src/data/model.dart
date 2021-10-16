typedef Player = String;

class Pairs {
  final List<List<Player>> _internal = [];

  Pairs({required List<Player> ranking}) {
    final upperPlayers =
        ranking.getRange(0, (ranking.length / 2).ceil()).toList();
    final lowerPlayers =
        ranking.getRange((ranking.length / 2).ceil(), ranking.length).toList();
    for (int i = 0; i < upperPlayers.length; i++) {
      if (i < lowerPlayers.length) {
        _internal.add([upperPlayers[i], lowerPlayers[i]]);
      }
    }
  }

  bool hasTeamMate(Player player) =>
      _internal.any((pair) => pair.contains(player));

  Player getTeamMate(Player player) => _internal
      .firstWhere((pair) => pair.contains(player))
      .firstWhere((p) => p != player);
}

class GameScore {
  final Set<Player> players;
  final List<GameRound> _rounds;

  GameScore({required this.players}) : _rounds = [];
  GameScore._withRounds(this._rounds, {required this.players});

  GameScore addRound(GameRound round) => GameScore._withRounds(
        [..._rounds, round],
        players: players,
      );

  int get numberOfRounds => _rounds.length;

  int getScore(Player player) {
    int score = 0;
    for (int i = 0; i < _rounds.length; i++) {
      score += _rounds[i].getScore(player);
    }
    return score;
  }

  List<Player> getRanking() {
    final playersList = players.toList();
    playersList.sort((a, b) {
      final comparedScore = getScore(a).compareTo(getScore(b));
      if (comparedScore != 0 || _rounds.isEmpty) return comparedScore;
      final lastResult = _rounds.last.result;
      // The worst ranked player gets preference.
      return lastResult.indexOf(a).compareTo(lastResult.indexOf(b));
    });
    return playersList.reversed.toList();
  }

  Pairs? getPairsForNextRound() =>
      _rounds.isNotEmpty ? Pairs(ranking: getRanking()) : null;
}

class GameRound {
  final Pairs? pairs;
  final List<Player> result;
  final Set<Player> hasHedgehogs;
  final Map<Player, int> numberOfLions;
  int lionsInHandLastPlayer;

  GameRound({
    this.pairs,
    required this.result,
  })  : hasHedgehogs = {},
        numberOfLions = Map.fromIterable(result, value: (_) => 0),
        lionsInHandLastPlayer = 0;

  void validate() {
    final amountLions = [...numberOfLions.values, lionsInHandLastPlayer]
        .fold<int>(0, (prev, curr) => prev + curr);
    if (amountLions < 0 || amountLions > 5 || hasHedgehogs.length > 5) {
      throw InvalidScoreException();
    }
  }

  void setHasHedgehogs(Player player, bool value) {
    if (value) {
      hasHedgehogs.add(player);
    } else {
      hasHedgehogs.remove(player);
    }
  }

  void setNumberOfLions(Player player, int number) {
    assert(number >= 0 && number <= 5);
    numberOfLions[player] = number;
  }

  void setLionsInHandLastPlayer(int number) {
    assert(number >= 0 && number <= 5);
    lionsInHandLastPlayer = number;
  }

  int _getRankingScore(Player player) =>
      result.last == player ? 0 : result.length - result.indexOf(player);

  int getScore(Player player) {
    int newScore = _getRankingScore(player);
    if (pairs != null) {
      if (result.last == player) {
        newScore -= lionsInHandLastPlayer;
      }
      newScore += pairs!.hasTeamMate(player)
          ? _getRankingScore(pairs!.getTeamMate(player))
          : 4;
      if (!hasHedgehogs.contains(player)) newScore -= 1;
      newScore += numberOfLions[player]! >= 2 ? numberOfLions[player]! : 0;
    }
    return newScore;
  }
}

class InvalidScoreException implements Exception {}
