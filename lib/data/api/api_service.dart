import 'package:http/http.dart' as http;
import 'package:story_app/data/model/api_response.dart';
import 'package:story_app/data/model/login_response.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/model/user.dart';

export 'package:story_app/data/model/api_response.dart';
export 'package:story_app/data/model/login_response.dart';
export 'package:story_app/data/model/user.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<ApiResponse> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: user.toJson(),
      );
      final data = apiResponseFromJson(response.body);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {
          "email": email,
          "password": password
        },
      );
      return loginResponseFromJson(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<StoriesResponse> getAllStories(String token) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl/stories'),
        headers: {
          'Authorization': 'Bearer $token',
        }
      );
      return storiesResponseFromJson(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
