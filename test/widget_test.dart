import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:franks_zoo_scoring_app/src/screens/add_players_screen.dart';

void main() {
  testWidgets('add-players', (WidgetTester tester) async {
    final selected = Completer<List<String>>();
    await tester.pumpWidget(MaterialApp(
      home: AddPlayersScreen(
        onPlayersSelected: (players) => selected.complete(players),
      ),
    ));

    await tester.tap(find.text('Doorgaan'));
    await tester.pumpAndSettle();
    expect(selected.isCompleted, false);

    // Test add player button
    await tester.enterText(find.byType(TextField), 'Player 1');
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    // Test entering enter button
    await tester.enterText(find.byType(TextField), 'Player 2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.text('Doorgaan'));
    await tester.pump();
    expect(await selected.future, ['Player 1', 'Player 2']);
  });
}
