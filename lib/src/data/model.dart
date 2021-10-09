typedef Player = String;

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
      score += _rounds[i].getScore(player, i > 0 ? _rounds[i - 1] : null);
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
      return -1 * lastResult.indexOf(a).compareTo(lastResult.indexOf(b));
    });
    return playersList.reversed.toList();
  }
}

class GameRound {
  final List<Player> result;
  final Set<Player> hasHedgehogs;
  final Map<Player, int> numberOfLions;
  int lionsInHandLastPlayer;

  GameRound({
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

  Player? getTeamMate(Player player) {
    final upperPlayers =
        result.getRange(0, (result.length / 2).ceil()).toList();
    final lowerPlayers =
        result.getRange((result.length / 2).ceil(), result.length).toList();
    return upperPlayers.contains(player)
        ? lowerPlayers[upperPlayers.indexOf(player)]
        : upperPlayers[lowerPlayers.indexOf(player)];
  }

  int _getRankingScore(Player player) =>
      result.last == player ? 0 : result.length - result.indexOf(player);

  int getScore(Player player, GameRound? prevRound) {
    int newScore = _getRankingScore(player);
    if (prevRound != null) {
      if (result.last == player) {
        newScore -= lionsInHandLastPlayer;
      }
      final teamMate = prevRound.getTeamMate(player);
      newScore += teamMate == null ? 4 : _getRankingScore(teamMate);
      if (!hasHedgehogs.contains(player)) newScore -= 1;
      newScore += numberOfLions[player]! >= 2 ? numberOfLions[player]! : 0;
    }
    return newScore;
  }
}

class InvalidScoreException implements Exception {}
