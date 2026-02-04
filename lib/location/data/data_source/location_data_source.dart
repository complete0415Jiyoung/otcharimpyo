import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationDataSource {
  /// GPS로 현재 위치 좌표 가져오기
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  /// 위치 권한 확인
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// 위치 권한 요청
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// 좌표를 주소로 변환 (Geocoding)
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    return await placemarkFromCoordinates(lat, lon);
  }
}
