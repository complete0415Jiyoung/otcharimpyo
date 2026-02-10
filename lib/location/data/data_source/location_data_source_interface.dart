import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// LocationDataSource 추상 인터페이스
/// 테스트에서 Mock으로 대체할 수 있도록 인터페이스 분리
abstract class LocationDataSourceInterface {
  /// GPS로 현재 위치 좌표 가져오기
  Future<Position> getCurrentPosition();

  /// 위치 권한 확인
  Future<LocationPermission> checkPermission();

  /// 위치 권한 요청
  Future<LocationPermission> requestPermission();

  /// 좌표를 주소로 변환 (Geocoding)
  Future<List<Placemark>> getPlacemarksFromCoordinates(double lat, double lon);
}
