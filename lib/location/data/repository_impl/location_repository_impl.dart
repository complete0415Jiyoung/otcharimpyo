import 'package:geolocator/geolocator.dart';

import '../../domain/model/location.dart';
import '../../domain/repository/location_repository.dart';
import '../../../core/error/result.dart';
import '../../../core/utils/exception_mapper.dart';
import '../data_source/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl({required LocationDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<Location>> getCurrentLocation() async {
    try {
      // 권한 확인
      final permission = await _dataSource.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한이 필요합니다');
      }

      // 좌표 가져오기
      final position = await _dataSource.getCurrentPosition();

      // 주소 변환
      return await getLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st));
    }
  }

  @override
  Future<Result<Location>> getLocationFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      // Geocoding API로 주소 가져오기
      final placemarks = await _dataSource.getPlacemarksFromCoordinates(
        lat,
        lon,
      );

      if (placemarks.isEmpty) {
        return Error(
          mapExceptionToFailure(
            Exception('주소 정보를 찾을 수 없습니다'),
            StackTrace.current,
          ),
        );
      }

      final place = placemarks.first;

      // Location 모델 생성
      final location = Location(
        latitude: lat,
        longitude: lon,
        city: place.administrativeArea ?? '',      // 서울특별시
        district: place.subLocality ?? '',         // 은평구
        dong: place.thoroughfare ?? '',            // 역촌동
      );

      return Success(location);
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st));
    }
  }
}
