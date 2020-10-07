import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageProvider {
  static Future<String> findImageUrl(BuildContext context, String image) async {
    try {
      final String url =
          await FirebaseStorage.instance.ref().child(image).getDownloadURL();
      return url.toString();
    } catch (e) {
      return null;
    }
  }
}
