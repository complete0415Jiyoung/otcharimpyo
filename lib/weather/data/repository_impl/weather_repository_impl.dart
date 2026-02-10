import '../../../core/error/result.dart';
import '../../../core/utils/exception_mapper.dart';
import '../../domain/model/weather.dart';
import '../../domain/repository/weather_repository.dart';
import '../data_source/weather_data_source_interface.dart';
import '../dto/weather_dto.dart';
import '../mapper/weather_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSourceInterface _dataSource;

  WeatherRepositoryImpl({required WeatherDataSourceInterface dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<Weather>> getCurrentWeather(double lat, double lon) async {
    try {
      final json = await _dataSource.fetchCurrentWeather(lat, lon);
      final dto = WeatherDto.fromJson(json);
      return Success(dto.toModel());
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st));
    }
  }
}
