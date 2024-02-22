import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/utils/response_state.dart';

class UserProvider extends ChangeNotifier {
  final ApiService apiService;

  UserProvider({required this.apiService});

  ResponseState? _state;

  ResponseState? get state => _state;

  void _setState(ResponseState value) {
    _state = value;
    notifyListeners();
  }

  Future<ApiResponse> registerUser(User user) async {
    try {
      _setState(ResponseState.loading);
      final response = await apiService.register(user);
      _setState(ResponseState.done);
      return response;
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Gagal mendaftarkan pengguna: $e');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      _setState(ResponseState.loading);
      final response = await apiService.login(email, password);
      _setState(ResponseState.done);
      return response;
    } catch (e) {
      _setState(ResponseState.error);
      throw Exception('Gagal login: $e');
    }
  }
}
