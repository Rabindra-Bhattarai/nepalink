import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/presentation/pages/caregiver_dashboard.dart';

void main() {
  Widget createTestWidget() {
    return const MaterialApp(home: CaregiverDashboard());
  }

  testWidgets("CaregiverDashboard renders app bar with logo and actions", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
  });

  testWidgets("CaregiverDashboard shows bottom navigation items", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Home"), findsOneWidget);
    expect(find.text("Task"), findsOneWidget);
    expect(find.text("location"), findsOneWidget);
    expect(find.text("Caregiver"), findsOneWidget);
    expect(find.text("Profile"), findsOneWidget);
  });

  testWidgets("CaregiverDashboard starts with Home tab selected", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    final bottomNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNav.currentIndex, 0);
  });

  testWidgets("CaregiverDashboard switches to Task tab when tapped", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.tap(find.text("Task"));
    await tester.pumpAndSettle();
    final bottomNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNav.currentIndex, 1);
  });

  testWidgets("CaregiverDashboard switches to Profile tab when tapped", (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle();
    final bottomNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNav.currentIndex, 4);
  });
}
