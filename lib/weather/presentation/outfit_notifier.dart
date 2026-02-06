import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/di/di_setup.dart';
import '../domain/model/outfit_item.dart';
import '../domain/usecase/get_current_weather_use_case.dart';
import '../../location/domain/usecase/get_current_location_use_case.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

part 'outfit_notifier.g.dart';

@riverpod
class OutfitNotifier extends _$OutfitNotifier {
  // ✅ GetIt으로부터 주입받을 UseCase들
  late final GetCurrentWeatherUseCase _getWeatherUseCase;
  late final GetCurrentLocationUseCase _getLocationUseCase;

  OutfitNotifier({
    GetCurrentWeatherUseCase? getWeatherUseCase,
    GetCurrentLocationUseCase? getLocationUseCase,
  }) : _getWeatherUseCase =
           getWeatherUseCase ?? getIt<GetCurrentWeatherUseCase>(),
       _getLocationUseCase =
           getLocationUseCase ?? getIt<GetCurrentLocationUseCase>();

  @override
  OutfitState build() {
    Future.microtask(() => _loadWeatherAndOutfit());
    return const OutfitState();
  }

  Future<void> onAction(OutfitAction action) async {
    switch (action) {
      case OnChangeTemperature(:final temperature):
        state = _applyOutfit(state, temperature);
      case OnRefreshOutfit():
        await _loadWeatherAndOutfit();
    }
  }

  Future<void> _loadWeatherAndOutfit() async {
    state = state.copyWith(loadingStatus: WeatherLoadingStatus.loading);

    try {
      // 🔥 1. 위치 정보 가져오기 (UseCase 사용!)
      final locationResult = await _getLocationUseCase.execute().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('위치 정보를 가져오는데 시간이 초과되었습니다'),
      );

      if (!locationResult.hasValue) {
        final error = locationResult.error;
        state = state.copyWith(
          loadingStatus: WeatherLoadingStatus.error,
          errorMessage: error?.toString() ?? '위치 정보를 불러올 수 없습니다',
        );
        return;
      }

      final location = locationResult.value!;

      // 🔥 2. 날씨 정보 가져오기
      final weatherResult = await _getWeatherUseCase
          .execute(location.latitude, location.longitude)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('날씨 정보를 가져오는데 시간이 초과되었습니다'),
          );

      if (!weatherResult.hasValue) {
        state = state.copyWith(
          loadingStatus: WeatherLoadingStatus.error,
          errorMessage: '날씨 정보를 불러오는데 실패했습니다',
        );
        return;
      }

      final weather = weatherResult.value!;

      // 🔥 3. State 업데이트
      state = state.copyWith(
        temperature: weather.temp,
        weatherDescription: weather.description,
        location: location.fullAddress,
        feelsLike: weather.feelsLike,
        humidity: weather.humidity,
        precipitation: weather.precipitation,
        weatherIcon: weather.icon,
        lastUpdated: DateTime.now(),
        loadingStatus: WeatherLoadingStatus.success,
        errorMessage: null,
      );

      state = _applyOutfit(state, weather.temp);
    } on Exception catch (e) {
      final errorMsg = e.toString().contains('시간이 초과')
          ? '요청 시간이 초과되었습니다\n네트워크 연결을 확인해주세요'
          : '날씨 정보를 불러오는데 실패했습니다';

      state = state.copyWith(
        loadingStatus: WeatherLoadingStatus.error,
        errorMessage: errorMsg,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: WeatherLoadingStatus.error,
        errorMessage: '날씨 정보를 불러오는데 실패했습니다',
      );
    }
  }

  OutfitState _applyOutfit(OutfitState current, double temp) {
    final items = _getOutfitForTemperature(temp);
    return current.copyWith(
      temperature: temp,
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
