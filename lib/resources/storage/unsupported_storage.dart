import 'package:flutter/cupertino.dart';

class StorageProvider extends ChangeNotifier {

  static Future<dynamic> findImageUrl(
      BuildContext context, String image) async {
    final Error error = ArgumentError('Platform not found!');
    throw error;
  }
}
