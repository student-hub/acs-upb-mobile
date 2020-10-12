import 'dart:typed_data';

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

  static Future<bool> uploadImage(
      BuildContext context, Uint8List file, String ref) async {
    try {
      final StorageReference storageReference = storage().ref('').child(ref);

      final UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(file).future;

      if (uploadTaskSnapshot.state == TaskState.SUCCESS) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
