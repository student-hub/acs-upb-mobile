import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({@required this.photoURL, @required this.size, Key key})
      : super(key: key);

  final String photoURL;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: photoURL != null
          ? CircleAvatar(
              radius: size,
              backgroundImage: CachedNetworkImageProvider(photoURL),
            )
          : CircleAvatar(
              radius: size,
              child: const Icon(
                Icons.person_outlined,
              ),
            ),
    );
  }
}
