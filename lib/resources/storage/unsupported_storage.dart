import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class StorageProvider extends ChangeNotifier {
  static Future<String> findImageUrl(String image) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<bool> uploadImage(Uint8List file, String ref) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<dynamic> showImagePicker() async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<bool> deleteImage(String imagePath) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }
}
