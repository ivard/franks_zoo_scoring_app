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

  int getScore(Player player) =>
      _rounds.fold(0, (prevScore, round) => prevScore + round.getScore(player));

  List<Player> getRanking() {
    final playersList = players.toList();
    playersList.sort((a, b) {
      final comparedScore = getScore(a).compareTo(getScore(b));
      if (comparedScore != 0 || _rounds.isEmpty) return comparedScore;
      final lastResult = _rounds.last.result;
      return lastResult.indexOf(a).compareTo(lastResult.indexOf(b));
    });
    return playersList;
  }
}

class GameRound {
  final List<Player> result;
  final Set<Player> hasHedgehogs;
  final Map<Player, int> numberOfLions;
  final int lionsInHandLastPlayer;

  GameRound({
    required this.result,
    required this.hasHedgehogs,
    required this.numberOfLions,
    required this.lionsInHandLastPlayer,
  });

  int getScore(Player player) {
    int newScore = 0;
    if (result.last == player) {
      newScore -= lionsInHandLastPlayer;
    } else {
      newScore += result.length - result.indexOf(player);
    }
    if (!hasHedgehogs.contains(player)) newScore -= 1;
    newScore += numberOfLions[player]! >= 2 ? numberOfLions[player]! : 0;
    return newScore;
  }
}
