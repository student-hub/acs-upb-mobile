import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  AuthProvider mockAuthProvider;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PrefService.enableCaching();
    PrefService.cache = {};
    PrefService.setString('language', 'en');

    // Mock the behaviour of the auth provider
    // TODO: Test AuthProvider separately
    mockAuthProvider = MockAuthProvider();
    // ignore: invalid_use_of_protected_member
    when(mockAuthProvider.hasListeners).thenReturn(false);
    when(mockAuthProvider.isAuthenticated).thenReturn(false);
  });

  group('Login', () {
    testWidgets('Anonymous login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(authProvider: mockAuthProvider));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        expect(find.byType(LoginView), findsOneWidget);

        when(mockAuthProvider.signInAnonymously(context: anyNamed('context')))
            .thenAnswer((_) => Future.value(true));

        // Log in anonymously
        await tester.tap(find.byKey(ValueKey('log_in_anonymously_button')));
        await tester.pumpAndSettle();

        verify(
            mockAuthProvider.signInAnonymously(context: anyNamed('context')));
        expect(find.byType(HomePage), findsOneWidget);

        // Easy way to check that the login page can't be navigated back to
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      });
    });

    testWidgets('Credential login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(authProvider: mockAuthProvider));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        expect(find.byType(LoginView), findsOneWidget);

        when(mockAuthProvider.signIn(
                email: anyNamed('email'),
                password: anyNamed('password'),
                context: anyNamed('context')))
            .thenAnswer((_) => Future.value(true));

        // Enter credentials
        await tester.enterText(
            find.byKey(ValueKey('email_text_field')), 'test@test.com');
        await tester.enterText(
            find.byKey(ValueKey('password_text_field')), 'password');

        await tester.tap(find.byKey(ValueKey('log_in_button')));
        await tester.pumpAndSettle();

        verify(mockAuthProvider.signIn(
            email: argThat(equals('test@test.com'), named: 'email'),
            password: argThat(equals('password'), named: 'password'),
            context: anyNamed('context')));
        expect(find.byType(HomePage), findsOneWidget);

        // Easy way to check that the login page can't be navigated back to
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      });
    });
  });

  group('Recover password', () {
    testWidgets('Send email', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(authProvider: mockAuthProvider));
      await tester.pumpAndSettle();

      expect(find.byType(LoginView), findsOneWidget);

      when(mockAuthProvider.sendPasswordResetEmail(
              email: anyNamed('email'), context: anyNamed('context')))
          .thenAnswer((_) => Future.value(true));

      expect(find.byType(AlertDialog), findsNothing);

      // Reset password
      await tester.tap(find.text('Reset password'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Send email
      await tester.enterText(
          find.byKey(ValueKey('reset_password_email_text_field')),
          'test@test.com');

      await tester.tap(find.byKey(ValueKey('send_email_button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      verify(mockAuthProvider.sendPasswordResetEmail(
          email: argThat(equals('test@test.com'), named: 'email'),
          context: anyNamed('context')));
    });

    testWidgets('Cancel', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(authProvider: mockAuthProvider));
      await tester.pumpAndSettle();

      expect(find.byType(LoginView), findsOneWidget);

      when(mockAuthProvider.sendPasswordResetEmail(
              email: anyNamed('email'), context: anyNamed('context')))
          .thenAnswer((_) => Future.value(true));

      expect(find.byType(AlertDialog), findsNothing);

      // Reset password
      await tester.tap(find.text('Reset password'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.byKey(ValueKey('cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);

      verifyNever(
          mockAuthProvider.sendPasswordResetEmail(email: anyNamed('email')));
    });
  });
}
