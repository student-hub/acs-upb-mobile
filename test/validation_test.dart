import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget testLocalized(void Function(BuildContext context) body) =>
      Localizations(
        delegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          S.delegate
        ],
        locale: const Locale('en'),
        child: Builder(
          builder: (BuildContext context) {
            body(context);
            return Container();
          },
        ),
      );

  group('Password Validation', () {
    testWidgets('Valid password', (tester) async {
      await tester.pumpWidget(testLocalized((context) =>
          expect(AppValidator.isStrongPassword('Aa12345@', context), null)));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - length', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('Aa1@2', context),
          'The password must be 8 characters long or more.')));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - uppercase', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('bba12345@', context),
          'The password must include at least one uppercase letter.')));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - lowercase', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('AAA12345@', context),
          'The password must include at least one lowercase letter.')));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - number', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('AAAaaaaaa@', context),
          'The password must include at least one number.')));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - Japanese', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('こんにちはこんにちは', context), isNotNull)));
      await tester.pumpAndSettle();
    });

    testWidgets('Invalid password - special character', (tester) async {
      await tester.pumpWidget(testLocalized((context) => expect(
          AppValidator.isStrongPassword('AAAaaaaaa1', context),
          'The password must include at least one special character.')));
      await tester.pumpAndSettle();
    });
  });
}
