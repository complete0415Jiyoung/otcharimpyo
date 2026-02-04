import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 컬러 팔레트
/// 파스텔 블루 톤의 미니멀 디자인
class AppColors {
  AppColors._();

  // ========================================
  // 기본 컬러 (Primary Colors)
  // ========================================

  /// 메인 블루 - 주요 액션, 강조
  static const primary = Color(0xFF0E8AE4);

  /// 다크 그레이 - 메인 텍스트, 헤더
  static const darkGray = Color(0xFF494A4B);

  /// 미디엄 그레이 - 보조 텍스트
  static const mediumGray = Color(0xFF8E8E8E);

  /// 라이트 그레이 - 비활성 요소
  static const lightGray = Color(0xFFBEBEBE);

  /// 배경 그레이 - 서브 배경
  static const backgroundGray = Color(0xFF383838);

  /// 순수 화이트
  static const white = Color(0xFFFFFFFF);

  /// 순수 블랙
  static const black = Color(0xFF000000);

  // ========================================
  // 악센트 컬러 (Accent Colors)
  // ========================================

  /// 노란색 - 경고, 하이라이트
  static const yellow = Color(0xFFF8E36F);

  /// 오렌지 - 따뜻한 강조
  static const orange = Color(0xFFFA9E42);

  // ========================================
  // 텍스트 컬러 (Text Colors)
  // ========================================

  /// 주요 텍스트 (최고 대비)
  static const textPrimary = darkGray; // #494A4B

  /// 보조 텍스트
  static const textSecondary = mediumGray; // #8E8E8E

  /// 비활성/힌트 텍스트
  static const textTertiary = lightGray; // #BEBEBE

  /// 반전 텍스트 (어두운 배경 위)
  static const textInverse = white;

  // ========================================
  // 배경 컬러 (Background Colors)
  // ========================================

  /// 메인 배경
  static const background = white;

  /// 서브 배경 (카드 등)
  static const backgroundSecondary = Color(0xFFF5F5F5);

  /// 다크 배경
  static const backgroundDark = backgroundGray;

  // ========================================
  // 상태 컬러 (State Colors)
  // ========================================

  /// 에러
  static const error = Color(0xFFEF4444);

  /// 성공
  static const success = Color(0xFF10B981);

  /// 경고
  static const warning = yellow;

  /// 정보
  static const info = primary;

  // ========================================
  // 투명도 적용 컬러
  // ========================================

  /// 블랙 70% (오버레이)
  static final blackOverlay70 = black.withOpacity(0.7);

  /// 블랙 40% (반투명 오버레이)
  static final blackOverlay40 = black.withOpacity(0.4);

  /// 화이트 65% (밝은 오버레이)
  static final whiteOverlay65 = white.withOpacity(0.65);

  /// 화이트 81% (매우 밝은 오버레이)
  static final whiteOverlay81 = white.withOpacity(0.81);

  /// 블루 22% (서브틀한 하이라이트)
  static final blueOverlay22 = primary.withOpacity(0.22);

  // ========================================
  // 온도별 컬러 (Temperature Colors)
  // ========================================

  /// 매우 더움 (28°C 이상) - 오렌지 톤
  static const veryHot = orange; // #FA9E42

  /// 더움 (23-28°C) - 노란색 톤
  static const hot = yellow; // #F8E36F

  /// 쾌적 (17-23°C) - 블루 톤
  static const comfortable = primary; // #0E8AE4

  /// 시원함 (9-17°C) - 밝은 블루
  static const cool = Color(0xFF5BA8E4);

  /// 추움 (0-9°C) - 진한 블루
  static const cold = Color(0xFF2E5F8E);

  /// 매우 추움 (0°C 이하) - 다크 블루
  static const veryCold = Color(0xFF1E3A5F);

  // ========================================
  // 온도별 배경 컬러 (Temperature Backgrounds)
  // ========================================

  static const veryHotBackground = Color(0xFFFFF5E6);
  static const hotBackground = Color(0xFFFFFBEA);
  static const comfortableBackground = Color(0xFFE8F4FB);
  static const coolBackground = Color(0xFFE1F0FA);
  static const coldBackground = Color(0xFFD6E9F7);
  static const veryColdBackground = Color(0xFFCEE3F4);

  // ========================================
  // 그라데이션 (Gradients)
  // ========================================

  /// 메인 블루 그라데이션
  static const primaryGradient = [Color(0xFF0E8AE4), Color(0xFF5BA8E4)];

  /// 따뜻한 그라데이션 (오렌지-노랑)
  static const warmGradient = [Color(0xFFFA9E42), Color(0xFFF8E36F)];

  /// 시원한 그라데이션 (블루 계열)
  static const coolGradient = [Color(0xFF0E8AE4), Color(0xFF2E5F8E)];

  // ========================================
  // 카테고리별 컬러 (Category Colors)
  // ========================================

  static const categoryColors = [
    Color(0xFF0E8AE4), // 블루
    Color(0xFFF8E36F), // 노란색
    Color(0xFFFA9E42), // 오렌지
    Color(0xFF10B981), // 초록
  ];

  // ========================================
  // 헬퍼 함수 (Helper Functions)
  // ========================================

  /// 온도에 따른 컬러 반환
  static Color getTemperatureColor(double temperature) {
    if (temperature >= 28) return veryHot;
    if (temperature >= 23) return hot;
    if (temperature >= 17) return comfortable;
    if (temperature >= 9) return cool;
    if (temperature >= 0) return cold;
    return veryCold;
  }

  /// 온도에 따른 배경 컬러 반환
  static Color getTemperatureBackground(double temperature) {
    if (temperature >= 28) return veryHotBackground;
    if (temperature >= 23) return hotBackground;
    if (temperature >= 17) return comfortableBackground;
    if (temperature >= 9) return coolBackground;
    if (temperature >= 0) return coldBackground;
    return veryColdBackground;
  }

  /// 온도에 따른 그라데이션 반환
  static List<Color> getTemperatureGradient(double temperature) {
    if (temperature >= 23) return warmGradient;
    return coolGradient;
  }

  /// 카테고리 인덱스에 따른 컬러 반환
  static Color getCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }
}

/// 컬러 확장 함수
extension ColorExtension on Color {
  /// 밝기 조절 (0.0 ~ 1.0)
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// 밝게 조절 (0.0 ~ 1.0)
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
