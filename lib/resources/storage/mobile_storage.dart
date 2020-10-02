import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class  StorageProvider extends ChangeNotifier {
  StorageProvider._();

  StorageProvider();

  static Future<dynamic> findImageUrl(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
