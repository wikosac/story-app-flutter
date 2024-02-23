import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/auth_preferences.dart';
import 'package:story_app/utils/response_state.dart';

class AuthProvider extends ChangeNotifier {
  AuthPreferences preferences;

  AuthProvider({required this.preferences}) {
    _getCredential();
  }

  late String _token;
  late String _name;
  late String _email;
  late ResponseState _state;

  String get token => _token;

  String get name => _name;

  String get email => _email;

  ResponseState get state => _state;

  void _setState(ResponseState value) {
    _state = value;
    notifyListeners();
  }

  void _getCredential() async {
    try {
      _setState(ResponseState.loading);
      _token = await preferences.token;
      _name = await preferences.name;
      _email = await preferences.email;
      _setState(ResponseState.done);
    } catch (e) {
      _setState(ResponseState.error);
      print('Credential error: $e');
    }
  }

  void setCredential(String token, String name, String email) {
    preferences.setCredential(token, name, email);
    _getCredential();
  }

  void deleteCredential() {
    preferences.deleteCredential();
    _getCredential();
  }
}
