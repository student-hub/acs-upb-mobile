import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockFilterProvider extends Mock implements FilterProvider {}

void main() {
  group('Model', () {
    Filter testFilter;

    setUpAll(() {
      testFilter = Filter(
        localizedLevelNames: [
          {'en': 'Degree', 'ro': 'Nivel de studiu'},
          {'en': 'Major', 'ro': 'Specializare'},
          {'en': 'Year', 'ro': 'An'},
          {'en': 'Series', 'ro': 'Serie'},
          {'en': 'Group', 'ro': 'Group'}
        ],
        root: FilterNode(
          name: 'All',
          value: true,
          children: [
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
                    value: true,
                    children: [
                      FilterNode(name: '311CD', value: true),
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
            FilterNode(
              name: 'MSc',
              children: [
                FilterNode(
                  name: 'IA',
                  children: [
                    FilterNode(name: 'IA-1'),
                    FilterNode(name: 'IA-2'),
                  ],
                ),
                FilterNode(name: 'SPRC'),
              ],
            )
          ],
        ),
      );
    });

    test('relevantNodes', () {
      expect(
          testFilter.relevantNodes..sort(),
          equals([
            '314CB',
            '311CD',
            '1-CB',
            '1-CD',
            'CTI-1',
            'CTI',
            'BSc',
            'All'
          ]..sort()));
    });

    test('setRelevant', () {
      // Leaf
      expect(testFilter.setRelevant('IA-1'), isTrue);

      expect(
          testFilter.relevantNodes..sort(),
          equals([
            '314CB',
            '311CD',
            '1-CB',
            '1-CD',
            'IA-1',
            'CTI-1',
            'CTI',
            'IA',
            'BSc',
            'MSc',
            'All'
          ]..sort()));

      // Root
      expect(testFilter.setRelevant('All'), isTrue);
      expect(
          testFilter.relevantNodes..sort(),
          equals([
            '314CB',
            '311CD',
            '1-CB',
            '1-CD',
            'IA-1',
            'CTI-1',
            'CTI',
            'IA',
            'BSc',
            'MSc',
            'All'
          ]..sort()));

      // Non-existent node
      expect(testFilter.setRelevant('Nope'), isFalse);
      expect(
          testFilter.relevantNodes..sort(),
          equals([
            '314CB',
            '311CD',
            '1-CB',
            '1-CD',
            'IA-1',
            'CTI-1',
            'CTI',
            'IA',
            'BSc',
            'MSc',
            'All'
          ]..sort()));
    });
  });
}
