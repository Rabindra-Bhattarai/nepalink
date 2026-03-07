import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nepalink/features/auth/presentation/pages/login_screen.dart';
import 'package:nepalink/features/auth/presentation/view_model/login_viewmodel.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/core/services/biometric/biometric_service.dart';

@GenerateMocks([LoginUsecase, UserSessionService, BiometricService])
import 'login_screen_test.mocks.dart';

Widget buildLoginScreen({MockBiometricService? biometricService}) {
  final mockBiometric = biometricService ?? MockBiometricService();
  when(mockBiometric.isAvailable()).thenAnswer((_) async => false);
  when(mockBiometric.isBiometricEnabled()).thenAnswer((_) async => false);

  return ProviderScope(
    overrides: [
      loginViewModelProvider.overrideWith(
        (ref) => LoginViewModel(
          MockLoginUsecase(),
          MockUserSessionService(),
          mockBiometric,
        ),
      ),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  // FIX 1: Set a tall enough surface so the Sign In button is on-screen.
  // The login screen has an info card + login card — 600px height is not enough.
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('LoginScreen widget tests', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('renders Sign In button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('renders Welcome to NepaLink text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      expect(find.text('Welcome to NepaLink'), findsOneWidget);
    });

    // FIX 2: "Register" is inside a RichText/TextSpan, not a standalone Text widget.
    // Neither find.text() nor find.textContaining() search inside TextSpan children.
    // We use find.byWidgetPredicate to walk the RichText's InlineSpan tree manually.
    testWidgets('renders Register navigation text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();

      // Collect all text from every RichText widget in the tree and check
      // that at least one contains the word "Register".
      bool foundRegister = false;
      find.byType(RichText).evaluate().forEach((element) {
        final richText = element.widget as RichText;
        final buffer = StringBuffer();
        richText.text.visitChildren((span) {
          if (span is TextSpan && span.text != null) buffer.write(span.text);
          return true;
        });
        if (buffer.toString().contains('Register')) foundRegister = true;
      });

      expect(
        foundRegister,
        isTrue,
        reason: 'Expected to find "Register" inside a RichText widget',
      );
    });

    testWidgets('shows validation error when email is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('shows validation error when password is empty', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@gmail.com',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows validation error when password is too short', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('password field is obscured by default', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      final editableText = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .last;
      expect(editableText.obscureText, true);
    });

    testWidgets('toggle password visibility icon is present', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('renders Sign in to your account subtitle', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildLoginScreen());
      await tester.pumpAndSettle();
      expect(find.text('Sign in to your account'), findsOneWidget);
    });
  });
}
