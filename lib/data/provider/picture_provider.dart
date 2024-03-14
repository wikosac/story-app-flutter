import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/utils/response_state.dart';

class PictureProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  ResponseState? state;
  String? location;
  LatLng? latLng;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setLocation(String? loc, LatLng? latLon) {
    location = loc;
    latLng = latLon;
    notifyListeners();
  }

  void setResponseState(ResponseState? value) {
    state = value;
    notifyListeners();
  }

  void onGalleryView() async {
    setResponseState(ResponseState.loading);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }
    setResponseState(ResponseState.done);
  }

  void onCameraView() async {
    setResponseState(ResponseState.loading);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }
    setResponseState(ResponseState.done);
  }

}
