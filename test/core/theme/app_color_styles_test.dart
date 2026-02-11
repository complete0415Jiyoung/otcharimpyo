import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/theme/app_color_styles.dart';

void main() {
  group('AppColors', () {
    group('Primary Colors', () {
      test('should have correct primary color', () {
        expect(AppColors.primary, const Color(0xFF0E8AE4));
      });

      test('should have correct darkGray color', () {
        expect(AppColors.darkGray, const Color(0xFF494A4B));
      });

      test('should have correct mediumGray color', () {
        expect(AppColors.mediumGray, const Color(0xFF8E8E8E));
      });

      test('should have correct lightGray color', () {
        expect(AppColors.lightGray, const Color(0xFFBEBEBE));
      });

      test('should have correct backgroundGray color', () {
        expect(AppColors.backgroundGray, const Color(0xFF383838));
      });

      test('should have correct white color', () {
        expect(AppColors.white, const Color(0xFFFFFFFF));
      });

      test('should have correct black color', () {
        expect(AppColors.black, const Color(0xFF000000));
      });
    });

    group('Accent Colors', () {
      test('should have correct yellow color', () {
        expect(AppColors.yellow, const Color(0xFFF8E36F));
      });

      test('should have correct orange color', () {
        expect(AppColors.orange, const Color(0xFFFA9E42));
      });
    });

    group('Text Colors', () {
      test('should have correct textPrimary color', () {
        expect(AppColors.textPrimary, AppColors.darkGray);
      });

      test('should have correct textSecondary color', () {
        expect(AppColors.textSecondary, AppColors.mediumGray);
      });

      test('should have correct textTertiary color', () {
        expect(AppColors.textTertiary, AppColors.lightGray);
      });

      test('should have correct textInverse color', () {
        expect(AppColors.textInverse, AppColors.white);
      });
    });

    group('Background Colors', () {
      test('should have correct background color', () {
        expect(AppColors.background, AppColors.white);
      });

      test('should have correct backgroundSecondary color', () {
        expect(AppColors.backgroundSecondary, const Color(0xFFF5F5F5));
      });

      test('should have correct backgroundDark color', () {
        expect(AppColors.backgroundDark, AppColors.backgroundGray);
      });
    });

    group('State Colors', () {
      test('should have correct error color', () {
        expect(AppColors.error, const Color(0xFFEF4444));
      });

      test('should have correct success color', () {
        expect(AppColors.success, const Color(0xFF10B981));
      });

      test('should have correct warning color', () {
        expect(AppColors.warning, AppColors.yellow);
      });

      test('should have correct info color', () {
        expect(AppColors.info, AppColors.primary);
      });
    });

    group('Overlay Colors', () {
      test('should have correct blackOverlay70', () {
        expect(AppColors.blackOverlay70.opacity, closeTo(0.7, 0.01));
      });

      test('should have correct blackOverlay40', () {
        expect(AppColors.blackOverlay40.opacity, closeTo(0.4, 0.01));
      });

      test('should have correct whiteOverlay65', () {
        expect(AppColors.whiteOverlay65.opacity, closeTo(0.65, 0.01));
      });

      test('should have correct whiteOverlay81', () {
        expect(AppColors.whiteOverlay81.opacity, closeTo(0.81, 0.01));
      });

      test('should have correct blueOverlay22', () {
        expect(AppColors.blueOverlay22.opacity, closeTo(0.22, 0.01));
      });
    });

    group('Temperature Colors', () {
      test('should have correct veryHot color', () {
        expect(AppColors.veryHot, AppColors.orange);
      });

      test('should have correct hot color', () {
        expect(AppColors.hot, AppColors.yellow);
      });

      test('should have correct comfortable color', () {
        expect(AppColors.comfortable, AppColors.primary);
      });

      test('should have correct cool color', () {
        expect(AppColors.cool, const Color(0xFF5BA8E4));
      });

      test('should have correct cold color', () {
        expect(AppColors.cold, const Color(0xFF2E5F8E));
      });

      test('should have correct veryCold color', () {
        expect(AppColors.veryCold, const Color(0xFF1E3A5F));
      });
    });

    group('Temperature Background Colors', () {
      test('should have correct veryHotBackground', () {
        expect(AppColors.veryHotBackground, const Color(0xFFFFF5E6));
      });

      test('should have correct hotBackground', () {
        expect(AppColors.hotBackground, const Color(0xFFFFFBEA));
      });

      test('should have correct comfortableBackground', () {
        expect(AppColors.comfortableBackground, const Color(0xFFE8F4FB));
      });

      test('should have correct coolBackground', () {
        expect(AppColors.coolBackground, const Color(0xFFE1F0FA));
      });

      test('should have correct coldBackground', () {
        expect(AppColors.coldBackground, const Color(0xFFD6E9F7));
      });

      test('should have correct veryColdBackground', () {
        expect(AppColors.veryColdBackground, const Color(0xFFCEE3F4));
      });
    });

    group('Gradients', () {
      test('should have correct primaryGradient', () {
        expect(AppColors.primaryGradient.length, 2);
        expect(AppColors.primaryGradient[0], const Color(0xFF0E8AE4));
        expect(AppColors.primaryGradient[1], const Color(0xFF5BA8E4));
      });

      test('should have correct warmGradient', () {
        expect(AppColors.warmGradient.length, 2);
        expect(AppColors.warmGradient[0], const Color(0xFFFA9E42));
        expect(AppColors.warmGradient[1], const Color(0xFFF8E36F));
      });

      test('should have correct coolGradient', () {
        expect(AppColors.coolGradient.length, 2);
        expect(AppColors.coolGradient[0], const Color(0xFF0E8AE4));
        expect(AppColors.coolGradient[1], const Color(0xFF2E5F8E));
      });
    });

    group('Category Colors', () {
      test('should have 4 category colors', () {
        expect(AppColors.categoryColors.length, 4);
      });

      test('should have correct category colors', () {
        expect(AppColors.categoryColors[0], const Color(0xFF0E8AE4));
        expect(AppColors.categoryColors[1], const Color(0xFFF8E36F));
        expect(AppColors.categoryColors[2], const Color(0xFFFA9E42));
        expect(AppColors.categoryColors[3], const Color(0xFF10B981));
      });
    });

    group('getTemperatureColor', () {
      test('should return veryHot for temperature >= 28', () {
        expect(AppColors.getTemperatureColor(28), AppColors.veryHot);
        expect(AppColors.getTemperatureColor(35), AppColors.veryHot);
      });

      test('should return hot for temperature 23-28', () {
        expect(AppColors.getTemperatureColor(23), AppColors.hot);
        expect(AppColors.getTemperatureColor(27), AppColors.hot);
      });

      test('should return comfortable for temperature 17-23', () {
        expect(AppColors.getTemperatureColor(17), AppColors.comfortable);
        expect(AppColors.getTemperatureColor(22), AppColors.comfortable);
      });

      test('should return cool for temperature 9-17', () {
        expect(AppColors.getTemperatureColor(9), AppColors.cool);
        expect(AppColors.getTemperatureColor(16), AppColors.cool);
      });

      test('should return cold for temperature 0-9', () {
        expect(AppColors.getTemperatureColor(0), AppColors.cold);
        expect(AppColors.getTemperatureColor(8), AppColors.cold);
      });

      test('should return veryCold for temperature < 0', () {
        expect(AppColors.getTemperatureColor(-1), AppColors.veryCold);
        expect(AppColors.getTemperatureColor(-10), AppColors.veryCold);
      });
    });

    group('getTemperatureBackground', () {
      test('should return veryHotBackground for temperature >= 28', () {
        expect(AppColors.getTemperatureBackground(28), AppColors.veryHotBackground);
        expect(AppColors.getTemperatureBackground(35), AppColors.veryHotBackground);
      });

      test('should return hotBackground for temperature 23-28', () {
        expect(AppColors.getTemperatureBackground(23), AppColors.hotBackground);
        expect(AppColors.getTemperatureBackground(27), AppColors.hotBackground);
      });

      test('should return comfortableBackground for temperature 17-23', () {
        expect(AppColors.getTemperatureBackground(17), AppColors.comfortableBackground);
        expect(AppColors.getTemperatureBackground(22), AppColors.comfortableBackground);
      });

      test('should return coolBackground for temperature 9-17', () {
        expect(AppColors.getTemperatureBackground(9), AppColors.coolBackground);
        expect(AppColors.getTemperatureBackground(16), AppColors.coolBackground);
      });

      test('should return coldBackground for temperature 0-9', () {
        expect(AppColors.getTemperatureBackground(0), AppColors.coldBackground);
        expect(AppColors.getTemperatureBackground(8), AppColors.coldBackground);
      });

      test('should return veryColdBackground for temperature < 0', () {
        expect(AppColors.getTemperatureBackground(-1), AppColors.veryColdBackground);
        expect(AppColors.getTemperatureBackground(-10), AppColors.veryColdBackground);
      });
    });

    group('getTemperatureGradient', () {
      test('should return warmGradient for temperature >= 23', () {
        expect(AppColors.getTemperatureGradient(23), AppColors.warmGradient);
        expect(AppColors.getTemperatureGradient(30), AppColors.warmGradient);
      });

      test('should return coolGradient for temperature < 23', () {
        expect(AppColors.getTemperatureGradient(22), AppColors.coolGradient);
        expect(AppColors.getTemperatureGradient(10), AppColors.coolGradient);
        expect(AppColors.getTemperatureGradient(-5), AppColors.coolGradient);
      });
    });

    group('getCategoryColor', () {
      test('should return correct color for index 0', () {
        expect(AppColors.getCategoryColor(0), AppColors.categoryColors[0]);
      });

      test('should return correct color for index 1', () {
        expect(AppColors.getCategoryColor(1), AppColors.categoryColors[1]);
      });

      test('should return correct color for index 2', () {
        expect(AppColors.getCategoryColor(2), AppColors.categoryColors[2]);
      });

      test('should return correct color for index 3', () {
        expect(AppColors.getCategoryColor(3), AppColors.categoryColors[3]);
      });

      test('should wrap around for index >= length', () {
        expect(AppColors.getCategoryColor(4), AppColors.categoryColors[0]);
        expect(AppColors.getCategoryColor(5), AppColors.categoryColors[1]);
        expect(AppColors.getCategoryColor(8), AppColors.categoryColors[0]);
      });
    });
  });

  group('ColorExtension', () {
    group('darken', () {
      test('should darken color by default amount 0.1', () {
        const originalColor = Color(0xFF0E8AE4);
        final darkenedColor = originalColor.darken();

        final originalHsl = HSLColor.fromColor(originalColor);
        final darkenedHsl = HSLColor.fromColor(darkenedColor);

        expect(darkenedHsl.lightness, lessThan(originalHsl.lightness));
      });

      test('should darken color by specified amount', () {
        const originalColor = Color(0xFF0E8AE4);
        final darkenedColor = originalColor.darken(0.2);

        final originalHsl = HSLColor.fromColor(originalColor);
        final darkenedHsl = HSLColor.fromColor(darkenedColor);

        expect(darkenedHsl.lightness, lessThan(originalHsl.lightness));
      });

      test('should clamp to 0 for extreme darken', () {
        const originalColor = Color(0xFF0E8AE4);
        final darkenedColor = originalColor.darken(1.0);

        final darkenedHsl = HSLColor.fromColor(darkenedColor);
        expect(darkenedHsl.lightness, 0.0);
      });
    });

    group('lighten', () {
      test('should lighten color by default amount 0.1', () {
        const originalColor = Color(0xFF0E8AE4);
        final lightenedColor = originalColor.lighten();

        final originalHsl = HSLColor.fromColor(originalColor);
        final lightenedHsl = HSLColor.fromColor(lightenedColor);

        expect(lightenedHsl.lightness, greaterThan(originalHsl.lightness));
      });

      test('should lighten color by specified amount', () {
        const originalColor = Color(0xFF0E8AE4);
        final lightenedColor = originalColor.lighten(0.2);

        final originalHsl = HSLColor.fromColor(originalColor);
        final lightenedHsl = HSLColor.fromColor(lightenedColor);

        expect(lightenedHsl.lightness, greaterThan(originalHsl.lightness));
      });

      test('should clamp to 1 for extreme lighten', () {
        const originalColor = Color(0xFF0E8AE4);
        final lightenedColor = originalColor.lighten(1.0);

        final lightenedHsl = HSLColor.fromColor(lightenedColor);
        expect(lightenedHsl.lightness, 1.0);
      });
    });
  });
}
