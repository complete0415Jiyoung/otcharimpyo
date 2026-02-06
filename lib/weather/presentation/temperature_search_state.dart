import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/model/outfit_item.dart';

part 'temperature_search_state.freezed.dart';

@freezed
class TemperatureSearchState with _$TemperatureSearchState {
  const factory TemperatureSearchState({
    @Default(12.0) double selectedTemperature,
    @Default([]) List<OutfitItem> tops,
    @Default([]) List<OutfitItem> bottoms,
    @Default([]) List<OutfitItem> outers,
    @Default([]) List<OutfitItem> accessories,
  }) = _TemperatureSearchState;
}
