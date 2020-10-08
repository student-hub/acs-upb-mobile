import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerProvider {
  static Future<dynamic> getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }
}
