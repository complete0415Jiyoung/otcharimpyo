import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/model/outfit_item.dart';

part 'outfit_state.freezed.dart';

enum WeatherLoadingStatus { initial, loading, success, error }

@freezed
class OutfitState with _$OutfitState {
  const factory OutfitState({
    @Default(20.0) double temperature,
    @Default('맑음') String weatherDescription,
    @Default([]) List<OutfitItem> tops,
    @Default([]) List<OutfitItem> bottoms,
    @Default([]) List<OutfitItem> outers,
    @Default([]) List<OutfitItem> accessories,
    DateTime? lastUpdated,
    @Default(WeatherLoadingStatus.initial) WeatherLoadingStatus loadingStatus,
    String? errorMessage,
  }) = _OutfitState;
}
