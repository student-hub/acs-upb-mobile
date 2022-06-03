import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageProvider {
  static Future<String> findImageUrl(final String image) async {
    try {
      final String url =
          await FirebaseStorage.instance.ref().child(image).getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> uploadImage(
      final Uint8List file, final String ref) async {
    try {
      final Reference reference = FirebaseStorage.instance.ref().child(ref);
      bool result = false;
      final UploadTask uploadTask = reference.putData(file);
      await uploadTask
          .whenComplete(() => result = true)
          .catchError((final dynamic error) async {
        print('Storage - StorageUploadTask - uploadImage $error');
      });
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteImage(final String imagePath) async {
    try {
      final String url = await FirebaseStorage.instance
          .ref()
          .child(imagePath)
          .getDownloadURL();
      bool result = false;
      final UploadTask uploadTask =
          FirebaseStorage.instance.refFromURL(url).delete();
      await uploadTask
          .whenComplete(() => result = true)
          .catchError((final dynamic error) async {
        print('Storage - StorageUploadTask - deleteImageUrl $error');
      });
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> showImagePicker() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (pickedFile == null) {
      return null;
    }
    return pickedFile.readAsBytes();
  }
}