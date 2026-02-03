import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/error/result.dart';
import '../model/weather.dart';
import '../repository/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository _repository;

  GetCurrentWeatherUseCase(this._repository);

  Future<AsyncValue<Weather>> execute(double lat, double lon) async {
    final result = await _repository.getCurrentWeather(lat, lon);
    return switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Error(:final failure) => AsyncValue.error(failure, StackTrace.current),
    };
  }
}
