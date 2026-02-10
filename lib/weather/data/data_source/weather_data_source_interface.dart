/// WeatherDataSource 추상 인터페이스
/// 테스트에서 Mock으로 대체할 수 있도록 인터페이스 분리
abstract class WeatherDataSourceInterface {
  /// 현재 날씨 정보를 API에서 가져옴
  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon);
}
