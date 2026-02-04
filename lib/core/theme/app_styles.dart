import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 그림자 스타일
/// 부드럽고 미묘한 그림자 효과
class AppShadows {
  AppShadows._();

  /// 부드러운 그림자 (Small)
  static BoxShadow soft({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  /// 중간 그림자 (Medium)
  static BoxShadow medium({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.08),
    blurRadius: 16,
    offset: const Offset(0, 6),
  );

  /// 큰 그림자 (Large)
  static BoxShadow large({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.10),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  /// 매우 큰 그림자 (Extra Large)
  static BoxShadow extraLarge({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.12),
    blurRadius: 32,
    offset: const Offset(0, 12),
  );

  /// 온도 카드 전용 그림자
  static BoxShadow temperatureCard(Color accentColor) => BoxShadow(
    color: accentColor.withOpacity(0.15),
    blurRadius: 40,
    offset: const Offset(0, 20),
  );

  /// 그라데이션 카드 그림자
  static BoxShadow gradientCard(Color accentColor) => BoxShadow(
    color: accentColor.withOpacity(0.2),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );

  /// 버튼 그림자
  static BoxShadow button({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.15),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );

  /// 떠있는 요소 그림자 (Floating)
  static BoxShadow floating({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.2),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

/// 앱 전체에서 사용하는 Border Radius
class AppRadius {
  AppRadius._();

  // 수치 상수
  static const double xxSmall = 4.0;
  static const double xSmall = 8.0;
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double xLarge = 24.0;
  static const double xxLarge = 32.0;

  // BorderRadius 객체
  static BorderRadius xxSmallRadius = BorderRadius.circular(xxSmall);
  static BorderRadius xSmallRadius = BorderRadius.circular(xSmall);
  static BorderRadius smallRadius = BorderRadius.circular(small);
  static BorderRadius mediumRadius = BorderRadius.circular(medium);
  static BorderRadius largeRadius = BorderRadius.circular(large);
  static BorderRadius xLargeRadius = BorderRadius.circular(xLarge);
  static BorderRadius xxLargeRadius = BorderRadius.circular(xxLarge);

  // 원형
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  // 완전한 원 (9999)
  static BorderRadius get circle => BorderRadius.circular(9999);
}

/// 앱 전체에서 사용하는 간격 (Spacing)
class AppSpacing {
  AppSpacing._();

  static const double xxSmall = 4.0;
  static const double xSmall = 8.0;
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
  static const double xxLarge = 40.0;
  static const double xxxLarge = 48.0;
  static const double huge = 64.0;

  // EdgeInsets 헬퍼
  static EdgeInsets get xxSmallAll => const EdgeInsets.all(xxSmall);
  static EdgeInsets get xSmallAll => const EdgeInsets.all(xSmall);
  static EdgeInsets get smallAll => const EdgeInsets.all(small);
  static EdgeInsets get mediumAll => const EdgeInsets.all(medium);
  static EdgeInsets get largeAll => const EdgeInsets.all(large);
  static EdgeInsets get xLargeAll => const EdgeInsets.all(xLarge);
  static EdgeInsets get xxLargeAll => const EdgeInsets.all(xxLarge);

  // Horizontal
  static EdgeInsets get xxSmallHorizontal =>
      const EdgeInsets.symmetric(horizontal: xxSmall);
  static EdgeInsets get xSmallHorizontal =>
      const EdgeInsets.symmetric(horizontal: xSmall);
  static EdgeInsets get smallHorizontal =>
      const EdgeInsets.symmetric(horizontal: small);
  static EdgeInsets get mediumHorizontal =>
      const EdgeInsets.symmetric(horizontal: medium);
  static EdgeInsets get largeHorizontal =>
      const EdgeInsets.symmetric(horizontal: large);
  static EdgeInsets get xLargeHorizontal =>
      const EdgeInsets.symmetric(horizontal: xLarge);

  // Vertical
  static EdgeInsets get xxSmallVertical =>
      const EdgeInsets.symmetric(vertical: xxSmall);
  static EdgeInsets get xSmallVertical =>
      const EdgeInsets.symmetric(vertical: xSmall);
  static EdgeInsets get smallVertical =>
      const EdgeInsets.symmetric(vertical: small);
  static EdgeInsets get mediumVertical =>
      const EdgeInsets.symmetric(vertical: medium);
  static EdgeInsets get largeVertical =>
      const EdgeInsets.symmetric(vertical: large);
  static EdgeInsets get xLargeVertical =>
      const EdgeInsets.symmetric(vertical: xLarge);
}

/// 앱 전체에서 사용하는 Duration
class AppDuration {
  AppDuration._();

  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}

/// 앱 전체에서 사용하는 Curve
class AppCurve {
  AppCurve._();

  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
}

/// 반응형 레이아웃 브레이크포인트
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  /// 현재 화면 크기가 모바일인지 확인
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  /// 현재 화면 크기가 태블릿인지 확인
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  /// 현재 화면 크기가 데스크탑인지 확인
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}
