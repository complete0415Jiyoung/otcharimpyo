import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/presentation/outfit_screen.dart';
import 'package:otcharimpyo/weather/presentation/outfit_state.dart';
import 'package:otcharimpyo/weather/presentation/outfit_action.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';

void main() {
  group('OutfitScreen Widget Tests', () {
    late List<OutfitAction> capturedActions;

    setUp(() {
      capturedActions = [];
    });

    Widget createWidgetUnderTest({required OutfitState state}) {
      return MaterialApp(
        home: OutfitScreen(
          state: state,
          onAction: (action) => capturedActions.add(action),
        ),
      );
    }

    group('Loading State', () {
      testWidgets('should show loading indicator when loading', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.loading,
          ),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should show loading text', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.loading,
          ),
        ));

        expect(find.text('날씨 정보를 불러오는 중...'), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets('should show error icon when error', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.error,
            errorMessage: '네트워크 오류가 발생했습니다',
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      });

      testWidgets('should show error message when error', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.error,
            errorMessage: '네트워크 오류가 발생했습니다',
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.text('네트워크 오류가 발생했습니다'), findsOneWidget);
      });

      testWidgets('should show retry button when error', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.error,
            errorMessage: '오류 발생',
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.text('다시 시도하기'), findsOneWidget);
      });

      testWidgets('should call onAction when retry button tapped', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.error,
            errorMessage: '오류 발생',
          ),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('다시 시도하기'));
        await tester.pumpAndSettle();

        expect(capturedActions, contains(const OnRefreshOutfit()));
      });
    });

    group('Success State', () {
      final successState = OutfitState(
        loadingStatus: WeatherLoadingStatus.success,
        temperature: 22.0,
        feelsLike: 23.0,
        humidity: 55,
        weatherDescription: '맑음',
        location: '서울특별시 중구 명동',
        lastUpdated: DateTime.now(),
        tops: const [
          OutfitItem(name: '긴팔티', category: OutfitCategory.top),
        ],
        bottoms: const [
          OutfitItem(name: '청바지', category: OutfitCategory.bottom),
        ],
        outers: const [
          OutfitItem(name: '얇은 카디건', category: OutfitCategory.outer),
        ],
        accessories: const [],
      );

      testWidgets('should show temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.textContaining('22'), findsWidgets);
      });

      testWidgets('should show location', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.textContaining('서울특별시'), findsOneWidget);
      });

      testWidgets('should show date', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        // 날짜 형식이 표시되어야 함
        expect(find.textContaining('월'), findsWidgets);
      });

      testWidgets('should show outfit recommendation title', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.text('오늘의 추천 옷차림'), findsOneWidget);
      });

      testWidgets('should show tops category', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.text('상의'), findsOneWidget);
      });

      testWidgets('should show bottoms category', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.text('하의'), findsOneWidget);
      });

      testWidgets('should show outfit items', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.text('긴팔티'), findsOneWidget);
        expect(find.text('청바지'), findsOneWidget);
      });

      testWidgets('should have RefreshIndicator', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('should show search button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('should show feels like temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.textContaining('체감'), findsOneWidget);
      });

      testWidgets('should show humidity', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.textContaining('습도'), findsOneWidget);
      });

      testWidgets('should show outer category when has outers', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: successState));
        await tester.pumpAndSettle();

        expect(find.text('아우터'), findsOneWidget);
      });
    });

    group('Hot Weather State', () {
      final hotState = OutfitState(
        loadingStatus: WeatherLoadingStatus.success,
        temperature: 32.0,
        feelsLike: 35.0,
        humidity: 70,
        weatherDescription: '맑음',
        location: '서울특별시',
        lastUpdated: DateTime.now(),
        tops: const [
          OutfitItem(name: '민소매', category: OutfitCategory.top),
          OutfitItem(name: '반팔', category: OutfitCategory.top),
        ],
        bottoms: const [
          OutfitItem(name: '반바지', category: OutfitCategory.bottom),
        ],
        outers: const [],
        accessories: const [],
      );

      testWidgets('should show hot weather outfit', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: hotState));
        await tester.pumpAndSettle();

        expect(find.text('민소매'), findsOneWidget);
        expect(find.text('반팔'), findsOneWidget);
      });

      testWidgets('should show high temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: hotState));
        await tester.pumpAndSettle();

        expect(find.textContaining('32'), findsWidgets);
      });

      testWidgets('should not show outer category when no outers', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: hotState));
        await tester.pumpAndSettle();

        expect(find.text('아우터'), findsNothing);
      });
    });

    group('Cold Weather State', () {
      final coldState = OutfitState(
        loadingStatus: WeatherLoadingStatus.success,
        temperature: 2.0,
        feelsLike: -2.0,
        humidity: 40,
        weatherDescription: '눈',
        location: '서울특별시',
        lastUpdated: DateTime.now(),
        tops: const [
          OutfitItem(name: '기모 제품', category: OutfitCategory.top),
        ],
        bottoms: const [
          OutfitItem(name: '기모 제품', category: OutfitCategory.bottom),
        ],
        outers: const [
          OutfitItem(name: '패딩', category: OutfitCategory.outer),
        ],
        accessories: const [
          OutfitItem(name: '목도리', category: OutfitCategory.accessory),
        ],
      );

      testWidgets('should show cold weather outfit', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: coldState));
        await tester.pumpAndSettle();

        expect(find.text('패딩'), findsOneWidget);
        expect(find.text('목도리'), findsOneWidget);
      });

      testWidgets('should show outer category when has outers', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: coldState));
        await tester.pumpAndSettle();

        expect(find.text('아우터'), findsOneWidget);
      });

      testWidgets('should show accessory category when has accessories', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: coldState));
        await tester.pumpAndSettle();

        expect(find.text('액세서리'), findsOneWidget);
      });

      testWidgets('should show low temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(state: coldState));
        await tester.pumpAndSettle();

        expect(find.textContaining('2'), findsWidgets);
      });
    });

    group('Initial State', () {
      testWidgets('should show success view for initial state', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: const OutfitState(
            loadingStatus: WeatherLoadingStatus.initial,
            location: '서울특별시',
          ),
        ));
        await tester.pumpAndSettle();

        // initial 상태는 success 뷰를 보여줌
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.textContaining('서울특별시'), findsOneWidget);
      });
    });

    group('Search Button', () {
      testWidgets('should have search button in success state', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: OutfitState(
            loadingStatus: WeatherLoadingStatus.success,
            temperature: 22.0,
            location: '서울특별시',
            lastUpdated: DateTime.now(),
            tops: const [],
            bottoms: const [],
            outers: const [],
            accessories: const [],
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('Greeting', () {
      testWidgets('should show greeting message', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(
          state: OutfitState(
            loadingStatus: WeatherLoadingStatus.success,
            temperature: 22.0,
            location: '서울특별시',
            lastUpdated: DateTime.now(),
            tops: const [],
            bottoms: const [],
            outers: const [],
            accessories: const [],
          ),
        ));
        await tester.pumpAndSettle();

        // 시간대에 따라 다른 인사말이 표시됨
        final hour = DateTime.now().hour;
        if (hour < 12) {
          expect(find.text('좋은 아침입니다!'), findsOneWidget);
        } else if (hour < 18) {
          expect(find.text('좋은 오후입니다!'), findsOneWidget);
        } else {
          expect(find.text('좋은 저녁입니다!'), findsOneWidget);
        }
      });
    });
  });
}
