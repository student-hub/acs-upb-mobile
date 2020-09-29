import 'package:flutter/cupertino.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService._();

  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    throw ("Platform not found");
  }
}
