// image_picker_helper.dart

export 'image_picker_stub.dart' 
  if (dart.library.io) 'image_picker_mobile.dart' 
  if (dart.library.html) 'image_picker_web.dart';

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class CustomPickedFile {
  final Uint8List? data;
  final String? path;
  final String? fileName;

  CustomPickedFile({this.data, this.path, this.fileName});
}

class ImagePickerHelper {
  static Future<CustomPickedFile?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }

    if (kIsWeb) {
      final Uint8List fileData = await pickedFile.readAsBytes();
      return CustomPickedFile(data: fileData, fileName: pickedFile.name);
    } else {
      return CustomPickedFile(path: pickedFile.path, fileName: pickedFile.name);
    }
  }
}