import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 텍스트 스타일
/// 강원교육 폰트 적용
///
/// 사용 예시:
/// Text('제목', style: AppTextSyles.headlineLarge)
/// Text('본문', style: AppTextSyles.bodyMedium)
class AppTextSyles {
  AppTextSyles._();

  // ========================================
  // Display (초대형 텍스트)
  // 용도: 메인 온도 표시, 큰 숫자
  // ========================================

  /// 80px - 메인 온도 표시
  static const displayLarge = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 80,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -2,
  );

  /// 64px - 큰 강조 텍스트
  static const displayMedium = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 64,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -1.5,
  );

  /// 48px - 중간 강조 텍스트
  static const displaySmall = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 1.1,
    letterSpacing: -1,
  );

  // ========================================
  // Headline (헤드라인)
  // 용도: 화면 제목, 섹션 제목
  // ========================================

  /// 32px - 화면 메인 타이틀 (예: '옷차림표')
  static const headlineLarge = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// 24px - 섹션 타이틀 (예: '추천 옷차림')
  static const headlineMedium = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// 20px - 작은 섹션 타이틀
  static const headlineSmall = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.2,
  );

  // ========================================
  // Title (타이틀)
  // 용도: 카드 제목, 리스트 항목 제목
  // ========================================

  /// 18px Bold - 카드 제목
  static const titleLarge = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.2,
  );

  /// 16px Bold - 작은 카드 제목
  static const titleMedium = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.1,
  );

  /// 14px Bold - 리스트 아이템 제목
  static const titleSmall = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  // ========================================
  // Body (본문)
  // 용도: 일반 텍스트, 설명문
  // ========================================

  /// 16px - 큰 본문 텍스트
  static const bodyLarge = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 14px - 일반 본문 텍스트 (가장 많이 사용)
  static const bodyMedium = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 12px - 작은 본문 텍스트, 캡션
  static const bodySmall = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ========================================
  // Label (라벨)
  // 용도: 버튼, 태그, 배지
  // ========================================

  /// 16px Bold - 큰 버튼 텍스트
  static const labelLarge = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// 14px Bold - 일반 버튼 텍스트
  static const labelMedium = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// 12px Bold - 작은 버튼, 태그 텍스트
  static const labelSmall = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // ========================================
  // 추가 유틸리티 스타일
  // ========================================

  /// 온보딩 메인 타이틀 (큰 제목)
  static const onboardingTitle = TextStyle(
    fontFamily: 'GangwonEduPower',
    fontSize: 40,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -1,
  );

  /// 온보딩 부제목
  static const onboardingSubtitle = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 버튼 내부 텍스트 (강조)
  static const button = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  /// 작은 정보 텍스트 (예: 업데이트 시간)
  static const caption = TextStyle(
    fontFamily: 'GangwonEduAll',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}

/// 폰트 관련 상수
class FontConstants {
  FontConstants._();

  // 폰트 패밀리 이름
  static const String powerFont = 'GangwonEduPower'; // 튼튼체
  static const String allFont = 'GangwonEduAll'; // 모두체

  // 폰트 웨이트
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;
}

/// 색상과 결합된 텍스트 스타일 헬퍼
///
/// 사용 예시:
/// Text('제목', style: AppTextSyles.headlineLarge.withColor(Colors.blue))
extension TextStyleExtension on TextStyle {
  /// 색상을 변경한 새로운 TextStyle 반환
  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }

  /// 투명도를 적용한 새로운 TextStyle 반환
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  /// 볼드체로 변경
  TextStyle toBold() {
    return copyWith(fontWeight: FontWeight.w700);
  }

  /// 라이트체로 변경
  TextStyle toLight() {
    return copyWith(fontWeight: FontWeight.w300);
  }
}
