import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/theme/app_styles.dart';
import '../data/onboarding_repository.dart';
import 'widgets/onboarding_page_one.dart';
import 'widgets/onboarding_page_two.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: AppDuration.normal,
      curve: AppCurve.easeInOut,
    );
  }

  Future<void> _requestLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        _showPermissionDeniedDialog('위치 서비스가 꺼져 있습니다.\n기기 설정에서 위치 서비스를 켜주세요.');
      }
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (mounted) {
        _showPermissionDeniedDialog('위치 권한이 거부되었습니다.\n앱을 사용하려면 위치 권한이 필요합니다.');
      }
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        _showPermissionDeniedDialog(
          '위치 권한이 영구적으로 거부되었습니다.\n설정에서 위치 권한을 허용해주세요.',
        );
      }
      return;
    }

    // 권한 허용됨 → 온보딩 완료
    await ref.read(onboardingRepositoryProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/outfit');
    }
  }

  void _showPermissionDeniedDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xLargeRadius),
        child: Container(
          padding: AppSpacing.largeAll,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.xLargeRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppSpacing.mediumAll,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E8AE4),
                  borderRadius: AppRadius.mediumRadius,
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              const Text(
                '위치 권한 필요',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494A4B),
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: AppSpacing.mediumVertical,
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Geolocator.openAppSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E8AE4),
                        foregroundColor: Colors.white,
                        padding: AppSpacing.mediumVertical,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mediumRadius,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '설정으로',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FB),
      body: Stack(
        children: [
          // 페이지 뷰 (전체 화면)
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              OnboardingPageOne(onNext: _goToNextPage),
              OnboardingPageTwo(
                onRequestPermission: _requestLocationPermission,
              ),
            ],
          ),

          // 페이지 인디케이터 (상단 중앙, 배경 위에)
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.medium,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageIndicator(0),
                const SizedBox(width: AppSpacing.xSmall),
                _buildPageIndicator(1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: AppDuration.normal,
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF0E8AE4)
            : const Color(0xFF0E8AE4).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
