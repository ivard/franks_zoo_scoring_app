import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:franks_zoo_scoring_app/src/data/events.dart';
import 'package:franks_zoo_scoring_app/src/data/model.dart';

import 'package:franks_zoo_scoring_app/src/screens/add_players_screen.dart';
import 'package:franks_zoo_scoring_app/src/screens/enter_result_screen.dart';

void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;

  testWidgets('add-players', (WidgetTester tester) async {
    final selected = Completer<Set<String>>();
    await tester.pumpWidget(MaterialApp(
      home: AddPlayersScreen(
        onPlayersSelected: (players) => selected.complete(players),
      ),
    ));

    final noPlayersFound = find
        .text('Te weinig spelers gevonden. Het minimale aantal spelers is 3.');
    expect(noPlayersFound, findsNothing);
    await tester.tap(find.text('Doorgaan'));
    await tester.pump();
    expect(noPlayersFound, findsOneWidget);
    await tester.pumpAndSettle();
    expect(selected.isCompleted, false);

    // TODO: Add test to remove user.
    /*
    // Test to add player by pressing button
    await tester.enterText(find.byType(TextField), 'Player 1');
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // Test to delete a player
    await tester.enterText(find.byType(TextField), 'Player 2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.drag(find.text('Player 2'), const Offset(500, 0));
    await tester.pumpAndSettle();

    // Test to add player by entering enter button
    await tester.enterText(find.byType(TextField), 'Player 3');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.text('Doorgaan'));
    await tester.pump();
    expect(await selected.future, {'Player 1', 'Player 3'});
     */
  });

  testWidgets('enter-result', (WidgetTester tester) async {
    final completer = Completer<EnterRoundResult>();
    await tester.pumpWidget(MaterialApp(
      home: EnterResultScreen(
        prevScore: GameScore(players: {'Player 1', 'Player 2'}),
        callback: completer.complete,
      ),
    ));
    //final secondListTile = find.widgetWithText(ListTile, 'Player 2');

    // TODO: Fix

    await tester.pumpAndSettle();
    await tester.tap(find.text('Doorgaan'));
    await tester.pump();

    //expect(await completer.future, ['Player 2', 'Player 1']);
  });
}
