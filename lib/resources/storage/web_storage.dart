/*
import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:image_picker_web/image_picker_web.dart';

class StorageProvider {
  static Future<String> findImageUrl(final String image) async {
    try {
      final url = await storage().ref(image).getDownloadURL();
      return url.toString();
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteImage(final String imagePath) async {
    try {
      final url = await storage().ref(imagePath).getDownloadURL();
      bool result = false;
      final Future<dynamic> uploadTask =
          storage().refFromURL(url.toString()).delete();
      await uploadTask.whenComplete(() => result = true).catchError(
          (final dynamic error) async =>
              print('Web_Storage - StorageUploadTask - deleteImageUrl $error'));
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> uploadImage(
      final Uint8List file, final String ref) async {
    try {
      final StorageReference storageReference = storage().ref('').child(ref);

      bool result;
      await storageReference
          .put(file)
          .future
          .whenComplete(() => result = true)
          .catchError((final dynamic error) async {
        print('Web_Storage - StorageUploadTask - uploadImage $error');
      });
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> showImagePicker() async {
    final Uint8List image =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    return image;
  }
}
*/
