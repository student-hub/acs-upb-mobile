import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  static Future<ImageProvider<dynamic>> getImageFromPath(String path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String url = await ref.getDownloadURL();
    return NetworkImage(url);
  }
}