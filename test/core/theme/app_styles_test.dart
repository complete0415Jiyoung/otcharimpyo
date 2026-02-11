import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/theme/app_styles.dart';

void main() {
  group('AppShadows', () {
    group('soft', () {
      test('should create soft shadow with default color', () {
        final shadow = AppShadows.soft();
        expect(shadow.blurRadius, 12);
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.color.opacity, closeTo(0.06, 0.01));
      });

      test('should create soft shadow with custom color', () {
        final shadow = AppShadows.soft(color: Colors.red);
        expect(shadow.blurRadius, 12);
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.color.red, greaterThan(0));
      });
    });

    group('medium', () {
      test('should create medium shadow with default color', () {
        final shadow = AppShadows.medium();
        expect(shadow.blurRadius, 16);
        expect(shadow.offset, const Offset(0, 6));
        expect(shadow.color.opacity, closeTo(0.08, 0.01));
      });

      test('should create medium shadow with custom color', () {
        final shadow = AppShadows.medium(color: Colors.blue);
        expect(shadow.blurRadius, 16);
        expect(shadow.color.blue, greaterThan(0));
      });
    });

    group('large', () {
      test('should create large shadow with default color', () {
        final shadow = AppShadows.large();
        expect(shadow.blurRadius, 24);
        expect(shadow.offset, const Offset(0, 8));
        expect(shadow.color.opacity, closeTo(0.10, 0.01));
      });

      test('should create large shadow with custom color', () {
        final shadow = AppShadows.large(color: Colors.green);
        expect(shadow.blurRadius, 24);
        expect(shadow.color.green, greaterThan(0));
      });
    });

    group('extraLarge', () {
      test('should create extraLarge shadow with default color', () {
        final shadow = AppShadows.extraLarge();
        expect(shadow.blurRadius, 32);
        expect(shadow.offset, const Offset(0, 12));
        expect(shadow.color.opacity, closeTo(0.12, 0.01));
      });

      test('should create extraLarge shadow with custom color', () {
        final shadow = AppShadows.extraLarge(color: Colors.purple);
        expect(shadow.blurRadius, 32);
      });
    });

    group('temperatureCard', () {
      test('should create temperature card shadow', () {
        final shadow = AppShadows.temperatureCard(Colors.orange);
        expect(shadow.blurRadius, 40);
        expect(shadow.offset, const Offset(0, 20));
        expect(shadow.color.opacity, closeTo(0.15, 0.01));
      });
    });

    group('gradientCard', () {
      test('should create gradient card shadow', () {
        final shadow = AppShadows.gradientCard(Colors.blue);
        expect(shadow.blurRadius, 16);
        expect(shadow.offset, const Offset(0, 8));
        expect(shadow.color.opacity, closeTo(0.2, 0.01));
      });
    });

    group('button', () {
      test('should create button shadow with default color', () {
        final shadow = AppShadows.button();
        expect(shadow.blurRadius, 8);
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.color.opacity, closeTo(0.15, 0.01));
      });

      test('should create button shadow with custom color', () {
        final shadow = AppShadows.button(color: Colors.red);
        expect(shadow.blurRadius, 8);
      });
    });

    group('floating', () {
      test('should create floating shadow with default color', () {
        final shadow = AppShadows.floating();
        expect(shadow.blurRadius, 20);
        expect(shadow.offset, const Offset(0, 10));
        expect(shadow.color.opacity, closeTo(0.2, 0.01));
      });

      test('should create floating shadow with custom color', () {
        final shadow = AppShadows.floating(color: Colors.teal);
        expect(shadow.blurRadius, 20);
      });
    });
  });

  group('AppRadius', () {
    group('Constants', () {
      test('should have correct radius values', () {
        expect(AppRadius.xxSmall, 4.0);
        expect(AppRadius.xSmall, 8.0);
        expect(AppRadius.small, 12.0);
        expect(AppRadius.medium, 16.0);
        expect(AppRadius.large, 20.0);
        expect(AppRadius.xLarge, 24.0);
        expect(AppRadius.xxLarge, 32.0);
      });
    });

    group('BorderRadius objects', () {
      test('should create correct xxSmallRadius', () {
        expect(AppRadius.xxSmallRadius, BorderRadius.circular(4.0));
      });

      test('should create correct xSmallRadius', () {
        expect(AppRadius.xSmallRadius, BorderRadius.circular(8.0));
      });

      test('should create correct smallRadius', () {
        expect(AppRadius.smallRadius, BorderRadius.circular(12.0));
      });

      test('should create correct mediumRadius', () {
        expect(AppRadius.mediumRadius, BorderRadius.circular(16.0));
      });

      test('should create correct largeRadius', () {
        expect(AppRadius.largeRadius, BorderRadius.circular(20.0));
      });

      test('should create correct xLargeRadius', () {
        expect(AppRadius.xLargeRadius, BorderRadius.circular(24.0));
      });

      test('should create correct xxLargeRadius', () {
        expect(AppRadius.xxLargeRadius, BorderRadius.circular(32.0));
      });
    });

    group('Helper methods', () {
      test('circular should create BorderRadius with given value', () {
        expect(AppRadius.circular(10.0), BorderRadius.circular(10.0));
        expect(AppRadius.circular(50.0), BorderRadius.circular(50.0));
      });

      test('circle should create fully circular BorderRadius', () {
        expect(AppRadius.circle, BorderRadius.circular(9999));
      });
    });
  });

  group('AppSpacing', () {
    group('Constants', () {
      test('should have correct spacing values', () {
        expect(AppSpacing.xxSmall, 4.0);
        expect(AppSpacing.xSmall, 8.0);
        expect(AppSpacing.small, 12.0);
        expect(AppSpacing.medium, 16.0);
        expect(AppSpacing.large, 24.0);
        expect(AppSpacing.xLarge, 32.0);
        expect(AppSpacing.xxLarge, 40.0);
        expect(AppSpacing.xxxLarge, 48.0);
        expect(AppSpacing.huge, 64.0);
      });
    });

    group('EdgeInsets All', () {
      test('should create correct EdgeInsets for all directions', () {
        expect(AppSpacing.xxSmallAll, const EdgeInsets.all(4.0));
        expect(AppSpacing.xSmallAll, const EdgeInsets.all(8.0));
        expect(AppSpacing.smallAll, const EdgeInsets.all(12.0));
        expect(AppSpacing.mediumAll, const EdgeInsets.all(16.0));
        expect(AppSpacing.largeAll, const EdgeInsets.all(24.0));
        expect(AppSpacing.xLargeAll, const EdgeInsets.all(32.0));
        expect(AppSpacing.xxLargeAll, const EdgeInsets.all(40.0));
      });
    });

    group('EdgeInsets Horizontal', () {
      test('should create correct EdgeInsets for horizontal', () {
        expect(AppSpacing.xxSmallHorizontal, const EdgeInsets.symmetric(horizontal: 4.0));
        expect(AppSpacing.xSmallHorizontal, const EdgeInsets.symmetric(horizontal: 8.0));
        expect(AppSpacing.smallHorizontal, const EdgeInsets.symmetric(horizontal: 12.0));
        expect(AppSpacing.mediumHorizontal, const EdgeInsets.symmetric(horizontal: 16.0));
        expect(AppSpacing.largeHorizontal, const EdgeInsets.symmetric(horizontal: 24.0));
        expect(AppSpacing.xLargeHorizontal, const EdgeInsets.symmetric(horizontal: 32.0));
      });
    });

    group('EdgeInsets Vertical', () {
      test('should create correct EdgeInsets for vertical', () {
        expect(AppSpacing.xxSmallVertical, const EdgeInsets.symmetric(vertical: 4.0));
        expect(AppSpacing.xSmallVertical, const EdgeInsets.symmetric(vertical: 8.0));
        expect(AppSpacing.smallVertical, const EdgeInsets.symmetric(vertical: 12.0));
        expect(AppSpacing.mediumVertical, const EdgeInsets.symmetric(vertical: 16.0));
        expect(AppSpacing.largeVertical, const EdgeInsets.symmetric(vertical: 24.0));
        expect(AppSpacing.xLargeVertical, const EdgeInsets.symmetric(vertical: 32.0));
      });
    });
  });

  group('AppDuration', () {
    test('should have correct instant duration', () {
      expect(AppDuration.instant, const Duration(milliseconds: 0));
    });

    test('should have correct fast duration', () {
      expect(AppDuration.fast, const Duration(milliseconds: 150));
    });

    test('should have correct normal duration', () {
      expect(AppDuration.normal, const Duration(milliseconds: 300));
    });

    test('should have correct slow duration', () {
      expect(AppDuration.slow, const Duration(milliseconds: 500));
    });

    test('should have correct verySlow duration', () {
      expect(AppDuration.verySlow, const Duration(milliseconds: 800));
    });
  });

  group('AppCurve', () {
    test('should have correct easeIn curve', () {
      expect(AppCurve.easeIn, Curves.easeIn);
    });

    test('should have correct easeOut curve', () {
      expect(AppCurve.easeOut, Curves.easeOut);
    });

    test('should have correct easeInOut curve', () {
      expect(AppCurve.easeInOut, Curves.easeInOut);
    });

    test('should have correct fastOutSlowIn curve', () {
      expect(AppCurve.fastOutSlowIn, Curves.fastOutSlowIn);
    });

    test('should have correct bounce curve', () {
      expect(AppCurve.bounce, Curves.bounceOut);
    });

    test('should have correct elastic curve', () {
      expect(AppCurve.elastic, Curves.elasticOut);
    });
  });

  group('AppBreakpoints', () {
    group('Constants', () {
      test('should have correct breakpoint values', () {
        expect(AppBreakpoints.mobile, 600);
        expect(AppBreakpoints.tablet, 900);
        expect(AppBreakpoints.desktop, 1200);
      });
    });

    group('isMobile', () {
      testWidgets('should return true for mobile width', (tester) async {
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isMobile = AppBreakpoints.isMobile(context);
                return Text(isMobile ? 'mobile' : 'not mobile');
              },
            ),
          ),
        );

        expect(find.text('mobile'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('should return false for tablet width', (tester) async {
        tester.view.physicalSize = const Size(700, 1000);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isMobile = AppBreakpoints.isMobile(context);
                return Text(isMobile ? 'mobile' : 'not mobile');
              },
            ),
          ),
        );

        expect(find.text('not mobile'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('isTablet', () {
      testWidgets('should return true for tablet width', (tester) async {
        tester.view.physicalSize = const Size(700, 1000);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isTablet = AppBreakpoints.isTablet(context);
                return Text(isTablet ? 'tablet' : 'not tablet');
              },
            ),
          ),
        );

        expect(find.text('tablet'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('should return false for mobile width', (tester) async {
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isTablet = AppBreakpoints.isTablet(context);
                return Text(isTablet ? 'tablet' : 'not tablet');
              },
            ),
          ),
        );

        expect(find.text('not tablet'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('isDesktop', () {
      testWidgets('should return true for desktop width', (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isDesktop = AppBreakpoints.isDesktop(context);
                return Text(isDesktop ? 'desktop' : 'not desktop');
              },
            ),
          ),
        );

        expect(find.text('desktop'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('should return false for tablet width', (tester) async {
        tester.view.physicalSize = const Size(900, 700);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final isDesktop = AppBreakpoints.isDesktop(context);
                return Text(isDesktop ? 'desktop' : 'not desktop');
              },
            ),
          ),
        );

        expect(find.text('not desktop'), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
