import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'location_data_source_interface.dart';

/// Mock LocationDataSource - 서울 시청 좌표 반환
class MockLocationDataSource implements LocationDataSourceInterface {
  // 서울 시청 좌표
  static const double _seoulLat = 37.5665;
  static const double _seoulLon = 126.9780;

  @override
  Future<Position> getCurrentPosition() async {
    // 약간의 딜레이를 주어 실제 API 호출처럼 보이게
    await Future.delayed(const Duration(milliseconds: 300));

    return Position(
      latitude: _seoulLat,
      longitude: _seoulLon,
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

  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      Placemark(
        administrativeArea: '서울특별시',
        subAdministrativeArea: '',
        locality: '서울특별시',
        subLocality: '중구',
        thoroughfare: '세종대로',
        subThoroughfare: '110',
        postalCode: '04524',
        country: '대한민국',
        isoCountryCode: 'KR',
        name: '서울시청',
        street: '세종대로 110',
      ),
    ];
  }
}
