import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/model/outfit_item.dart';

part 'outfit_state.freezed.dart';

enum WeatherLoadingStatus { initial, loading, success, error }

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
  }) = _OutfitState;
}
