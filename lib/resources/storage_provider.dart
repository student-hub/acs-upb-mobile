import 'package:acs_upb_mobile/resources/storage/fire_storage_service.dart';
import 'package:flutter/material.dart';

class StorageProvider with ChangeNotifier {
  Future<String> findIconUrl(BuildContext context, String iconPath) async {
    String url;
    await FireStorageService.loadImage(context, iconPath).then((downloadUrl){
      url = downloadUrl.toString();
    });
    return url;
  }
}