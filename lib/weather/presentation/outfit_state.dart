import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/model/outfit_item.dart';

part 'outfit_state.freezed.dart';

@freezed
class OutfitState with _$OutfitState {
  const factory OutfitState({
    @Default(20.0) double temperature,
    @Default('맑음') String weatherDescription,
    @Default([]) List<OutfitItem> tops,
    @Default([]) List<OutfitItem> bottoms,
    @Default([]) List<OutfitItem> outers,
    @Default([]) List<OutfitItem> accessories,
  }) = _OutfitState;
}
