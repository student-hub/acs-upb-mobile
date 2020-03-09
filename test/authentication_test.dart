import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

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
    when(mockAuthProvider.isAuthenticatedAsync)
        .thenAnswer((realInvocation) => Future.value(false));
  });

  group('Login', () {
    testWidgets('Anonymous login', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
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
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
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
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
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
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
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

  group('Sign up', () {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();

    testWidgets('Sign up', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MyApp(navigationObservers: [mockObserver])));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(LoginView), findsOneWidget);

      // Scroll sign up button into view and tap
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(SignUpView), findsOneWidget);

      when(mockAuthProvider.signUp(
              info: anyNamed('info'), context: anyNamed('context')))
          .thenAnswer((_) => Future.value(true));
      when(mockAuthProvider.canSignUpWithEmail(email: anyNamed('email')))
          .thenAnswer((realInvocation) => Future.value(true));
      when(mockAuthProvider.isStrongPassword(password: anyNamed('password')))
          .thenAnswer((realInvocation) => Future.value(true));

      // Enter info
      await tester.enterText(
          find.byKey(ValueKey('email_text_field'), skipOffstage: true),
          'test@test.com');
      await tester.enterText(
          find.byKey(ValueKey('password_text_field'), skipOffstage: true),
          'password');
      await tester.enterText(
          find.byKey(ValueKey('confirm_password_text_field')), 'password');
      await tester.enterText(
          find.byKey(ValueKey('first_name_text_field')), 'John');
      await tester.enterText(
          find.byKey(ValueKey('last_name_text_field')), 'Doe');
      await tester.enterText(find.byKey(ValueKey('group_text_field')), '314CB');

      // Scroll sign up button into view and tap
      await tester.ensureVisible(find.byKey(ValueKey('sign_up_button')));
      await tester.tap(find.byKey(ValueKey('sign_up_button')));
      await tester.pumpAndSettle();

      verify(mockAuthProvider.signUp(
          info: argThat(
              equals({
                'Email': 'test@test.com',
                'Password': 'password',
                'Confirm password': 'password',
                'First name': 'John',
                'Last name': 'Doe',
                'Group': '314CB'
              }),
              named: 'info'),
          context: anyNamed('context')));
      expect(find.byType(HomePage), findsOneWidget);
      verify(mockObserver.didPush(any, any));
    });

    testWidgets('Cancel', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MyApp(navigationObservers: [mockObserver])));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(LoginView), findsOneWidget);

      // Scroll sign up button into view and tap
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(SignUpView), findsOneWidget);

      when(mockAuthProvider.signUp(
              info: anyNamed('info'), context: anyNamed('context')))
          .thenAnswer((_) => Future.value(true));

      // Scroll cancel button into view and tap
      await tester.ensureVisible(find.byKey(ValueKey('cancel_button')));
      await tester.tap(find.byKey(ValueKey('cancel_button')));
      await tester.pumpAndSettle();

      verifyNever(mockAuthProvider.signUp(
          info: anyNamed('info'), context: anyNamed('context')));
      expect(find.byType(LoginView), findsOneWidget);
      expect(find.byType(SignUpView), findsNothing);
      verify(mockObserver.didPop(any, any));
    });
  });
}
