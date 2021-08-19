import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({@required this.photoURL, Key key}) : super(key: key);

  final String photoURL;

  @override
  Widget build(BuildContext context) {
    print('photoURL: $photoURL}');
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        child: Center(
          child: photoURL != null
              ? CircleAvatar(
                  radius: 100,
                  backgroundImage: CachedNetworkImageProvider(photoURL),
                )
              : const CircleAvatar(
                  child: Icon(
                    Icons.person_outlined,
                  ),
                ),
        ),
      ),
    );
  }
}
