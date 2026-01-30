import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(child: MaterialApp(home: ProfileScreen()));
  }

  testWidgets("ProfileScreen renders app bar and title", (tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("My Profile"), findsOneWidget);
  });

  testWidgets("ProfileScreen shows placeholder avatar when no image", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets("ProfileScreen shows user info labels", (tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Unknown User"), findsOneWidget);
    // Email may be empty string, but widget exists
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets("ProfileScreen renders info cards", (tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Health Records"), findsOneWidget);
    expect(find.text("Appointments"), findsOneWidget);
    expect(find.text("Settings"), findsOneWidget);
    expect(find.text("Help & Support"), findsOneWidget);
  });

  testWidgets("ProfileScreen renders logout button", (tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Logout"), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}
