import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';

void main() {
  group('OutfitCategory', () {
    test('should have all expected categories', () {
      expect(OutfitCategory.values, contains(OutfitCategory.top));
      expect(OutfitCategory.values, contains(OutfitCategory.bottom));
      expect(OutfitCategory.values, contains(OutfitCategory.outer));
      expect(OutfitCategory.values, contains(OutfitCategory.accessory));
    });

    test('should have 4 categories', () {
      expect(OutfitCategory.values.length, 4);
    });
  });

  group('OutfitItem', () {
    group('Constructor', () {
      test('should create OutfitItem with name and category', () {
        const item = OutfitItem(
          name: '반팔',
          category: OutfitCategory.top,
        );

        expect(item.name, '반팔');
        expect(item.category, OutfitCategory.top);
      });

      test('should create top category item', () {
        const item = OutfitItem(
          name: '긴팔티',
          category: OutfitCategory.top,
        );

        expect(item.category, OutfitCategory.top);
      });

      test('should create bottom category item', () {
        const item = OutfitItem(
          name: '청바지',
          category: OutfitCategory.bottom,
        );

        expect(item.category, OutfitCategory.bottom);
      });

      test('should create outer category item', () {
        const item = OutfitItem(
          name: '패딩',
          category: OutfitCategory.outer,
        );

        expect(item.category, OutfitCategory.outer);
      });

      test('should create accessory category item', () {
        const item = OutfitItem(
          name: '목도리',
          category: OutfitCategory.accessory,
        );

        expect(item.category, OutfitCategory.accessory);
      });
    });

    group('Equality', () {
      test('should be equal when name and category are the same', () {
        const item1 = OutfitItem(
          name: '반팔',
          category: OutfitCategory.top,
        );
        const item2 = OutfitItem(
          name: '반팔',
          category: OutfitCategory.top,
        );

        expect(item1, equals(item2));
      });

      test('should not be equal when name differs', () {
        const item1 = OutfitItem(
          name: '반팔',
          category: OutfitCategory.top,
        );
        const item2 = OutfitItem(
          name: '긴팔',
          category: OutfitCategory.top,
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when category differs', () {
        const item1 = OutfitItem(
          name: '청바지',
          category: OutfitCategory.bottom,
        );
        const item2 = OutfitItem(
          name: '청바지',
          category: OutfitCategory.top,
        );

        expect(item1, isNot(equals(item2)));
      });
    });

    group('copyWith', () {
      test('should copy with new name', () {
        const original = OutfitItem(
          name: '반팔',
          category: OutfitCategory.top,
        );

        final copied = original.copyWith(name: '긴팔');

        expect(copied.name, '긴팔');
        expect(copied.category, OutfitCategory.top);
      });

      test('should copy with new category', () {
        const original = OutfitItem(
          name: '청바지',
          category: OutfitCategory.bottom,
        );

        final copied = original.copyWith(category: OutfitCategory.top);

        expect(copied.name, '청바지');
        expect(copied.category, OutfitCategory.top);
      });
    });
  });
}
