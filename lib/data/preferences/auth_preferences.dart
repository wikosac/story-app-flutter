import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  final Future<SharedPreferences> sharedPreferences;

  AuthPreferences({required this.sharedPreferences});

  static const tokenKey = 'TOKEN_KEY';
  static const nameKey = 'NAME_KEY';
  static const emailKey = 'EMAIL_KEY';

  Future<String> get token async {
    final pref = await sharedPreferences;
    return pref.getString(tokenKey) ?? '';
  }

  Future<String> get name async {
    final pref = await sharedPreferences;
    return pref.getString(nameKey) ?? '';
  }

  Future<String> get email async {
    final pref = await sharedPreferences;
    return pref.getString(emailKey) ?? '';
  }

  void setCredential(String token, String name, String email) async {
    final pref = await sharedPreferences;
    pref
      ..setString(tokenKey, token)
      ..setString(nameKey, name)
      ..setString(emailKey, email);
  }

  void deleteCredential() async {
    final pref = await sharedPreferences;
    pref
      ..remove(tokenKey)
      ..remove(nameKey)
      ..remove(emailKey);
  }
}
