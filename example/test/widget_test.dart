import 'package:example/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the media editor example', (tester) async {
    await tester.pumpWidget(const MediaEditorExampleApp());

    expect(find.text('V Chat Media Editor'), findsOneWidget);
    expect(find.text('Select media'), findsOneWidget);
    expect(find.text('Edited media will appear here.'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
