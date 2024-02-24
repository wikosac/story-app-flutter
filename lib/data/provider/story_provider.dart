import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/utils/response_state.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryProvider({required this.apiService});

  List<Story>? _listStory;
  Story? _story;
  ResponseState? _state;

  List<Story>? get listStory => _listStory;

  Story? get story => _story;

  ResponseState? get state => _state;

  void _setState(ResponseState value) {
    _state = value;
    notifyListeners();
  }

  Future<StoriesResponse> getAllStories(String token) async {
    try {
      _setState(ResponseState.loading);
      final response = await apiService.getAllStories(token);
      if (response.error == false) _listStory = response.listStory!;
      _setState(ResponseState.done);
      return response;
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Failed fetch data: $e');
    }
  }

  Future<DetailResponse> getDetailStory(String token, String id) async {
    try {
      _setState(ResponseState.loading);
      final response = await apiService.getDetailStory(token, id);
      print('detail response: ${response.message}');
      if (response.error == false) _story = response.story!;
      _setState(ResponseState.done);
      return response;
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Failed fetch data: $e');
    }
  }

}
