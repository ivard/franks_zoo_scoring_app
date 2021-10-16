import 'package:flutter_test/flutter_test.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';

void main() {
  test('scoring', () {
    final players = ['alpha', 'beta', 'gamma'];
    GameScore score = GameScore(players: players.toSet());
    expect(players.map((p) => score.getScore(p)), List.filled(3, 0));

    score = score.addRound(GameRound(result: ['alpha', 'beta', 'gamma']));
    expect(score.getRanking(), ['alpha', 'beta', 'gamma']);
    expect(players.map((p) => score.getScore(p)), [3, 2, 0]);

    score = score.addRound(GameRound(
      result: ['gamma', 'beta', 'alpha'],
      pairs: score.getPairsForNextRound(),
    ));
    expect(score.getRanking(), ['beta', 'alpha', 'gamma']);
    expect(players.map((p) => score.getScore(p)), [5, 7, 2]);

    final round = GameRound(
      result: ['alpha', 'gamma', 'beta'],
      pairs: score.getPairsForNextRound(),
    );
    round.setHasHedgehogs('gamma', true);
    round.setLionsInHandLastPlayer(1);
    round.setNumberOfLions('gamma', 3);
    round.validate();
    score = score.addRound(round);
    expect(score.getRanking(), ['alpha', 'beta', 'gamma']);
    expect(players.map((p) => score.getScore(p)), [11, 7, 7]);
  });
}
