import '../model/location.dart';
import '../../../core/error/result.dart';

abstract interface class LocationRepository {
  /// 현재 위치 가져오기 (GPS)
  Future<Result<Location>> getCurrentLocation();
  
  /// 좌표로 주소 가져오기
  Future<Result<Location>> getLocationFromCoordinates(double lat, double lon);
}
