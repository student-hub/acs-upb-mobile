import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/class_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/classes/view/grading_view.dart';
import 'package:acs_upb_mobile/pages/classes/view/shortcut_view.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_provider.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/model/news_feed_item.dart';
import 'package:acs_upb_mobile/pages/news_feed/service/news_provider.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/website_view.dart';
import 'package:acs_upb_mobile/pages/settings/service/request_provider.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'test_utils.dart';

// These tests open each page in the app on multiple screen sizes to make sure
// nothing overflows/breaks.

class MockAuthProvider extends Mock implements AuthProvider {}

class MockWebsiteProvider extends Mock implements WebsiteProvider {}

class MockFilterProvider extends Mock implements FilterProvider {}

class MockClassProvider extends Mock implements ClassProvider {}

class MockPersonProvider extends Mock implements PersonProvider {}

class MockQuestionProvider extends Mock implements QuestionProvider {}

class MockUniEventProvider extends Mock implements UniEventProvider {}

class MockNewsProvider extends Mock implements NewsProvider {}

class MockRequestProvider extends Mock implements RequestProvider {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  AuthProvider mockAuthProvider;
  WebsiteProvider mockWebsiteProvider;
  FilterProvider mockFilterProvider;
  ClassProvider mockClassProvider;
  PersonProvider mockPersonProvider;
  MockQuestionProvider mockQuestionProvider;
  MockNewsProvider mockNewsProvider;
  UniEventProvider mockEventProvider;
  RequestProvider mockRequestProvider;

  // Test layout for different screen sizes
  final screenSizes = <Size>[
    // Phone
    const Size(1080, 1920), const Size(720, 1280), // Standard
    const Size(2200, 2480), const Size(1536, 2151), // Foldable
    /* For some reason, Q/WVGA sizes give weird overflow errors that I can't
    replicate in the emulator with the same size, so I'll leave these commented
    for now:
    Size(480, 800), Size(480, 854), // WVGA
    Size(240, 432), Size(240, 400), Size(320, 480), Size(240, 320), // QVGA
   */
    // Tablet
    const Size(1800, 2560), const Size(1536, 2048), const Size(1200, 1920),
    const Size(1600, 2560), const Size(600, 1024), const Size(800, 1280),
  ];

  // Add landscape mode sizes
  screenSizes.addAll(List<Size>.from(screenSizes)
      .map((size) => Size(size.height, size.width)));

  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => mockAuthProvider),
          ChangeNotifierProvider<WebsiteProvider>(
              create: (_) => mockWebsiteProvider),
          ChangeNotifierProvider<FilterProvider>(
              create: (_) => mockFilterProvider),
          ChangeNotifierProvider<ClassProvider>(
              create: (_) => mockClassProvider),
          ChangeNotifierProvider<PersonProvider>(
              create: (_) => mockPersonProvider),
          ChangeNotifierProvider<QuestionProvider>(
              create: (_) => mockQuestionProvider),
          ChangeNotifierProvider<NewsProvider>(create: (_) => mockNewsProvider),
          ChangeNotifierProvider<UniEventProvider>(
              create: (_) => mockEventProvider),
          Provider<RequestProvider>(create: (_) => mockRequestProvider),
        ],
        child: const MyApp(),
      );

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PrefService.enableCaching();
    PrefService.cache = {};
    PrefService.setString('language', 'en');

    LocaleProvider.cultures = testCultures;
    LocaleProvider.rruleL10ns = {'en': await RruleL10nTest.create()};

    // Pretend an anonymous user is already logged in
    mockAuthProvider = MockAuthProvider();
    when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
    // ignore: invalid_use_of_protected_member
    when(mockAuthProvider.hasListeners).thenReturn(false);
    when(mockAuthProvider.isAnonymous).thenReturn(true);
    when(mockAuthProvider.isAuthenticatedFromService)
        .thenAnswer((_) => Future.value(true));
    when(mockAuthProvider.currentUser)
        .thenAnswer((realInvocation) => Future.value(null));

    mockWebsiteProvider = MockWebsiteProvider();
    // ignore: invalid_use_of_protected_member
    when(mockWebsiteProvider.hasListeners).thenReturn(false);
    when(mockWebsiteProvider.deleteWebsite(any, context: anyNamed('context')))
        .thenAnswer((realInvocation) => Future.value(true));
    when(mockWebsiteProvider.fetchWebsites(any))
        .thenAnswer((_) => Future.value([
              Website(
                id: '1',
                relevance: null,
                category: WebsiteCategory.learning,
                infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
                label: 'Moodle1',
                link: 'http://acs.curs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '2',
                relevance: null,
                category: WebsiteCategory.learning,
                infoByLocale: {},
                label: 'OCW1',
                link: 'https://ocw.cs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '3',
                relevance: null,
                category: WebsiteCategory.learning,
                infoByLocale: {'en': 'info-en', 'ro': 'info-ro'},
                label: 'Moodle2',
                link: 'http://acs.curs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '4',
                relevance: null,
                category: WebsiteCategory.learning,
                infoByLocale: {},
                label: 'OCW2',
                link: 'https://ocw.cs.pub.ro/',
                isPrivate: false,
              ),
              Website(
                id: '5',
                relevance: null,
                category: WebsiteCategory.association,
                infoByLocale: {},
                label: 'LSAC1',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '6',
                relevance: null,
                category: WebsiteCategory.administrative,
                infoByLocale: {},
                label: 'LSAC2',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '7',
                relevance: null,
                category: WebsiteCategory.resource,
                infoByLocale: {},
                label: 'LSAC3',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
              Website(
                id: '8',
                relevance: null,
                category: WebsiteCategory.other,
                infoByLocale: {},
                label: 'LSAC4',
                link: 'https://lsacbucuresti.ro/',
                isPrivate: false,
              ),
            ]));
    when(mockWebsiteProvider.fetchFavouriteWebsites()).thenAnswer(
        (_) async => (await mockWebsiteProvider.fetchWebsites(any)).take(3));

    mockFilterProvider = MockFilterProvider();
    // ignore: invalid_use_of_protected_member
    when(mockFilterProvider.hasListeners).thenReturn(false);
    when(mockFilterProvider.filterEnabled).thenReturn(true);
    when(mockFilterProvider.fetchFilter(context: anyNamed('context')))
        .thenAnswer((_) => Future.value(Filter(
                localizedLevelNames: [
                  {'en': 'Degree', 'ro': 'Nivel de studiu'},
                  {'en': 'Major', 'ro': 'Specializare'},
                  {'en': 'Year', 'ro': 'An'},
                  {'en': 'Series', 'ro': 'Serie'},
                  {'en': 'Group', 'ro': 'Group'}
                ],
                root: FilterNode(name: 'All', value: true, children: [
                  FilterNode(name: 'BSc', value: true, children: [
                    FilterNode(name: 'CTI', value: true, children: [
                      FilterNode(name: 'CTI-1', value: true, children: [
                        FilterNode(name: '1-CA'),
                        FilterNode(
                          name: '1-CB',
                          value: true,
                          children: [
                            FilterNode(name: '311CB'),
                            FilterNode(name: '312CB'),
                            FilterNode(name: '313CB'),
                            FilterNode(
                              name: '314CB',
                              value: true,
                            ),
                          ],
                        ),
                        FilterNode(name: '1-CC'),
                        FilterNode(
                          name: '1-CD',
                          children: [
                            FilterNode(name: '311CD'),
                            FilterNode(name: '312CD'),
                            FilterNode(name: '313CD'),
                            FilterNode(name: '314CD'),
                          ],
                        ),
                      ]),
                      FilterNode(
                        name: 'CTI-2',
                      ),
                      FilterNode(
                        name: 'CTI-3',
                      ),
                      FilterNode(
                        name: 'CTI-4',
                      ),
                    ]),
                    FilterNode(name: 'IS')
                  ]),
                  FilterNode(name: 'MSc', children: [
                    FilterNode(
                      name: 'IA',
                    ),
                    FilterNode(name: 'SPRC'),
                  ])
                ]))));

    mockClassProvider = MockClassProvider();
    // ignore: invalid_use_of_protected_member
    when(mockClassProvider.hasListeners).thenReturn(false);
    when(mockClassProvider.fetchClassHeaders(uid: anyNamed('uid')))
        .thenAnswer((_) => Future.value([
              ClassHeader(
                id: '1',
                name: 'Maths 1',
                acronym: 'M1',
                category: 'A/B',
              ),
              ClassHeader(
                id: '2',
                name: 'Maths 2',
                acronym: 'M2',
                category: 'A/C',
              ),
              ClassHeader(
                id: '3',
                name: 'Programming',
                acronym: 'PC',
                category: 'A',
              ),
              ClassHeader(
                id: '4',
                name: 'Physics',
                acronym: 'PH',
                category: 'D',
              ),
            ]));
    when(mockClassProvider.fetchUserClassIds(
            uid: anyNamed('uid'), context: anyNamed('context')))
        .thenAnswer((_) => Future.value(['3']));
    when(mockClassProvider.fetchClassInfo(any, context: anyNamed('context')))
        .thenAnswer((_) => Future.value(
              Class(
                header: ClassHeader(
                  id: '3',
                  name: 'Programming',
                  acronym: 'PC',
                  category: 'A',
                ),
                shortcuts: [
                  Shortcut(
                      type: ShortcutType.main,
                      name: 'OCW',
                      link: 'https://ocw.cs.pub.ro/courses/programare'),
                  Shortcut(
                      type: ShortcutType.other,
                      name: 'Google',
                      link: 'https://google.com'),
                ],
                grading: {
                  'Exam': 4,
                  'Lab': 1.5,
                  'Homework': 4,
                  'Extra homework': 0.5,
                },
              ),
            ));

    mockPersonProvider = MockPersonProvider();
    // ignore: invalid_use_of_protected_member
    when(mockPersonProvider.hasListeners).thenReturn(false);
    when(mockPersonProvider.fetchPeople(context: anyNamed('context')))
        .thenAnswer((_) => Future.value([
              Person(
                name: 'John Doe',
                email: 'john.doe@cs.pub.ro',
                phone: '0712345678',
                office: 'AB123',
                position: 'Associate Professor, Dr., Department Council',
                photo: 'https://cdn.worldvectorlogo.com/logos/flutter-logo.svg',
              ),
              Person(
                name: 'Jane Doe',
                email: 'jane.doe@cs.pub.ro',
                phone: '-',
                office: 'Narnia',
                position: 'Professor, Dr.',
                photo: 'https://cdn.worldvectorlogo.com/logos/flutter-logo.svg',
              ),
              Person(
                name: 'Mary Poppins',
                email: 'supercalifragilistic.expialidocious@cs.pub.ro',
                phone: '0712-345-678',
                office: 'Mary Poppins\' office',
                position: 'Professor, Dr., Head of Department',
                photo: 'https://cdn.worldvectorlogo.com/logos/flutter-logo.svg',
              ),
            ]));

    mockQuestionProvider = MockQuestionProvider();
    // ignore: invalid_use_of_protected_member
    when(mockQuestionProvider.hasListeners).thenReturn(false);
    when(mockQuestionProvider.fetchQuestions(context: anyNamed('context')))
        .thenAnswer((realInvocation) => Future.value(<Question>[
              Question(
                  question: 'Care este programul la secretariat?',
                  answer:
                      'Secretariatul este deschis în timpul săptămânii între orele 9:00 si 11:00.',
                  tags: ['Licență']),
              Question(
                  question: 'Cum mă conectez la eduroam?',
                  answer:
                      'Conectarea în rețeaua *eduroam* se face pe baza aceluiași cont folosit și pe site-ul de cursuri.',
                  tags: ['Conectare', 'Informații'])
            ]));
    when(mockQuestionProvider.fetchQuestions(limit: anyNamed('limit')))
        .thenAnswer((realInvocation) => Future.value(<Question>[
              Question(
                  question: 'Care este programul la secretariat?',
                  answer:
                      'Secretariatul este deschis în timpul săptămânii între orele 9:00 si 11:00.',
                  tags: ['Licență']),
              Question(
                  question: 'Cum mă conectez la eduroam?',
                  answer:
                      'Conectarea în rețeaua *eduroam* se face pe baza aceluiași cont folosit și pe site-ul de cursuri.',
                  tags: ['Conectare', 'Informații'])
            ]));

    mockNewsProvider = MockNewsProvider();
    // ignore: invalid_use_of_protected_member
    when(mockNewsProvider.hasListeners).thenReturn(false);
    when(mockNewsProvider.fetchNewsFeedItems(context: anyNamed('context')))
        .thenAnswer((realInvocation) => Future.value(<NewsFeedItem>[
              NewsFeedItem(
                  '03.10.2020',
                  'Cazarea studentilor de anul II licenta',
                  'https://acs.pub.ro/noutati/cazarea-studentilor-de-anul-ii-licenta/'),
              NewsFeedItem(
                  '03.10.2020',
                  'Festivitatea de deschidere a anului universitar 2020-2021',
                  'https://acs.pub.ro/noutati/festivitatea-de-deschidere-a-anului-universitar-2020-2021/')
            ]));
    when(mockNewsProvider.fetchNewsFeedItems(limit: anyNamed('limit')))
        .thenAnswer((realInvocation) => Future.value(<NewsFeedItem>[
              NewsFeedItem(
                  '03.10.2020',
                  'Cazarea studentilor de anul II licenta',
                  'https://acs.pub.ro/noutati/cazarea-studentilor-de-anul-ii-licenta/'),
              NewsFeedItem(
                  '03.10.2020',
                  'Festivitatea de deschidere a anului universitar 2020-2021',
                  'https://acs.pub.ro/noutati/festivitatea-de-deschidere-a-anului-universitar-2020-2021/')
            ]));

    mockEventProvider = MockUniEventProvider();
    // ignore: invalid_use_of_protected_member
    when(mockEventProvider.hasListeners).thenReturn(false);
    when(mockEventProvider.getAllDayEventsIntersecting(any))
        .thenAnswer((_) => Stream.fromIterable([]));
    when(mockEventProvider.empty).thenReturn(true);

    mockRequestProvider = MockRequestProvider();
    when(mockRequestProvider.makeRequest(any, context: anyNamed('context')))
        .thenAnswer((_) => Future.value(true));
    when(mockRequestProvider.userAlreadyRequested(any,
            context: anyNamed('context')))
        .thenAnswer((_) => Future.value(false));
  });

  group('Home', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);

        // Open home
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
      });
    }
  });

  group('Class', () {
    setUp(() {
      when(mockAuthProvider.currentUser).thenAnswer((_) =>
          Future.value(User(uid: '0', firstName: 'John', lastName: 'Doe')));
      when(mockAuthProvider.currentUserFromCache)
          .thenReturn(User(uid: '0', firstName: 'John', lastName: 'Doe'));
      when(mockAuthProvider.isAuthenticatedFromService)
          .thenAnswer((_) => Future.value(true));
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.uid).thenReturn('0');
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open timetable
        await tester.tap(find.byIcon(Icons.calendar_today_rounded));
        await tester.pumpAndSettle();

        // Close "No events to show" dialog
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        // Open classes
        await tester.tap(find.byIcon(Icons.class_));
        await tester.pumpAndSettle();

        // Open class view
        expect(find.byType(ClassesPage), findsOneWidget);
      });
    }
  });

  group('Add class', () {
    setUp(() {
      when(mockAuthProvider.currentUser).thenAnswer((_) =>
          Future.value(User(uid: '0', firstName: 'John', lastName: 'Doe')));
      when(mockAuthProvider.currentUserFromCache)
          .thenReturn(User(uid: '0', firstName: 'John', lastName: 'Doe'));
      when(mockAuthProvider.isAuthenticatedFromService)
          .thenAnswer((_) => Future.value(true));
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.uid).thenReturn('0');
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open timetable
        await tester.tap(find.byIcon(Icons.calendar_today_rounded));
        await tester.pumpAndSettle();

        // Close "No events to show" dialog
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        // Open classes
        await tester.tap(find.byIcon(Icons.class_));
        await tester.pumpAndSettle();

        // Open add class view
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(AddClassesPage), findsOneWidget);

        // Save
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(find.byType(ClassesPage), findsOneWidget);
      });
    }
  });

  group('Class view', () {
    setUp(() {
      when(mockAuthProvider.currentUser).thenAnswer((_) => Future.value(User(
          uid: '0', firstName: 'John', lastName: 'Doe', permissionLevel: 3)));
      when(mockAuthProvider.currentUserFromCache).thenReturn(User(
          uid: '0', firstName: 'John', lastName: 'Doe', permissionLevel: 3));
      when(mockAuthProvider.isAuthenticatedFromService)
          .thenAnswer((_) => Future.value(true));
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.uid).thenReturn('0');
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open timetable
        await tester.tap(find.byIcon(Icons.calendar_today_rounded));
        await tester.pumpAndSettle();

        // Close "No events to show" dialog
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        // Open classes
        await tester.tap(find.byIcon(Icons.class_));
        await tester.pumpAndSettle();

        // Open class view
        await tester.tap(find.text('PC'));
        await tester.pumpAndSettle();

        expect(find.byType(ClassView), findsOneWidget);

        // Open add shortcut view
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(ShortcutView), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.byType(ClassView), findsOneWidget);

        // Open grading view
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(GradingView), findsOneWidget);

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(find.byType(ClassView), findsOneWidget);
      });
    }
  });

  group('Settings', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open settings
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsPage), findsOneWidget);
      });
    }
  });

  group('Portal', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open portal
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        expect(find.byType(PortalPage), findsOneWidget);
      });
    }
  });

  group('Filter', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open filter popup menu
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(CustomIcons.filter));
        await tester.pumpAndSettle();

        // Open filter on portal page
        await tester.tap(find.text('Filter by relevance'));
        await tester.pumpAndSettle();

        expect(find.byType(FilterPage), findsOneWidget);
      });
    }
  });

  group('Add website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Open add website page
        final addWebsiteButton =
            find.byKey(const ValueKey('add_website_associations'));
        await tester.ensureVisible(addWebsiteButton);
        await tester.pumpAndSettle();

        await tester.tap(addWebsiteButton);
        await tester.pumpAndSettle();

        expect(find.byType(WebsiteView), findsOneWidget);
      });
    }
  });

  group('Edit website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.currentUser).thenAnswer((realInvocation) =>
          Future.value(User(
              uid: '1',
              firstName: 'John',
              lastName: 'Doe',
              permissionLevel: 3)));
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Enable editing
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Open edit website page
        await tester.ensureVisible(find.text('LSAC1'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('LSAC1'));
        await tester.pumpAndSettle();

        expect(find.byType(WebsiteView), findsOneWidget);
      });
    }
  });

  group('Delete website', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.currentUser).thenAnswer((realInvocation) =>
          Future.value(User(
              uid: '1',
              firstName: 'John',
              lastName: 'Doe',
              permissionLevel: 3)));
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open portal page
        await tester.tap(find.byIcon(Icons.public));
        await tester.pumpAndSettle();

        // Enable editing
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Open edit website page
        await tester.ensureVisible(find.text('LSAC1'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('LSAC1'));
        await tester.pumpAndSettle();

        // Open delete dialog
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete website'));
        await tester.pumpAndSettle();

        // Cancel
        expect(find.text('Are you sure you want to delete this website?'),
            findsOneWidget);
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();

        // Open delete dialog
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete website'));
        await tester.pumpAndSettle();

        // Confirm deletion
        expect(find.text('Are you sure you want to delete this website?'),
            findsOneWidget);
        await tester.tap(find.text('DELETE WEBSITE'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        verify(mockWebsiteProvider.deleteWebsite(any,
            context: anyNamed('context')));
        expect(find.byType(PortalPage), findsOneWidget);
      });
    }
  });

  group('Edit Profile', () {
    setUp(() {
      when(mockAuthProvider.isVerifiedFromCache).thenReturn(false);
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(false);
      when(mockAuthProvider.currentUser).thenAnswer((realInvocation) =>
          Future.value(User(
              uid: '1',
              firstName: 'John',
              lastName: 'Doe',
              permissionLevel: 3)));
      when(mockAuthProvider.currentUserFromCache).thenReturn(User(
          uid: '1', firstName: 'John', lastName: 'Doe', permissionLevel: 3));
      when(mockAuthProvider.email).thenReturn('john.doe@stud.acs.upb.ro');
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open Edit Profile page
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
      });

      testWidgets('${size.width}x${size.height}, delete account',
          (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open Edit Profile page
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        //Open delete account popup
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete account'));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('delete_account_button')),
            findsOneWidget);
      });

      testWidgets('${size.width}x${size.height}, change password',
          (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open Edit Profile page
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        //Open change password popup
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Change password'));
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('change_password_button')),
            findsOneWidget);
      });

      testWidgets('${size.width}x${size.height}, change email',
          (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open Edit Profile page
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Edit the email
        await tester.enterText(
            find.text('john.doe'), 'johndoe@stud.acs.upb.ro');

        //Open change email popup
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
            find.byKey(const ValueKey('change_email_button')), findsOneWidget);
      });
    }
  });

  group('People page', () {
    setUp(() {
      when(mockAuthProvider.isAuthenticatedFromCache).thenReturn(true);
      when(mockAuthProvider.isAnonymous).thenReturn(true);
    });

    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(buildApp());
          await tester.pumpAndSettle();

          // Open people page
          await tester.tap(find.byIcon(Icons.people));
          await tester.pumpAndSettle();

          expect(find.byType(PeoplePage), findsOneWidget);

          // Open bottom sheet with person info
          final names = ['John Doe', 'Jane Doe', 'Mary Poppins'];
          for (final name in names) {
            await tester.tap(find.text(name));
            await tester.pumpAndSettle();
          }

          expect(find.byType(PersonView), findsOneWidget);
        });
      });
    }
  });

  group('Show faq page', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final showMoreFaq =
            find.byKey(const ValueKey('show_more_faq'), skipOffstage: false);

        // Ensure FAQ card is visible
        await tester.ensureVisible(showMoreFaq);
        await tester.pumpAndSettle();

        // Open faq page
        await tester.tap(showMoreFaq);
        await tester.pumpAndSettle();

        expect(find.byType(FaqPage), findsOneWidget);

        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);

        final cancelSearchBar = find.byKey(const ValueKey('cancel_search_bar'));

        await tester.tap(cancelSearchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsNothing);
      });
    }
  });

  group('Show news feed page', () {
    for (final size in screenSizes) {
      testWidgets('${size.width}x${size.height}', (WidgetTester tester) async {
        await binding.setSurfaceSize(size);

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // Open news feed page
        final showMoreNewsFeed =
            find.byKey(const ValueKey('show_more_news_feed'));

        await tester.tap(showMoreNewsFeed);
        await tester.pumpAndSettle();

        expect(find.byType(NewsFeedPage), findsOneWidget);
      });
    }
  });
}
