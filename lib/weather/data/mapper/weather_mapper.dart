import '../../domain/model/weather.dart';
import '../dto/weather_dto.dart';

extension WeatherDtoMapper on WeatherDto {
  Weather toModel() {
    return Weather(
      temp: main?.temp ?? 0.0,
      description: weather?.firstOrNull?.description ?? '',
      icon: weather?.firstOrNull?.icon ?? '',
    );
  }
}
