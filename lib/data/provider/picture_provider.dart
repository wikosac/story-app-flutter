import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:image/image.dart' as img;

class PictureProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  ResponseState? state;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setState(ResponseState? value) {
    state = value;
    notifyListeners();
  }

  void onGalleryView() async {
    setState(ResponseState.loading);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }
    setState(ResponseState.done);
  }

  void onCameraView() async {
    setState(ResponseState.loading);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }
    setState(ResponseState.done);
  }

}
