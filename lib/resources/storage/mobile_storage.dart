import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
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

  static Future<bool> uploadImage(
      BuildContext context, Uint8List file, String ref) async {
    try {
      final StorageReference reference =
          FirebaseStorage.instance.ref().child(ref);

      final StorageUploadTask uploadTask = reference.putData(file);
      await uploadTask.onComplete;
      if (uploadTask.isSuccessful) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery,
        maxHeight: 500, maxWidth: 500);
    if(pickedFile == null){
      return null;
    }
    return pickedFile.readAsBytes();
  }
}
