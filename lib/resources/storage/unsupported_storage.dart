import 'package:flutter/cupertino.dart';

class StorageProvider extends ChangeNotifier {
  StorageProvider._();

  StorageProvider();

  static Future<dynamic> findImageUrl(BuildContext context, String image) async {
    // ignore: only_throw_errors
    throw 'Platform not found';
  }
}
