import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/location/domain/model/location.dart';

void main() {
  group('Location', () {
    group('Constructor', () {
      test('should create Location with all required fields', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        expect(location.latitude, 37.5665);
        expect(location.longitude, 126.9780);
        expect(location.city, '서울특별시');
        expect(location.district, '중구');
        expect(location.dong, '명동');
      });

      test('should create Location with negative coordinates', () {
        const location = Location(
          latitude: -33.8688,
          longitude: 151.2093,
          city: 'Sydney',
          district: 'CBD',
          dong: '',
        );

        expect(location.latitude, -33.8688);
        expect(location.longitude, 151.2093);
      });
    });

    group('fullAddress', () {
      test('should return full address when all fields are present', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '은평구',
          dong: '역촌동',
        );

        expect(location.fullAddress, '서울특별시 은평구 역촌동');
      });

      test('should return city and district when dong is empty', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '은평구',
          dong: '',
        );

        expect(location.fullAddress, '서울특별시 은평구');
      });

      test('should return only city when district and dong are empty', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '',
          dong: '',
        );

        expect(location.fullAddress, '서울특별시');
      });

      test('should return default message when all address fields are empty', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '',
          district: '',
          dong: '',
        );

        expect(location.fullAddress, '위치 정보 없음');
      });

      test('should return default message when city is empty but others are not', () {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '',
          district: '은평구',
          dong: '역촌동',
        );

        expect(location.fullAddress, '위치 정보 없음');
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        const location1 = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );
        const location2 = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        expect(location1, equals(location2));
      });

      test('should not be equal when coordinates differ', () {
        const location1 = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );
        const location2 = Location(
          latitude: 35.1796,
          longitude: 129.0756,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        expect(location1, isNot(equals(location2)));
      });
    });

    group('copyWith', () {
      test('should copy with new city', () {
        const original = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        final copied = original.copyWith(city: '부산광역시');

        expect(copied.city, '부산광역시');
        expect(copied.district, '중구');
        expect(copied.latitude, 37.5665);
      });

      test('should copy with new coordinates', () {
        const original = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        final copied = original.copyWith(
          latitude: 35.1796,
          longitude: 129.0756,
        );

        expect(copied.latitude, 35.1796);
        expect(copied.longitude, 129.0756);
        expect(copied.city, '서울특별시');
      });
    });
  });
}
