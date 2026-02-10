import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';

/// Mock WeatherDataSource for testing
class MockWeatherDataSource implements WeatherDataSourceInterface {
  Map<String, dynamic>? mockResponse;
  Exception? mockException;

  void setMockResponse(Map<String, dynamic> response) {
    mockResponse = response;
    mockException = null;
  }

  void setMockException(Exception exception) {
    mockException = exception;
    mockResponse = null;
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockResponse ?? _defaultWeatherResponse;
  }

  static Map<String, dynamic> get _defaultWeatherResponse => {
    'main': {'temp': 25.0, 'feels_like': 26.0, 'humidity': 60},
    'weather': [
      {'description': '맑음', 'icon': '01d'},
    ],
    'rain': {'1h': 0.0},
  };
}

/// Mock LocationDataSource for testing
class MockLocationDataSource implements LocationDataSourceInterface {
  Position? mockPosition;
  LocationPermission mockPermission = LocationPermission.whileInUse;
  List<Placemark>? mockPlacemarks;
  Exception? mockException;

  void setMockPosition(Position position) {
    mockPosition = position;
    mockException = null;
  }

  void setMockPermission(LocationPermission permission) {
    mockPermission = permission;
  }

  void setMockPlacemarks(List<Placemark> placemarks) {
    mockPlacemarks = placemarks;
    mockException = null;
  }

  void setMockException(Exception exception) {
    mockException = exception;
    mockPosition = null;
    mockPlacemarks = null;
  }

  @override
  Future<Position> getCurrentPosition() async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockPosition ?? _defaultPosition;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return mockPermission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return mockPermission;
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockPlacemarks ?? [_defaultPlacemark];
  }

  static Position get _defaultPosition => Position(
    latitude: 37.5665,
    longitude: 126.9780,
    timestamp: DateTime.now(),
    accuracy: 10.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  static Placemark get _defaultPlacemark => Placemark(
    administrativeArea: '서울특별시',
    subLocality: '중구',
    thoroughfare: '명동',
    name: '',
    street: '',
    isoCountryCode: 'KR',
    country: '대한민국',
    postalCode: '04536',
    locality: '서울특별시',
    subAdministrativeArea: '',
    subThoroughfare: '',
  );
}
