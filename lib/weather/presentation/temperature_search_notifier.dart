import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/model/outfit_item.dart';
import 'temperature_search_state.dart';

part 'temperature_search_notifier.g.dart';

@riverpod
class TemperatureSearchNotifier extends _$TemperatureSearchNotifier {
  @override
  TemperatureSearchState build() {
    // 초기 온도 12도로 설정하고 옷차림 적용
    final initialState = const TemperatureSearchState(
      selectedTemperature: 12.0,
    );
    return _applyOutfit(initialState, 12.0);
  }

  void onTemperatureChanged(double temperature) {
    state = state.copyWith(selectedTemperature: temperature);
    state = _applyOutfit(state, temperature);
  }

  TemperatureSearchState _applyOutfit(
    TemperatureSearchState current,
    double temp,
  ) {
    final items = _getOutfitForTemperature(temp);
    return current.copyWith(
      tops: items.where((e) => e.category == OutfitCategory.top).toList(),
      bottoms: items.where((e) => e.category == OutfitCategory.bottom).toList(),
      outers: items.where((e) => e.category == OutfitCategory.outer).toList(),
      accessories: items
          .where((e) => e.category == OutfitCategory.accessory)
          .toList(),
    );
  }

  List<OutfitItem> _getOutfitForTemperature(double temp) {
    if (temp >= 28) {
      return const [
        OutfitItem(name: '민소매', category: OutfitCategory.top),
        OutfitItem(name: '반팔', category: OutfitCategory.top),
        OutfitItem(name: '반바지', category: OutfitCategory.bottom),
        OutfitItem(name: '치마', category: OutfitCategory.bottom),
      ];
    } else if (temp >= 23) {
      return const [
        OutfitItem(name: '반팔', category: OutfitCategory.top),
        OutfitItem(name: '얇은 셔츠', category: OutfitCategory.top),
        OutfitItem(name: '반바지', category: OutfitCategory.bottom),
        OutfitItem(name: '면바지', category: OutfitCategory.bottom),
      ];
    } else if (temp >= 20) {
      return const [
        OutfitItem(name: '긴팔티', category: OutfitCategory.top),
        OutfitItem(name: '면바지', category: OutfitCategory.bottom),
        OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        OutfitItem(name: '얇은 카디건', category: OutfitCategory.outer),
      ];
    } else if (temp >= 17) {
      return const [
        OutfitItem(name: '얇은 니트', category: OutfitCategory.top),
        OutfitItem(name: '맨투맨', category: OutfitCategory.top),
        OutfitItem(name: '면바지', category: OutfitCategory.bottom),
        OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        OutfitItem(name: '카디건', category: OutfitCategory.outer),
        OutfitItem(name: '얇은 재킷', category: OutfitCategory.outer),
      ];
    } else if (temp >= 12) {
      return const [
        OutfitItem(name: '니트', category: OutfitCategory.top),
        OutfitItem(name: '맨투맨', category: OutfitCategory.top),
        OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        OutfitItem(name: '면바지', category: OutfitCategory.bottom),
        OutfitItem(name: '스타킹', category: OutfitCategory.bottom),
        OutfitItem(name: '재킷', category: OutfitCategory.outer),
        OutfitItem(name: '카디건', category: OutfitCategory.outer),
        OutfitItem(name: '야상', category: OutfitCategory.outer),
      ];
    } else if (temp >= 9) {
      return const [
        OutfitItem(name: '니트', category: OutfitCategory.top),
        OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        OutfitItem(name: '면바지', category: OutfitCategory.bottom),
        OutfitItem(name: '스타킹', category: OutfitCategory.bottom),
        OutfitItem(name: '재킷', category: OutfitCategory.outer),
        OutfitItem(name: '트렌치코트', category: OutfitCategory.outer),
        OutfitItem(name: '야상', category: OutfitCategory.outer),
      ];
    } else if (temp >= 5) {
      return const [
        OutfitItem(name: '히트텍', category: OutfitCategory.top),
        OutfitItem(name: '니트', category: OutfitCategory.top),
        OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        OutfitItem(name: '레깅스', category: OutfitCategory.bottom),
        OutfitItem(name: '코트', category: OutfitCategory.outer),
      ];
    } else if (temp >= 1) {
      return const [
        OutfitItem(name: '기모 제품', category: OutfitCategory.top),
        OutfitItem(name: '기모 제품', category: OutfitCategory.bottom),
        OutfitItem(name: '패딩', category: OutfitCategory.outer),
        OutfitItem(name: '두꺼운 코트', category: OutfitCategory.outer),
        OutfitItem(name: '목도리', category: OutfitCategory.accessory),
      ];
    } else if (temp >= -4) {
      return const [
        OutfitItem(name: '스웨터', category: OutfitCategory.top),
        OutfitItem(name: '기모 제품', category: OutfitCategory.bottom),
        OutfitItem(name: '두꺼운 패딩', category: OutfitCategory.outer),
        OutfitItem(name: '귀마개', category: OutfitCategory.accessory),
        OutfitItem(name: '부츠', category: OutfitCategory.accessory),
        OutfitItem(name: '방한 제품', category: OutfitCategory.accessory),
      ];
    } else {
      return const [
        OutfitItem(name: '스웨터', category: OutfitCategory.top),
        OutfitItem(name: '기모 제품', category: OutfitCategory.bottom),
        OutfitItem(name: '파카', category: OutfitCategory.outer),
        OutfitItem(name: '코트', category: OutfitCategory.outer),
        OutfitItem(name: '방한 아웃도어 제품', category: OutfitCategory.accessory),
      ];
    }
  }
}
