import 'package:geolocator/geolocator.dart';
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
      case OnChangeLocation(:final latitude, :final longitude, :final locationName):
        state = state.copyWith(
          useCurrentLocation: false,
          selectedLatitude: latitude,
          selectedLongitude: longitude,
          selectedLocationName: locationName,
        );
        await _loadWeatherForSelectedLocation(latitude, longitude, locationName);
      case OnUseCurrentLocation():
        // 위치 권한 체크
        final permissionError = await _checkLocationPermission();
        if (permissionError != LocationPermissionError.none) {
          state = state.copyWith(
            locationPermissionError: permissionError,
          );
          return;
        }

        state = state.copyWith(
          useCurrentLocation: true,
          selectedLatitude: null,
          selectedLongitude: null,
          selectedLocationName: null,
          locationPermissionError: LocationPermissionError.none,
        );
        await _loadWeatherAndOutfit();
    }
  }

  // 기본 위치: 서울시청 (위치 서비스 비활성화 시 사용)
  static const _defaultLatitude = 37.5665;
  static const _defaultLongitude = 126.9780;
  static const _defaultLocationName = '서울';

  /// 위치 권한 에러 초기화
  void clearLocationPermissionError() {
    state = state.copyWith(locationPermissionError: LocationPermissionError.none);
  }

  /// 위치 권한 체크
  Future<LocationPermissionError> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionError.serviceDisabled;
    }

    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          return LocationPermissionError.permissionDenied;
        }
        if (requested == LocationPermission.deniedForever) {
          return LocationPermissionError.permissionDeniedForever;
        }
        return LocationPermissionError.none;
      case LocationPermission.deniedForever:
        return LocationPermissionError.permissionDeniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionError.none;
      case LocationPermission.unableToDetermine:
        return LocationPermissionError.permissionDenied;
    }
  }

  Future<void> _loadWeatherAndOutfit() async {
    state = state.copyWith(loadingStatus: WeatherLoadingStatus.loading);

    try {
      // 🔥 1. 위치 정보 가져오기 (UseCase 사용!)
      double latitude = _defaultLatitude;
      double longitude = _defaultLongitude;
      String locationName = _defaultLocationName;
      bool isUsingCurrentLocation = false; // 실제 GPS 위치 사용 여부

      try {
        final locationResult = await _getLocationUseCase.execute().timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('위치 정보를 가져오는데 시간이 초과되었습니다'),
        );

        if (locationResult.hasValue) {
          final location = locationResult.value!;
          latitude = location.latitude;
          longitude = location.longitude;
          locationName = location.fullAddress;
          isUsingCurrentLocation = true; // GPS 위치 사용 성공
        }
        // 위치 실패 시 기본 위치 사용 (에러 무시)
      } catch (_) {
        // 위치 조회 실패 시 기본 위치 사용
        isUsingCurrentLocation = false;
      }

      // 🔥 2. 날씨 정보 가져오기
      final weatherResult = await _getWeatherUseCase
          .execute(latitude, longitude)
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
        location: locationName,
        feelsLike: weather.feelsLike,
        humidity: weather.humidity,
        precipitation: weather.precipitation,
        weatherIcon: weather.icon,
        lastUpdated: DateTime.now(),
        loadingStatus: WeatherLoadingStatus.success,
        errorMessage: null,
        useCurrentLocation: isUsingCurrentLocation, // GPS 위치 사용 여부 반영
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

  /// 선택된 위치로 날씨 조회
  Future<void> _loadWeatherForSelectedLocation(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    state = state.copyWith(loadingStatus: WeatherLoadingStatus.loading);

    try {
      final weatherResult = await _getWeatherUseCase
          .execute(latitude, longitude)
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

      state = state.copyWith(
        temperature: weather.temp,
        weatherDescription: weather.description,
        location: locationName,
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
