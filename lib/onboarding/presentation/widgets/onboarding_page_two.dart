import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';

class OnboardingPageTwo extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const OnboardingPageTwo({super.key, required this.onRequestPermission});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboard_2.png'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '지금 계신 곳을\n알려주세요 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'GangwonEduPower',
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494A4B),
                      height: 1.3,
                    ),
                  ),
                  Text(
                    '📍',
                    style: TextStyle(
                      fontFamily: 'GangwonEduPower',
                      fontSize: 32,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),

              // 부제목
              const Text(
                '현재 위치의 기온을 알고\n어울리는 옷차림을 추천합니다.',
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
                  onPressed: onRequestPermission,
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
                    '위치 정보 허용하기',
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
