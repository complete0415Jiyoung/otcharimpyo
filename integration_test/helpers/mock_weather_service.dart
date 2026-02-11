/// 날씨 API Mock 서비스
/// 통합 테스트에서 실제 API 호출 없이 일관된 날씨 데이터를 반환합니다.

import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';

/// 날씨 데이터소스 Mock 구현
/// - 성공/실패/지연 시나리오를 시뮬레이션할 수 있습니다.
class MockWeatherDataSource implements WeatherDataSourceInterface {
  /// Mock 응답 데이터 (커스터마이징 가능)
  Map<String, dynamic>? mockResponse;

  /// Mock 예외 (에러 시나리오용)
  Exception? mockException;

  /// 응답 지연 시간 (타임아웃 테스트용)
  Duration? responseDelay;

  /// 기본 성공 응답으로 설정
  void setupSuccess({
    double temp = 22.0,
    double feelsLike = 23.0,
    int humidity = 55,
    String description = '맑음',
    String icon = '01d',
    double precipitation = 0.0,
  }) {
    mockException = null;
    responseDelay = null;
    mockResponse = {
      'main': {
        'temp': temp,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'weather': [
        {'description': description, 'icon': icon},
      ],
      'rain': {'1h': precipitation},
    };
  }

  /// 네트워크 에러 시나리오 설정
  void setupNetworkError() {
    mockResponse = null;
    responseDelay = null;
    mockException = Exception('SocketException: Connection failed');
  }

  /// 서버 에러 시나리오 설정
  void setupServerError() {
    mockResponse = null;
    responseDelay = null;
    mockException = Exception('날씨 정보를 가져오는데 실패했습니다 (500)');
  }

  /// 타임아웃 시나리오 설정
  void setupTimeout({Duration delay = const Duration(seconds: 20)}) {
    mockResponse = null;
    mockException = null;
    responseDelay = delay;
  }

  /// API 키 에러 시나리오 설정
  void setupApiKeyError() {
    mockResponse = null;
    responseDelay = null;
    mockException = Exception('API 키가 설정되지 않았습니다');
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    // 지연 시간이 설정된 경우 대기
    if (responseDelay != null) {
      await Future.delayed(responseDelay!);
    }

    // 예외가 설정된 경우 throw
    if (mockException != null) {
      throw mockException!;
    }

    // Mock 응답 또는 기본 응답 반환
    return mockResponse ?? _defaultWeatherResponse;
  }

  /// 기본 날씨 응답 데이터
  static Map<String, dynamic> get _defaultWeatherResponse => {
        'main': {
          'temp': 22.0,
          'feels_like': 23.0,
          'humidity': 55,
        },
        'weather': [
          {'description': '맑음', 'icon': '01d'},
        ],
        'rain': {'1h': 0.0},
      };
}

/// 다양한 온도별 날씨 데이터 팩토리
class WeatherTestData {
  /// 더운 날씨 (28도 이상)
  static Map<String, dynamic> get hotWeather => {
        'main': {'temp': 32.0, 'feels_like': 35.0, 'humidity': 70},
        'weather': [
          {'description': '맑음', 'icon': '01d'}
        ],
        'rain': {'1h': 0.0},
      };

  /// 따뜻한 날씨 (23-27도)
  static Map<String, dynamic> get warmWeather => {
        'main': {'temp': 25.0, 'feels_like': 26.0, 'humidity': 60},
        'weather': [
          {'description': '구름 조금', 'icon': '02d'}
        ],
        'rain': {'1h': 0.0},
      };

  /// 선선한 날씨 (12-16도)
  static Map<String, dynamic> get coolWeather => {
        'main': {'temp': 14.0, 'feels_like': 12.0, 'humidity': 55},
        'weather': [
          {'description': '흐림', 'icon': '04d'}
        ],
        'rain': {'1h': 0.0},
      };

  /// 추운 날씨 (5도 이하)
  static Map<String, dynamic> get coldWeather => {
        'main': {'temp': 2.0, 'feels_like': -2.0, 'humidity': 40},
        'weather': [
          {'description': '눈', 'icon': '13d'}
        ],
        'rain': {'1h': 0.0},
      };

  /// 비오는 날씨
  static Map<String, dynamic> get rainyWeather => {
        'main': {'temp': 18.0, 'feels_like': 16.0, 'humidity': 85},
        'weather': [
          {'description': '비', 'icon': '10d'}
        ],
        'rain': {'1h': 5.5},
      };
}
