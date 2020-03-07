import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  AuthProvider mockAuthProvider;

  group('Drawer', () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      PrefService.enableCaching();
      PrefService.cache = {};
      PrefService.setString('language', 'en');

      // Pretend an anonymous user is already logged in
      mockAuthProvider = MockAuthProvider();
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      // ignore: invalid_use_of_protected_member
      when(mockAuthProvider.hasListeners).thenReturn(false);
      when(mockAuthProvider.isAnonymous).thenReturn(true);
    });

    testWidgets('Home', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Settings', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
}
