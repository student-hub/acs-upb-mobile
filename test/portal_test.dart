import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockWebsiteProvider extends Mock implements WebsiteProvider {}

class MockStorageProvider extends Mock implements StorageProvider {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  final WebsiteProvider mockWebsiteProvider = MockWebsiteProvider();
  // ignore: invalid_use_of_protected_member
  when(mockWebsiteProvider.hasListeners).thenReturn(false);
  when(mockWebsiteProvider.getWebsites())
      .thenAnswer((_) => Stream.fromIterable([
            [
              Website(
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/moodle.png',
                infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
                label: 'Moodle',
                link: 'http://acs.curs.pub.ro/',
              ),
              Website(
                category: WebsiteCategory.learning,
                iconPath: 'icons/websites/ocw.png',
                infoByLocale: {},
                label: 'OCW',
                link: 'https://ocw.cs.pub.ro/',
              ),
              Website(
                category: WebsiteCategory.association,
                iconPath: 'icons/websites/lsac.png',
                infoByLocale: {},
                label: 'LSAC',
                link: 'https://lsacbucuresti.ro/',
              ),
            ]
          ]));

  final StorageProvider mockStorageProvider = MockStorageProvider();
  // ignore: invalid_use_of_protected_member
  when(mockStorageProvider.hasListeners).thenReturn(false);

  final MockUrlLauncher mockUrlLauncher = MockUrlLauncher();
  UrlLauncherPlatform.instance = mockUrlLauncher;
  when(mockUrlLauncher.canLaunch(any))
      .thenAnswer((realInvocation) => Future.value(true));

  final portal = () => MultiProvider(
          providers: [
            ChangeNotifierProvider<WebsiteProvider>(
                create: (_) => mockWebsiteProvider),
            ChangeNotifierProvider<StorageProvider>(
                create: (_) => mockStorageProvider)
          ],
          child: MaterialApp(
              localizationsDelegates: [S.delegate], home: PortalPage()));

  group('Portal', () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      PrefService.enableCaching();
      PrefService.cache = {};
      PrefService.setString('language', 'en');
    });

    testWidgets('Names', (WidgetTester tester) async {
      await tester.pumpWidget(portal());
      await tester.pumpAndSettle();

      expect(find.text('Moodle'), findsOneWidget);
      expect(find.text('OCW'), findsOneWidget);
      expect(find.text('LSAC'), findsOneWidget);
    });

    testWidgets('Localization', (WidgetTester tester) async {
      await tester.pumpWidget(portal());
      await tester.pumpAndSettle();

      expect(find.byTooltip('info-en'), findsOneWidget);

      PrefService.setString('language', 'ro');

      await tester.pumpWidget(portal());
      await tester.pumpAndSettle();

      expect(find.byTooltip('info-ro'), findsOneWidget);
    });

    testWidgets('Spoilers', (WidgetTester tester) async {
      await tester.pumpWidget(portal());
      await tester.pumpAndSettle();

      // Both categories are expanded at first
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsNWidgets(2));

      expect(find.byKey(Key('spoiler_child_closed')), findsNothing);
      expect(find.byKey(Key('spoiler_child_opened')), findsNWidgets(2));

      // Hide 'Learning' category
      await tester.tap(find.text('Learning'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

      expect(find.byKey(Key('spoiler_child_closed')), findsOneWidget);
      expect(find.byKey(Key('spoiler_child_opened')), findsOneWidget);
    });

    testWidgets('Links', (WidgetTester tester) async {
      await tester.pumpWidget(portal());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Moodle'));
      verify(mockUrlLauncher.launch('http://acs.curs.pub.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);

      await tester.tap(find.text('OCW'));
      verify(mockUrlLauncher.launch('https://ocw.cs.pub.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);

      await tester.tap(find.text('LSAC'));
      verify(mockUrlLauncher.launch('https://lsacbucuresti.ro/',
              useSafariVC: anyNamed('useSafariVC'),
              useWebView: anyNamed('useWebView'),
              enableDomStorage: anyNamed('enableDomStorage'),
              enableJavaScript: anyNamed('enableJavaScript'),
              universalLinksOnly: anyNamed('universalLinksOnly'),
              headers: anyNamed('headers')))
          .called(1);
    });
  });
}
