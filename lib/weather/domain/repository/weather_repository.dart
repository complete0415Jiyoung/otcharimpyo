import '../../../core/error/result.dart';
import '../model/weather.dart';

abstract interface class WeatherRepository {
  Future<Result<Weather>> getCurrentWeather(double lat, double lon);
}
