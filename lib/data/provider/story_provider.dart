import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/preferences/auth_preferences.dart';
import 'package:story_app/utils/response_state.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences preferences;

  StoryProvider({required this.apiService, required this.preferences}) {
    getAllStories();
  }

  final ScrollController scrollController = ScrollController();

  List<Story> allStory = [];
  List<Story>? _listStory;
  Story? _story;
  ResponseState? _state;
  int? pageItems = 1;
  int sizeItems = 10;

  List<Story>? get listStory => _listStory;

  Story? get story => _story;

  ResponseState? get state => _state;

  void _setState(ResponseState value) {
    _state = value;
    notifyListeners();
  }

  Future<ApiResponse> addStory({
    required String token,
    required String desc,
    required String fileName,
    required List<int> bytes,
    double? lat,
    double? lon,
  }) async {
    try {
      _setState(ResponseState.loading);
      final fileBytes = await compressImage(bytes);
      final response = await apiService.addStory(
        token,
        desc,
        fileName,
        fileBytes,
        lat,
        lon,
      );
      _setState(ResponseState.done);
      return response;
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Failed upload: $e');
    }
  }

  Future<void> getAllStories() async {
    try {
      if (pageItems == 1) {
        _setState(ResponseState.loading);
      }
      final token = await preferences.token;
      final response = await apiService.getPagedStories(token, pageItems!, sizeItems);
      if (response.error == false) {
        List<Story> data = response.listStory!;
        allStory.addAll(data);
        if (data.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
      }
      final allResponse = await apiService.getAllStories(token);
      if (allResponse.error == false) {
        _listStory = allResponse.listStory;
      }
      notifyListeners();
      _setState(ResponseState.done);
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Failed fetch data: $e');
    }
  }

  Future refresh() async {
    pageItems = 1;
    allStory = [];
    await getAllStories();
    notifyListeners();
  }

  Future<void> getDetailStory(String id) async {
    try {
      _setState(ResponseState.loading);
      final token = await preferences.token;
      final response = await apiService.getDetailStory(token, id);
      if (response.error == false) _story = response.story!;
      _setState(ResponseState.done);
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Failed fetch data: $e');
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    Uint8List uint8List = Uint8List.fromList(bytes);

    final img.Image image = img.decodeImage(uint8List)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }
}
