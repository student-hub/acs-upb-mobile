import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';

class StorageProvider {
  static Future<dynamic> findImageUrl(
      BuildContext context, String image) async {
    final url = await storage().ref(image).getDownloadURL();
    return url;
  }
}
