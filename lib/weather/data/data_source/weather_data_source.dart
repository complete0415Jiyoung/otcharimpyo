import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'weather_data_source_interface.dart';

const _baseUrl = 'https://api.openweathermap.org/data/2.5';

class WeatherDataSource implements WeatherDataSourceInterface {
  String get _apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    if (_apiKey.isEmpty) {
      throw Exception('API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
    }

    final uri = Uri.parse(
      '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=kr',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('날씨 정보를 가져오는데 실패했습니다 (${response.statusCode})');
    }
  }
}
