import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  AuthProvider mockAuthProvider;

  group('Navigation', () {
    const double PORTRAIT_WIDTH = 400.0;
    const double PORTRAIT_HEIGHT = 800.0;
    const double LANDSCAPE_WIDTH = PORTRAIT_HEIGHT;
    const double LANDSCAPE_HEIGHT = PORTRAIT_WIDTH;

    final TestWidgetsFlutterBinding binding =
    TestWidgetsFlutterBinding.ensureInitialized();

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

    testWidgets('Home - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Home - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Timetable - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open timetable
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Timetable'), findsNWidgets(2));
    });

    testWidgets('Timetable - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open timetable
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Timetable'), findsNWidgets(2));
    });

    testWidgets('Map - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open map
      await tester.tap(find.byIcon(Icons.map));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Map'), findsNWidgets(2));
    });

    testWidgets('Map - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open timetable
      await tester.tap(find.byIcon(Icons.map));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Map'), findsNWidgets(2));
    });

    testWidgets('Portal - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open portal
      await tester.tap(find.byIcon(Icons.public));
      await tester.pumpAndSettle();

      expect(find.byType(PortalPage), findsOneWidget);
    });

    testWidgets('Portal - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open portal
      await tester.tap(find.byIcon(Icons.public));
      await tester.pumpAndSettle();

      expect(find.byType(PortalPage), findsOneWidget);
    });

    testWidgets('Profile - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Profile'), findsNWidgets(2));
    });

    testWidgets('Profile - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      // Open profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // TODO: Replace with page when implemented
      expect(find.text('Profile'), findsNWidgets(2));
    });

    testWidgets('Settings - portrait', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      await tester.pumpWidget(ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider, child: MyApp()));
      await tester.pumpAndSettle();

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('Settings - landscape', (WidgetTester tester) async {
      await binding.setSurfaceSize(Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

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
