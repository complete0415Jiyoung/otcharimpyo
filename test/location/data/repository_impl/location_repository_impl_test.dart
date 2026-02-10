import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source.dart';
import 'package:otcharimpyo/location/data/repository_impl/location_repository_impl.dart';

class MockLocationDataSource extends LocationDataSource {
  LocationPermission? mockPermission;
  Position? mockPosition;
  List<Placemark>? mockPlacemarks;
  Exception? mockException;

  @override
  Future<LocationPermission> checkPermission() async {
    if (mockException != null) throw mockException!;
    return mockPermission ?? LocationPermission.denied;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return mockPermission ?? LocationPermission.denied;
  }

  @override
  Future<Position> getCurrentPosition() async {
    if (mockException != null) throw mockException!;
    if (mockPosition != null) return mockPosition!;
    throw Exception('Position not set');
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    if (mockException != null) throw mockException!;
    return mockPlacemarks ?? [];
  }
}

Position createMockPosition({
  double latitude = 37.5665,
  double longitude = 126.9780,
}) {
  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

Placemark createMockPlacemark({
  String? administrativeArea,
  String? subLocality,
  String? thoroughfare,
}) {
  return Placemark(
    administrativeArea: administrativeArea,
    subLocality: subLocality,
    thoroughfare: thoroughfare,
  );
}

void main() {
  late LocationRepositoryImpl repository;
  late MockLocationDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockLocationDataSource();
    repository = LocationRepositoryImpl(dataSource: mockDataSource);
  });

  group('LocationRepositoryImpl', () {
    group('getCurrentLocation', () {
      test('should return Success with Location when permission granted and data available', () async {
        mockDataSource.mockPermission = LocationPermission.always;
        mockDataSource.mockPosition = createMockPosition(
          latitude: 37.5665,
          longitude: 126.9780,
        );
        mockDataSource.mockPlacemarks = [
          createMockPlacemark(
            administrativeArea: '서울특별시',
            subLocality: '중구',
            thoroughfare: '명동',
          ),
        ];

        final result = await repository.getCurrentLocation();

        expect(result, isA<Success>());
        final location = (result as Success).value;
        expect(location.city, '서울특별시');
        expect(location.district, '중구');
        expect(location.dong, '명동');
      });

      test('should return Error when permission denied', () async {
        mockDataSource.mockPermission = LocationPermission.denied;

        final result = await repository.getCurrentLocation();

        expect(result, isA<Error>());
      });

      test('should return Error when permission denied forever', () async {
        mockDataSource.mockPermission = LocationPermission.deniedForever;

        final result = await repository.getCurrentLocation();

        expect(result, isA<Error>());
      });

      test('should return Error when data source throws exception', () async {
        mockDataSource.mockPermission = LocationPermission.always;
        mockDataSource.mockException = Exception('GPS 오류');

        final result = await repository.getCurrentLocation();

        expect(result, isA<Error>());
      });
    });

    group('getLocationFromCoordinates', () {
      test('should return Success with Location when placemarks available', () async {
        mockDataSource.mockPlacemarks = [
          createMockPlacemark(
            administrativeArea: '부산광역시',
            subLocality: '해운대구',
            thoroughfare: '우동',
          ),
        ];

        final result = await repository.getLocationFromCoordinates(
          35.1796,
          129.0756,
        );

        expect(result, isA<Success>());
        final location = (result as Success).value;
        expect(location.latitude, 35.1796);
        expect(location.longitude, 129.0756);
        expect(location.city, '부산광역시');
      });

      test('should return Error when placemarks empty', () async {
        mockDataSource.mockPlacemarks = [];

        final result = await repository.getLocationFromCoordinates(
          37.5665,
          126.9780,
        );

        expect(result, isA<Error>());
      });

      test('should handle null address fields', () async {
        mockDataSource.mockPlacemarks = [
          createMockPlacemark(
            administrativeArea: '서울특별시',
            subLocality: null,
            thoroughfare: null,
          ),
        ];

        final result = await repository.getLocationFromCoordinates(
          37.5665,
          126.9780,
        );

        expect(result, isA<Success>());
        final location = (result as Success).value;
        expect(location.city, '서울특별시');
        expect(location.district, '');
        expect(location.dong, '');
      });

      test('should return Error when geocoding fails', () async {
        mockDataSource.mockException = Exception('Geocoding 실패');

        final result = await repository.getLocationFromCoordinates(
          37.5665,
          126.9780,
        );

        expect(result, isA<Error>());
      });
    });
  });
}
