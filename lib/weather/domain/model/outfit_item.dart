import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit_item.freezed.dart';

enum OutfitCategory { top, bottom, outer, accessory }

@freezed
class OutfitItem with _$OutfitItem {
  const factory OutfitItem({
    required String name,
    required OutfitCategory category,
  }) = _OutfitItem;
}
