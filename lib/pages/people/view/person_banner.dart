import 'package:acs_upb_mobile/pages/people/view/person_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:acs_upb_mobile/widgets/icon_text.dart';

class PersonBanner extends StatelessWidget {
  const PersonBanner({
    @required this.name,
    @required this.photoURL,
    @required this.position,
    @required this.office,
    Key key,
  }) : super(key: key);

  final String name;
  final String photoURL;
  final String position;
  final String office;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
             PersonAvatar(
                photoURL: photoURL,
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      position,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 12),
                    IconText(
                        icon: FeatherIcons.mapPin,
                        text: office ?? '-',
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
