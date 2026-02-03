import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit_action.freezed.dart';

@freezed
sealed class OutfitAction with _$OutfitAction {
  const factory OutfitAction.onChangeTemperature(double temperature) =
      OnChangeTemperature;
  const factory OutfitAction.onRefresh() = OnRefreshOutfit;
}
