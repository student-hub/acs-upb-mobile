import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';

class  StorageProvider extends ChangeNotifier {
  StorageProvider() {
    initializeApp(
        apiKey: 'AIzaSyC6-BEfdxQHSOTdpOfqLUB8_j7CGu4DvV0',
        authDomain: 'acs-upb-mobile.firebaseapp.com',
        databaseURL: 'https://acs-upb-mobile.firebaseio.com',
        projectId: 'acs-upb-mobile',
        storageBucket: 'acs-upb-mobile.appspot.com',
        messagingSenderId: '611150208061',
        appId: '1:611150208061:web:b62a7862a75930f48a1e54',
        measurementId: 'G-S7BTKYBV5T');
  }

  static Future<dynamic> findImageUrl(BuildContext context, String image) async {
    final url = await storage().ref(image).getDownloadURL();
    return url;
  }
}
