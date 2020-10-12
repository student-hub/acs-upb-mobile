import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerProvider {

  static Future<dynamic> getImage() async {
    final Uint8List image =
        await  ImagePickerWeb.getImage(outputType: ImageType.bytes);
    return image;
  }
}
