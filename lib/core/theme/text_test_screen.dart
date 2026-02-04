import 'package:flutter/material.dart';
import 'app_text_styles.dart';

/// 폰트 테스트 스크린
/// 모든 텍스트 스타일을 확인할 수 있는 화면
class TextTestScreen extends StatelessWidget {
  const TextTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      appBar: AppBar(
        title: const Text('폰트 테스트'),
        backgroundColor: const Color(0xFF5B8FB9),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 섹션: Display
              _buildSection(
                title: 'Display (초대형 텍스트)',
                children: [
                  _buildTextItem(
                    '8°C',
                    AppTextSyles.displayLarge,
                    'displayLarge (80px)',
                  ),
                  const SizedBox(height: 16),
                  _buildTextItem(
                    '온도 표시',
                    AppTextSyles.displayMedium,
                    'displayMedium (64px)',
                  ),
                  const SizedBox(height: 16),
                  _buildTextItem(
                    '큰 제목',
                    AppTextSyles.displaySmall,
                    'displaySmall (48px)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: Headline
              _buildSection(
                title: 'Headline (헤드라인)',
                children: [
                  _buildTextItem(
                    '옷차림표',
                    AppTextSyles.headlineLarge,
                    'headlineLarge (32px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '추천 옷차림',
                    AppTextSyles.headlineMedium,
                    'headlineMedium (24px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '작은 섹션 제목',
                    AppTextSyles.headlineSmall,
                    'headlineSmall (20px)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: Title
              _buildSection(
                title: 'Title (타이틀)',
                children: [
                  _buildTextItem(
                    '카드 제목',
                    AppTextSyles.titleLarge,
                    'titleLarge (18px Bold)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '작은 카드 제목',
                    AppTextSyles.titleMedium,
                    'titleMedium (16px Bold)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '리스트 아이템 제목',
                    AppTextSyles.titleSmall,
                    'titleSmall (14px Bold)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: Body
              _buildSection(
                title: 'Body (본문)',
                children: [
                  _buildTextItem(
                    '큰 본문 텍스트입니다. 강원교육모두체로 표시됩니다.',
                    AppTextSyles.bodyLarge,
                    'bodyLarge (16px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '일반 본문 텍스트입니다. 가장 많이 사용되는 스타일입니다.',
                    AppTextSyles.bodyMedium,
                    'bodyMedium (14px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '작은 본문 텍스트와 캡션에 사용됩니다.',
                    AppTextSyles.bodySmall,
                    'bodySmall (12px)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: Label
              _buildSection(
                title: 'Label (라벨/버튼)',
                children: [
                  _buildTextItem(
                    '큰 버튼 텍스트',
                    AppTextSyles.labelLarge,
                    'labelLarge (16px Bold)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '일반 버튼 텍스트',
                    AppTextSyles.labelMedium,
                    'labelMedium (14px Bold)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '작은 버튼',
                    AppTextSyles.labelSmall,
                    'labelSmall (12px Bold)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: 특수 스타일
              _buildSection(
                title: '특수 스타일',
                children: [
                  _buildTextItem(
                    '옷차림표\n오늘의 옷을 골라요',
                    AppTextSyles.onboardingTitle,
                    'onboardingTitle (40px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '오늘 날씨에 딱 맞는 옷차림을 추천해 드려요',
                    AppTextSyles.onboardingSubtitle,
                    'onboardingSubtitle (16px)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '시작하기',
                    AppTextSyles.button,
                    'button (16px Bold)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '2025년 2월 4일 10:30',
                    AppTextSyles.caption,
                    'caption (11px)',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 섹션: Extension 테스트
              _buildSection(
                title: 'Extension 테스트',
                children: [
                  _buildTextItem(
                    '파란색 제목',
                    AppTextSyles.headlineMedium.withColor(Colors.blue),
                    'withColor(Colors.blue)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '반투명 텍스트',
                    AppTextSyles.bodyMedium.withOpacity(0.5),
                    'withOpacity(0.5)',
                  ),
                  const SizedBox(height: 12),
                  _buildTextItem(
                    '볼드 변환',
                    AppTextSyles.bodyMedium.toBold(),
                    'toBold()',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 폰트 적용 확인 카드
              _buildFontCheckCard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 섹션 빌더
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF5B8FB9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  /// 텍스트 아이템 빌더
  Widget _buildTextItem(String text, TextStyle style, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 폰트 적용 확인 카드
  Widget _buildFontCheckCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B8FB9), Color(0xFF7AA8D4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B8FB9).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            '폰트 적용 확인',
            style: AppTextSyles.headlineMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '위의 모든 텍스트가 강원교육 폰트로 표시되어야 합니다.\n\n'
            '• GangwonEduPower: 제목, 숫자\n'
            '• GangwonEduAll: 본문, 버튼\n\n'
            '폰트가 적용되지 않았다면:\n'
            '1. pubspec.yaml 확인\n'
            '2. flutter pub get 실행\n'
            '3. flutter clean 후 재실행',
            style: AppTextSyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
