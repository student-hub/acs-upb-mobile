import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({@required this.photoURL, Key key}) : super(key: key);

  final String photoURL;

  @override
  Widget build(BuildContext context) {
    print('photoURL: $photoURL}');
    return LayoutBuilder(
      builder: (context, constraints) {
        // TODO(TatucRobert): Make photo size fixed
        final radius = min(constraints.maxHeight / 3, constraints.maxWidth / 3);
        return Container(
          child: Center(
            child: photoURL != null
                ? CircleAvatar(
                    radius: radius,
                    backgroundImage: CachedNetworkImageProvider(photoURL),
                  )
                : const CircleAvatar(
                    child: Icon(
                      Icons.person_outlined,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
