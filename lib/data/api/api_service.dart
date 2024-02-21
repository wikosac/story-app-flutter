import 'package:http/http.dart' as http;
import 'package:story_app/data/model/api_response.dart';
import 'package:story_app/data/model/user.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<ApiResponse> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: user.toJson(),
      );
      ApiResponse data = apiResponseFromJson(response.body);
      return data;
    } catch (e) {
      throw Exception('Gagal: $e');
    }
  }

// Future<List<dynamic>> getUsers();
}
