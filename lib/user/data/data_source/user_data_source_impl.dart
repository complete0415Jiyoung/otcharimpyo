import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final http.Client _client;
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  UserDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final response = await _client.get(Uri.parse('$_baseUrl/users/$userId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load user: ${response.statusCode}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/users'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load users: ${response.statusCode}');
    }

    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/users/$userId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
}
