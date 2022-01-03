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

  test('scoring-5', () {
    final players = ['alpha', 'beta', 'gamma', 'delta', 'epsilon'];
    GameScore score = GameScore(players: players.toSet());
    expect(players.map((p) => score.getScore(p)), List.filled(5, 0));

    score = score.addRound(GameRound(
      result: ['alpha', 'beta', 'gamma', 'delta', 'epsilon'],
    ));
    expect(score.getRanking(), ['alpha', 'beta', 'gamma', 'delta', 'epsilon']);
    expect(players.map((p) => score.getScore(p)), [5, 4, 3, 2, 0]);

    Pairs pairs = score.getPairsForNextRound()!;
    players
        .where((p) => p != 'gamma')
        .forEach((p) => expect(pairs.hasTeamMate(p), true));
    expect(pairs.hasTeamMate('gamma'), false);
    expect(pairs.getTeamMate('alpha'), 'delta');
    expect(pairs.getTeamMate('beta'), 'epsilon');
    expect(pairs.getTeamMate('delta'), 'alpha');
    expect(pairs.getTeamMate('epsilon'), 'beta');

    score = score.addRound(GameRound(
      result: ['gamma', 'beta', 'alpha', 'delta', 'epsilon'],
      pairs: pairs,
    ));
    expect(score.getRanking(), ['gamma', 'alpha', 'beta', 'delta', 'epsilon']);
    expect(players.map((p) => score.getScore(p)), [9, 7, 11, 6, 3]);

    pairs = score.getPairsForNextRound()!;
    players
        .where((p) => p != 'beta')
        .forEach((p) => expect(pairs.hasTeamMate(p), true));
    expect(pairs.hasTeamMate('beta'), false);
    expect(pairs.getTeamMate('alpha'), 'epsilon');
    expect(pairs.getTeamMate('gamma'), 'delta');
    expect(pairs.getTeamMate('delta'), 'gamma');
    expect(pairs.getTeamMate('epsilon'), 'alpha');

    final round = GameRound(
      result: ['epsilon', 'alpha', 'gamma', 'beta', 'delta'],
      pairs: pairs,
    );
    round.setHasHedgehogs('delta', true);
    round.setHasHedgehogs('epsilon', true);
    round.setLionsInHandLastPlayer(1);
    round.setNumberOfLions('delta', 1);
    round.setNumberOfLions('epsilon', 2);
    round.validate();
    score = score.addRound(round);
    expect(score.getRanking(), ['alpha', 'epsilon', 'gamma', 'beta', 'delta']);
    expect(players.map((p) => score.getScore(p)), [17, 12, 13, 8, 14]);
  });
}
