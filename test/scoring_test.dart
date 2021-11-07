import 'package:flutter_test/flutter_test.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';

void main() {
  test('scoring-3', () {
    final players = ['alpha', 'beta', 'gamma'];
    GameScore score = GameScore(players: players.toSet());
    expect(players.map((p) => score.getScore(p)), List.filled(3, 0));

    score = score.addRound(GameRound(result: ['alpha', 'beta', 'gamma']));
    expect(score.getRanking(), ['alpha', 'beta', 'gamma']);
    expect(players.map((p) => score.getScore(p)), [2, 1, -1]);

    score = score.addRound(GameRound(
      result: ['gamma', 'beta', 'alpha'],
      pairs: score.getPairsForNextRound(),
    ));
    expect(score.getRanking(), ['beta', 'alpha', 'gamma']);
    expect(players.map((p) => score.getScore(p)), [1, 2, 1]);

    final round = GameRound(
      result: ['alpha', 'gamma', 'beta'],
      pairs: score.getPairsForNextRound(),
    );
    round.setHasHedgehogs('gamma', true);
    round.setLionsInHandLastPlayer(1);
    round.setNumberOfLions('gamma', 3);
    round.validate();
    score = score.addRound(round);
    expect(score.getRanking(), ['gamma', 'alpha', 'beta']);
    expect(players.map((p) => score.getScore(p)), [3, 0, 6]);
  });

  test('scoring-4', () {
    final players = ['alpha', 'beta', 'gamma', 'delta'];
    GameScore score = GameScore(players: players.toSet());
    expect(players.map((p) => score.getScore(p)), List.filled(4, 0));

    score = score.addRound(GameRound(
      result: ['alpha', 'beta', 'gamma', 'delta'],
    ));
    expect(score.getRanking(), ['alpha', 'beta', 'gamma', 'delta']);
    expect(players.map((p) => score.getScore(p)), [4, 3, 2, 0]);

    score = score.addRound(GameRound(
      result: ['gamma', 'beta', 'alpha', 'delta'],
      pairs: score.getPairsForNextRound(),
    ));
    expect(score.getRanking(), ['alpha', 'gamma', 'beta', 'delta']);
    expect(players.map((p) => score.getScore(p)), [9, 5, 7, 2]);

    final round = GameRound(
      result: ['alpha', 'gamma', 'beta', 'delta'],
      pairs: score.getPairsForNextRound(),
    );
    round.setHasHedgehogs('gamma', true);
    round.setLionsInHandLastPlayer(1);
    round.setNumberOfLions('gamma', 3);
    round.validate();
    score = score.addRound(round);
    expect(score.getRanking(), ['alpha', 'gamma', 'beta', 'delta']);
    expect(players.map((p) => score.getScore(p)), [14, 10, 13, 3]);
  });
}
