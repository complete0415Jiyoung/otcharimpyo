/// 위치 서비스 Mock
/// 통합 테스트에서 실제 GPS 호출 없이 일관된 위치 데이터를 반환합니다.

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';

/// 위치 데이터소스 Mock 구현
/// - 권한 상태, 위치, 주소 변환을 시뮬레이션할 수 있습니다.
class MockLocationDataSource implements LocationDataSourceInterface {
  /// Mock 위치 좌표
  Position? mockPosition;

  /// Mock 권한 상태
  LocationPermission mockPermission = LocationPermission.whileInUse;

  /// Mock 주소 정보
  List<Placemark>? mockPlacemarks;

  /// Mock 예외 (에러 시나리오용)
  Exception? mockException;

  /// 기본 성공 시나리오 설정 (서울)
  void setupSeoulLocation() {
    mockException = null;
    mockPermission = LocationPermission.whileInUse;
    mockPosition = _createPosition(37.5665, 126.9780);
    mockPlacemarks = [
      Placemark(
        administrativeArea: '서울특별시',
        subLocality: '중구',
        thoroughfare: '명동',
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '04536',
        locality: '서울특별시',
        subAdministrativeArea: '',
        subThoroughfare: '',
      ),
    ];
  }

  /// 부산 위치 설정
  void setupBusanLocation() {
    mockException = null;
    mockPermission = LocationPermission.whileInUse;
    mockPosition = _createPosition(35.1796, 129.0756);
    mockPlacemarks = [
      Placemark(
        administrativeArea: '부산광역시',
        subLocality: '해운대구',
        thoroughfare: '우동',
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '48099',
        locality: '부산광역시',
        subAdministrativeArea: '',
        subThoroughfare: '',
      ),
    ];
  }

  /// 권한 거부 시나리오 설정
  void setupPermissionDenied() {
    mockPermission = LocationPermission.denied;
    mockException = null;
    mockPosition = null;
    mockPlacemarks = null;
  }

  /// 권한 영구 거부 시나리오 설정
  void setupPermissionDeniedForever() {
    mockPermission = LocationPermission.deniedForever;
    mockException = null;
    mockPosition = null;
    mockPlacemarks = null;
  }

  /// GPS 오류 시나리오 설정
  void setupGpsError() {
    mockPermission = LocationPermission.whileInUse;
    mockPosition = null;
    mockPlacemarks = null;
    mockException = Exception('GPS 신호를 찾을 수 없습니다');
  }

  /// Geocoding 오류 시나리오 설정
  void setupGeocodingError() {
    mockPermission = LocationPermission.whileInUse;
    mockPosition = _createPosition(37.5665, 126.9780);
    mockPlacemarks = [];
    mockException = null;
  }

  @override
  Future<Position> getCurrentPosition() async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockPosition ?? _defaultPosition;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return mockPermission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    // 권한 요청 시뮬레이션 - 현재 상태 반환
    return mockPermission;
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    if (mockException != null && mockPlacemarks == null) {
      throw mockException!;
    }
    return mockPlacemarks ?? [_defaultPlacemark];
  }

  /// Position 객체 생성 헬퍼
  Position _createPosition(double lat, double lon) {
    return Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  /// 기본 위치 (서울)
  static Position get _defaultPosition => Position(
        latitude: 37.5665,
        longitude: 126.9780,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

  /// 기본 주소 (서울 명동)
  static Placemark get _defaultPlacemark => Placemark(
        administrativeArea: '서울특별시',
        subLocality: '중구',
        thoroughfare: '명동',
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '04536',
        locality: '서울특별시',
        subAdministrativeArea: '',
        subThoroughfare: '',
      );
}

/// 위치 테스트 데이터 팩토리
class LocationTestData {
  /// 서울 명동
  static Position get seoulPosition => Position(
        latitude: 37.5665,
        longitude: 126.9780,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

  /// 부산 해운대
  static Position get busanPosition => Position(
        latitude: 35.1796,
        longitude: 129.0756,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

  /// 제주
  static Position get jejuPosition => Position(
        latitude: 33.4996,
        longitude: 126.5312,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
}
