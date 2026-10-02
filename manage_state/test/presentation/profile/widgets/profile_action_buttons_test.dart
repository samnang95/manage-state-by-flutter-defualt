import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manage_state/presentation/profile/widgets/profile_action_buttons.dart';

void main() {
  testWidgets('ProfileActionButtons renders Add to story and Edit profile buttons', (WidgetTester tester) async {
    // 1. Arrange: Pump the widget into our test environment
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileActionButtons(),
        ),
      ),
    );

    // 2. Assert: Verify both buttons exist by searching for their text
    expect(find.text('Add to story'), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);

    // 3. Assert: Verify the icons are rendered correctly
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
