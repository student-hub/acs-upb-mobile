import 'dart:typed_data';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class UploadButtonController {
  _UploadButtonState _uploadButtonState;

  bool get isSelected => _uploadButtonState?._isSelected;

  void select(ImageProvider img) {
    if (_uploadButtonState == null) return;
    if (!isSelected) _uploadButtonState.isSelected = true;
  }

  void deselect(ImageProvider img) {
    if (_uploadButtonState == null) return;
    if (isSelected) _uploadButtonState.isSelected = false;
  }
}

// Returns a widget that behaves similarly to a textfield with a "clear"
// button, except it actually allows the user to select an image from the
// gallery instead of inputting text directly.
class UploadButton extends StatefulWidget {
  const UploadButton({Key key, this.imageFieldController, this.image, this.controller})
      : super(key: key);

  final TextEditingController imageFieldController;
  final ImageProvider image;
  final UploadButtonController controller;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool _isSelected;
  Future<dynamic> future;

  Uint8List uploadedImageBytes;
  ImageProvider imageWidget;

  set isSelected(bool newValue) {
    _isSelected = newValue;
    setState(() {});
  }

  bool get isSelected => _isSelected;
  ImageProvider get image => imageWidget ?? widget.image;

  @override
  void initState() {
    super.initState();
    future = Future(() => null);

  }

  @override
  Widget build(BuildContext context) {
    widget.controller?._uploadButtonState = this;
    // We need to override the tap behaviour of the text field to obtain the
    // behaviour we want.
    return PositionedTapDetector(
      onTap: (tapPosition) async {
        final screenWidth = MediaQuery.of(context).size.width;
        const iconSize = 24, paddingSize = 16, iconPaddingSize = 12;
        if (screenWidth - tapPosition.global.dx <=
            iconSize + paddingSize + iconPaddingSize * 2) {
          // Tap is near the "clear" button
          widget.imageFieldController.clear();
          setState(() {
            imageWidget = const AssetImage('assets/icons/globe.png');
            widget.controller.deselect(imageWidget);
          });
        } else {
          final filePickerResult = await FilePicker.platform.pickFiles(
              type: FileType.image, allowMultiple: false, withData: true);
          if (filePickerResult != null) {
            final uploadedImage = filePickerResult.files[0];
            setState(() {
              uploadedImageBytes = uploadedImage.bytes;
              imageWidget = MemoryImage(uploadedImageBytes);
              widget.imageFieldController.text = uploadedImage.name;
              widget.controller.select(imageWidget);
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
            controller: widget.imageFieldController,
            decoration: InputDecoration(
              labelText: S.current.labelWebsiteIcon,
              prefixIcon: const Icon(Icons.add_photo_alternate_outlined),
              suffixIcon: widget.imageFieldController.text.isNotEmpty
                  ? const Icon(Icons.clear)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}