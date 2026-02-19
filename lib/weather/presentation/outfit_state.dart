import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/model/outfit_item.dart';

part 'outfit_state.freezed.dart';

enum WeatherLoadingStatus { initial, loading, success, error }

/// 위치 권한 에러 타입
enum LocationPermissionError {
  none, // 에러 없음
  serviceDisabled, // 위치 서비스 비활성화
  permissionDenied, // 권한 거부됨
  permissionDeniedForever, // 권한 영구 거부됨
}

@freezed
class OutfitState with _$OutfitState {
  const factory OutfitState({
    @Default(20.0) double temperature,
    @Default('') String weatherDescription,
    @Default([]) List<OutfitItem> tops,
    @Default([]) List<OutfitItem> bottoms,
    @Default([]) List<OutfitItem> outers,
    @Default([]) List<OutfitItem> accessories,
    DateTime? lastUpdated,
    @Default(WeatherLoadingStatus.initial) WeatherLoadingStatus loadingStatus,
    String? errorMessage,

    @Default('') String location, // 위치
    @Default(0.0) double feelsLike, // 체감온도
    @Default(0) int humidity, // 습도
    @Default(0.0) double precipitation, // 강수량
    String? weatherIcon, // 날씨 아이콘

    // 사용자 선택 위치 정보
    @Default(true) bool useCurrentLocation, // 현재 위치 사용 여부
    double? selectedLatitude, // 선택된 위도
    double? selectedLongitude, // 선택된 경도
    String? selectedLocationName, // 선택된 위치 이름

    // 위치 권한 에러
    @Default(LocationPermissionError.none) LocationPermissionError locationPermissionError,
  }) = _OutfitState;
}
