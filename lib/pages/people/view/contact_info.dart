import 'package:acs_upb_mobile/widgets/titled_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    @required this.email,
    @required this.phone,
    Key key,
  }) : super(key: key);

  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: S.current.labelContactInfo,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconText(
            icon: FeatherIcons.mail,
            text: email ?? '-',
            style: Theme.of(context).textTheme.bodyText1,
            onTap: () {
              return (email != null && email.isNotEmpty)
                  ? Utils.launchURL('mailto:$email')
                  : null;
            },
          ),
          const SizedBox(height: 10),
          IconText(
            icon: FeatherIcons.phone,
            text: phone ?? '-',
            style: Theme.of(context).textTheme.bodyText1,
            onTap: () {
              return (phone != null && phone.isNotEmpty)
                  ? Utils.launchURL('tel:$phone')
                  : null;
            },
          ),
        ],
      ),
    );
  }
}
