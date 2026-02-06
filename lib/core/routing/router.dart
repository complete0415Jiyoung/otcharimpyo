import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../onboarding/presentation/onboarding_screen.dart';
import '../../weather/presentation/outfit_screen_root.dart';
import '../../weather/presentation/temperature_search_screen.dart';

import 'routes.dart';

/// 앱의 라우팅을 관리하는 GoRouter 인스턴스를 생성합니다.
///
/// [initialLocation] - 앱 시작 시 표시할 초기 화면 경로
class AppRouter {
  AppRouter._(); // private 생성자

  /// GoRouter 인스턴스 생성
  ///
  /// [onboardingComplete] - 온보딩 완료 여부
  static GoRouter createRouter({bool onboardingComplete = false}) {
    return GoRouter(
      // ========================================
      // 초기 라우트 설정
      // ========================================
      initialLocation: onboardingComplete ? Routes.home : Routes.onboarding,

      // ========================================
      // 에러 화면 설정
      // ========================================
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),

      // ========================================
      // 라우트 정의
      // ========================================
      routes: [
        // 온보딩 화면
        GoRoute(
          path: Routes.onboarding,
          name: Routes.onboardingName,
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const OnboardingScreen(),
          ),
        ),

        // 홈 화면 (옷차림 추천)
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const OutfitScreenRoot(),
          ),
        ),

        // 온도 검색 화면
        GoRoute(
          path: Routes.temperatureSearch,
          name: Routes.temperatureSearchName,
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const TemperatureSearchScreen(),
          ),
        ),
      ],

      // ========================================
      // 리다이렉트 설정
      // ========================================
      redirect: (context, state) {
        return null; // 리다이렉트 없음
      },

      // ========================================
      // 디버그 로그
      // ========================================
      debugLogDiagnostics: true,
    );
  }

  /// 기본 페이지 전환 애니메이션을 가진 페이지 빌더
  static Page<dynamic> _buildPageWithDefaultTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade + Slide 전환 효과
        const begin = Offset(0.0, 0.03);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        var fadeAnimation = animation.drive(
          Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }
}

// ========================================
// 에러 화면
// ========================================

class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오류'), backgroundColor: Colors.red),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                '페이지를 찾을 수 없습니다',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (error != null)
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go(Routes.home),
                icon: const Icon(Icons.home),
                label: const Text('홈으로 돌아가기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
