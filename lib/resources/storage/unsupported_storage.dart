import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class StorageProvider extends ChangeNotifier {
  static Future<String> findImageUrl(final String image) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<bool> uploadImage(
      final Uint8List file, final String ref) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<dynamic> showImagePicker() async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<bool> deleteImage(final String imagePath) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }
}
