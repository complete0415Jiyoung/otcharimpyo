import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/model/outfit_item.dart';
import '../domain/usecase/get_current_weather_use_case.dart';
import '../data/data_source/weather_data_source.dart';
import '../data/repository_impl/weather_repository_impl.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

part 'outfit_notifier.g.dart';

@riverpod
class OutfitNotifier extends _$OutfitNotifier {
  late final GetCurrentWeatherUseCase _getWeatherUseCase;

  @override
  OutfitState build() {
    // DI 구성
    final weatherDataSource = WeatherDataSource();
    final weatherRepository = WeatherRepositoryImpl(
      dataSource: weatherDataSource,
    );
    _getWeatherUseCase = GetCurrentWeatherUseCase(weatherRepository);

    // 초기 로딩
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
    // 로딩 상태로 변경
    state = state.copyWith(loadingStatus: WeatherLoadingStatus.loading);

    try {
      // 위치 권한 확인
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('위치 권한이 없습니다');
        state = state.copyWith(
          loadingStatus: WeatherLoadingStatus.error,
          errorMessage: '위치 권한이 필요합니다',
        );
        return;
      }

      // 현재 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 날씨 정보 가져오기
      final weatherResult = await _getWeatherUseCase.execute(
        position.latitude,
        position.longitude,
      );

      if (weatherResult.hasValue) {
        final weather = weatherResult.value!;
        state = state.copyWith(
          temperature: weather.temp,
          weatherDescription: weather.description,
          lastUpdated: DateTime.now(),
          loadingStatus: WeatherLoadingStatus.success,
          errorMessage: null,
        );
        state = _applyOutfit(state, weather.temp);
      } else if (weatherResult.hasError) {
        debugPrint('날씨 조회 실패: ${weatherResult.error}');
        state = state.copyWith(
          loadingStatus: WeatherLoadingStatus.error,
          errorMessage: '날씨 정보를 불러오는데 실패했습니다',
        );
      }
    } catch (e) {
      debugPrint('날씨 및 옷차림 로딩 실패: $e');
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
