import '../../domain/model/weather.dart';
import '../dto/weather_dto.dart';

extension WeatherDtoMapper on WeatherDto {
  Weather toModel() {
    return Weather(
      temp: main?.temp ?? 0.0,
      description: weather?.firstOrNull?.description ?? '',
      icon: weather?.firstOrNull?.icon ?? '',

      feelsLike: main?.feelsLike ?? main?.temp ?? 0.0,
      humidity: main?.humidity ?? 0,
      precipitation: rain?.oneHour ?? 0.0,
    );
  }
}
