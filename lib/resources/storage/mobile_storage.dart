import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageProvider {
  static Future<dynamic> findImageUrl(
      BuildContext context, String image) async {
    final String url =
        await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    print('path:$image');
    return url;
  }
}
