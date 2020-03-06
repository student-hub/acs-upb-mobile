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

  group('Login', () {
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

    testWidgets('Anonymous login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp(authProvider: mockAuthProvider));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        expect(find.byType(LoginView), findsOneWidget);

        when(mockAuthProvider.signInAnonymously(context: anyNamed('context')))
            .thenAnswer((_) => Future.value(true));

        // Log in anonymously
        await tester.tap(find.text('LOG IN ANONYMOUSLY'));
        await tester.pumpAndSettle();

        verify(
            mockAuthProvider.signInAnonymously(context: anyNamed('context')));
        expect(find.byType(HomePage), findsOneWidget);

        // Easy way to check that the login page can't be navigated back to
        expect(find.byIcon(Icons.arrow_back), findsNothing);
      });
    });
  });
}
