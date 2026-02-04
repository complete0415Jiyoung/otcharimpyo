import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';

class OnboardingPageOne extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPageOne({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboard_1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),

              // 제목
              const Text(
                '옷차림표\n오늘의 옷을 골라요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'GangwonEduPower',
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494A4B),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),

              // 부제목
              const Text(
                '지금의 상황에 맞는 옷차림을\n간단하게 추천해드립니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'GangwonEduAll',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E8E),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: AppSpacing.xxLarge),

              // 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E8AE4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.medium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontFamily: 'GangwonEduAll',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.large),
            ],
          ),
        ),
      ),
    );
  }
}
