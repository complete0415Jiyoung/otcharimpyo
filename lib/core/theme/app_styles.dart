import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 컬러 팔레트
class AppColors {
  AppColors._();

  // ========== 온도별 그라데이션 컬러 ==========

  /// 매우 더움 (28°C 이상)
  static const veryHotGradient = [Color(0xFFFF6B6B), Color(0xFFFFB347)];

  /// 더움 (20-28°C)
  static const hotGradient = [Color(0xFFFFB347), Color(0xFFFFD93D)];

  /// 따뜻함 (9-20°C)
  static const warmGradient = [Color(0xFF6BCF7F), Color(0xFF4ECDC4)];

  /// 시원함 (0-9°C)
  static const coolGradient = [Color(0xFF4ECDC4), Color(0xFF4A90E2)];

  /// 추움 (0°C 이하)
  static const coldGradient = [Color(0xFF4A90E2), Color(0xFF7B68EE)];

  // ========== 카테고리별 그라데이션 컬러 ==========

  static const categoryGradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)], // 보라
    [Color(0xFFF093FB), Color(0xFFF5576C)], // 핑크
    [Color(0xFF4FACFE), Color(0xFF00F2FE)], // 파랑
    [Color(0xFFFA709A), Color(0xFFFEE140)], // 노랑
  ];

  // ========== 배경 컬러 ==========

  static const veryHotBackground = Color(0xFFFFF5E6);
  static const hotBackground = Color(0xFFFFF9F0);
  static const warmBackground = Color(0xFFF5F8FF);
  static const coolBackground = Color(0xFFEEF5FF);
  static const coldBackground = Color(0xFFE8F0F8);

  // ========== 기본 컬러 ==========

  static const primary = Color(0xFF4A90E2);
  static const secondary = Color(0xFF4ECDC4);
  static const error = Color(0xFFFF6B6B);
  static const success = Color(0xFF6BCF7F);
  static const warning = Color(0xFFFFB347);

  // ========== 텍스트 컬러 ==========

  static const textPrimary = Color(0xFF1E1B4B);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF94A3B8);
  static const textWhite = Colors.white;

  // ========== 온보딩 전용 컬러 ==========

  static const onboardingGradient = [Color(0xFF667EEA), Color(0xFF764BA2)];

  static const onboardingAccent = Color(0xFF667EEA);

  // ========== 헬퍼 함수 ==========

  /// 온도에 따른 그라데이션 컬러 반환
  static List<Color> getTemperatureGradient(double temperature) {
    if (temperature >= 28) return veryHotGradient;
    if (temperature >= 20) return hotGradient;
    if (temperature >= 9) return warmGradient;
    if (temperature >= 0) return coolGradient;
    return coldGradient;
  }

  /// 온도에 따른 배경 컬러 반환
  static Color getTemperatureBackground(double temperature) {
    if (temperature >= 28) return veryHotBackground;
    if (temperature >= 20) return hotBackground;
    if (temperature >= 9) return warmBackground;
    if (temperature >= 0) return coolBackground;
    return coldBackground;
  }

  /// 온도에 따른 액센트 컬러 반환
  static Color getTemperatureAccent(double temperature) {
    return getTemperatureGradient(temperature)[0];
  }

  /// 카테고리 인덱스에 따른 그라데이션 컬러 반환
  static List<Color> getCategoryGradient(int index) {
    return categoryGradients[index % categoryGradients.length];
  }
}

/// 앱 전체에서 사용하는 텍스트 스타일
class AppTextStyles {
  AppTextStyles._();

  // ========== Display (큰 제목) ==========

  static const displayLarge = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w900,
    height: 0.9,
    letterSpacing: -3,
  );

  static const displayMedium = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 0.9,
    letterSpacing: -2,
  );

  static const displaySmall = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -1.5,
  );

  // ========== Headline (헤드라인) ==========

  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -1,
  );

  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  // ========== Title (타이틀) ==========

  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  // ========== Body (본문) ==========

  static const bodyLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const bodySmall = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

  // ========== Label (라벨) ==========

  static const labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

/// 앱 전체에서 사용하는 그림자 스타일
class AppShadows {
  AppShadows._();

  static BoxShadow small({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.04),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow medium({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.08),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static BoxShadow large({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.12),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  static BoxShadow extraLarge({Color? color}) => BoxShadow(
    color: (color ?? Colors.black).withOpacity(0.15),
    blurRadius: 40,
    offset: const Offset(0, 20),
  );

  /// 온도 카드 전용 그림자
  static BoxShadow temperatureCard(Color accentColor) => BoxShadow(
    color: accentColor.withOpacity(0.15),
    blurRadius: 40,
    offset: const Offset(0, 20),
  );

  /// 그라데이션 카드 그림자
  static BoxShadow gradientCard(Color accentColor) => BoxShadow(
    color: accentColor.withOpacity(0.3),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );
}

/// 앱 전체에서 사용하는 Border Radius
class AppRadius {
  AppRadius._();

  static const small = 12.0;
  static const medium = 16.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const xxLarge = 32.0;

  static BorderRadius smallRadius = BorderRadius.circular(small);
  static BorderRadius mediumRadius = BorderRadius.circular(medium);
  static BorderRadius largeRadius = BorderRadius.circular(large);
  static BorderRadius extraLargeRadius = BorderRadius.circular(extraLarge);
  static BorderRadius xxLargeRadius = BorderRadius.circular(xxLarge);
}

/// 앱 전체에서 사용하는 간격
class AppSpacing {
  AppSpacing._();

  static const xxSmall = 4.0;
  static const xSmall = 8.0;
  static const small = 12.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const xLarge = 32.0;
  static const xxLarge = 40.0;
  static const xxxLarge = 48.0;
}
