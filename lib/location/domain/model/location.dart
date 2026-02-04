import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required double latitude,
    required double longitude,
    required String city, // 시/도 (서울특별시)
    required String district, // 구 (은평구)
    required String dong, // 동 (역촌동)
  }) = _Location;

  const Location._();

  /// 전체 주소 문자열
  String get fullAddress {
    if (city.isNotEmpty && district.isNotEmpty && dong.isNotEmpty) {
      return '$city $district $dong';
    }
    if (city.isNotEmpty && district.isNotEmpty) {
      return '$city $district';
    }
    if (city.isNotEmpty) {
      return city;
    }
    return '위치 정보 없음';
  }
}
