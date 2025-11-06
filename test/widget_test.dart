import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vha_note/widget/LabelListScreen.dart';

void main() {
  testWidgets('LabelListScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LabelListScreen()));
    expect(find.text('Note'), findsOneWidget);
  });
}
