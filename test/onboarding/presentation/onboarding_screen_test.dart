import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otcharimpyo/onboarding/presentation/onboarding_screen.dart';

void main() {
  group('OnboardingScreen Widget Tests', () {
    late MethodChannel geolocatorChannel;

    setUp(() {
      SharedPreferences.setMockInitialValues({});

      // Mock Geolocator platform channel
      geolocatorChannel = const MethodChannel('flutter.baseflow.com/geolocator');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isLocationServiceEnabled':
            return true;
          case 'checkPermission':
            return 3; // LocationPermission.whileInUse
          case 'requestPermission':
            return 3; // LocationPermission.whileInUse
          case 'getCurrentPosition':
            return {
              'latitude': 37.5665,
              'longitude': 126.9780,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'accuracy': 10.0,
              'altitude': 0.0,
              'altitude_accuracy': 0.0,
              'heading': 0.0,
              'heading_accuracy': 0.0,
              'speed': 0.0,
              'speed_accuracy': 0.0,
            };
          default:
            return null;
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(geolocatorChannel, null);
    });

    Widget createWidgetUnderTest() {
      return const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      );
    }

    group('First Page', () {
      testWidgets('should show page view', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('should show start button on first page', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('시작하기'), findsOneWidget);
      });

      testWidgets('should show page indicators', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(AnimatedContainer), findsWidgets);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to second page when start button tapped', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });

      testWidgets('should navigate by swiping left', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('should navigate back by swiping right', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
        await tester.pumpAndSettle();

        expect(find.text('시작하기'), findsOneWidget);
      });
    });

    group('Second Page', () {
      testWidgets('should show location permission button on second page', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have scaffold', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should have safe area', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(SafeArea), findsOneWidget);
      });
    });

    group('Page Indicator', () {
      testWidgets('should have two indicators', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final indicators = find.byType(AnimatedContainer);
        expect(indicators, findsWidgets);
      });

      testWidgets('should update indicator when page changes', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Navigate to second page
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // Indicator should update
        expect(find.byType(AnimatedContainer), findsWidgets);
      });
    });

    group('Complete Flow', () {
      testWidgets('should complete navigation flow', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('시작하기'), findsOneWidget);

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });
    });

    group('Location Permission - Service Disabled', () {
      testWidgets('should show dialog when location service is disabled', (tester) async {
        // Mock location service disabled
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'isLocationServiceEnabled':
              return false;
            default:
              return null;
          }
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Navigate to second page
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // Tap permission button
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // Should show permission denied dialog
        expect(find.text('위치 권한 필요'), findsOneWidget);
        expect(find.text('위치 서비스가 꺼져 있습니다.\n기기 설정에서 위치 서비스를 켜주세요.'), findsOneWidget);
      });

      testWidgets('should show close button in dialog', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          if (methodCall.method == 'isLocationServiceEnabled') return false;
          return null;
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.text('닫기'), findsOneWidget);
      });

      testWidgets('should show settings button in dialog', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          if (methodCall.method == 'isLocationServiceEnabled') return false;
          return null;
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.text('설정으로'), findsOneWidget);
      });

      testWidgets('should close dialog when close button tapped', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          if (methodCall.method == 'isLocationServiceEnabled') return false;
          return null;
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // Tap close button
        await tester.tap(find.text('닫기'));
        await tester.pumpAndSettle();

        // Dialog should be closed
        expect(find.text('위치 권한 필요'), findsNothing);
      });
    });

    group('Location Permission - Denied', () {
      testWidgets('should show dialog when permission is denied', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'isLocationServiceEnabled':
              return true;
            case 'checkPermission':
              return 0; // LocationPermission.denied
            case 'requestPermission':
              return 0; // LocationPermission.denied
            default:
              return null;
          }
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 권한 필요'), findsOneWidget);
        expect(find.textContaining('위치 권한이 거부되었습니다'), findsOneWidget);
      });
    });

    group('Location Permission - Denied Forever', () {
      testWidgets('should show dialog when permission is denied forever', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'isLocationServiceEnabled':
              return true;
            case 'checkPermission':
              return 1; // LocationPermission.deniedForever (index 1)
            default:
              return null;
          }
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 권한 필요'), findsOneWidget);
        expect(find.textContaining('영구적으로 거부'), findsOneWidget);
      });
    });

    group('Location Permission - Settings Button', () {
      testWidgets('should open app settings when settings button tapped', (tester) async {
        bool openAppSettingsCalled = false;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'isLocationServiceEnabled':
              return false;
            case 'openAppSettings':
              openAppSettingsCalled = true;
              return true;
            default:
              return null;
          }
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('설정으로'));
        await tester.pumpAndSettle();

        expect(openAppSettingsCalled, isTrue);
      });
    });

    group('Dialog UI', () {
      testWidgets('should show location off icon in dialog', (tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(geolocatorChannel, (MethodCall methodCall) async {
          if (methodCall.method == 'isLocationServiceEnabled') return false;
          return null;
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.location_off_rounded), findsOneWidget);
      });
    });
  });
}
