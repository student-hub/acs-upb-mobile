import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';

class StorageProvider {
  static Future<String> findImageUrl(BuildContext context, String image) async {
    try {
      final url = await storage().ref(image).getDownloadURL();
      return url.toString();
    } catch (e) {
      return null;
    }
  }
}
