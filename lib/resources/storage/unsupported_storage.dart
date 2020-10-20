import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class StorageProvider extends ChangeNotifier {
  static Future<String> findImageUrl(BuildContext context, String image) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<bool> uploadImage(
      BuildContext context, Uint8List file, String ref) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }

  static Future<dynamic> getImage() async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }
}
