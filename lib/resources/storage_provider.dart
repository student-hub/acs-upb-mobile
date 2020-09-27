import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageProvider {
  static Future<ImageProvider<dynamic>> imageFromPath(String path) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(path);
    final String url = await ref.getDownloadURL();
    return CachedNetworkImageProvider(url);
  }
}
