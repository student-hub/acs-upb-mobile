import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../generated/l10n.dart';

class UploadButtonController {
  UploadButtonController({this.onUpdate});

  _UploadButtonState _uploadButtonState;
  Uint8List newUploadedImageBytes;
  void Function() onUpdate;

  Uint8List get uploadImageBytes => newUploadedImageBytes;

  void setNewImg(Uint8List uploadedImageBytes) {
    if (_uploadButtonState == null) return;
    newUploadedImageBytes = uploadedImageBytes;
    onUpdate();
  }
}

// Returns a widget that behaves similarly to a textfield with a "clear"
// button, except it actually allows the user to select an image from the
// gallery instead of inputting text directly.
class UploadButton extends StatefulWidget {
  const UploadButton({Key key, this.pageType, this.controller})
      : super(key: key);

  final bool pageType;
  final UploadButtonController controller;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  Uint8List uploadedImageBytes;
  TextEditingController imageFieldController;

  @override
  void initState() {
    super.initState();
    uploadedImageBytes = null;
    imageFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?._uploadButtonState = this;
    // We need to override the tap behaviour of the text field to obtain the
    // behaviour we want.
    return PositionedTapDetector2(
      onTap: (tapPosition) async {
        final screenWidth = MediaQuery.of(context).size.width;
        const iconSize = 24, paddingSize = 16, iconPaddingSize = 12;
        if (screenWidth - tapPosition.global.dx <=
            iconSize + paddingSize + iconPaddingSize * 2) {
          // Tap is near the "clear" button
          imageFieldController.clear();
          setState(() {
            uploadedImageBytes = null;
            widget.controller.setNewImg(uploadedImageBytes);
          });
        } else {
          final filePickerResult = await FilePicker.platform.pickFiles(
              type: FileType.image, allowMultiple: false, withData: true);
          if (filePickerResult != null) {
            final uploadedImage = filePickerResult.files[0];
            setState(() {
              uploadedImageBytes = uploadedImage.bytes;
              imageFieldController.text = uploadedImage.name;
              widget.controller.setNewImg(uploadedImageBytes);
            });
          }
        }
      },
      child: Container(
        // Overriding the textfield gesture only works if we set the colour on
        // the container for some reason:
        // https://github.com/flutter/flutter/issues/15882#issuecomment-489900189
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextFormField(
            controller: imageFieldController,
            decoration: InputDecoration(
              labelText: widget.pageType
                  ? S.current.labelProfilePicture
                  : S.current.labelWebsiteIcon,
              prefixIcon: const Icon(Icons.add_photo_alternate_outlined),
              suffixIcon: imageFieldController.text.isNotEmpty
                  ? const Icon(Icons.clear)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
