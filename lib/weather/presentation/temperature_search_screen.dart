import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/theme/app_styles.dart';
import '../../core/theme/app_color_styles.dart';
import '../domain/model/outfit_item.dart';
import 'temperature_search_notifier.dart';

class TemperatureSearchScreen extends ConsumerWidget {
  const TemperatureSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(temperatureSearchNotifierProvider);
    final notifier = ref.read(temperatureSearchNotifierProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFFE8F4FB));
              },
            ),
          ),

          // 컨텐츠
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 (뒤로가기 버튼)
                  Row(
                    children: [
                      Material(
                        color: Colors.white,
                        borderRadius: AppRadius.circle,
                        elevation: 2,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: AppRadius.circle,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.small),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '온도로 옷차림 찾기',
                              style: TextStyle(
                                fontFamily: 'GangwonEduPower',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF494A4B),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '원하는 온도를 선택해주세요',
                              style: TextStyle(
                                fontFamily: 'GangwonEduAll',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8E8E8E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xLarge),

                  // 온도 검색 카드
                  _buildTemperatureSearchCard(
                    context,
                    state.selectedTemperature,
                    notifier.onTemperatureChanged,
                  ),

                  const SizedBox(height: AppSpacing.large),

                  // 추천 옷차림
                  _buildOutfitRecommendation(state.selectedTemperature, state),

                  const SizedBox(height: AppSpacing.xxLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 온도 검색 카드
  Widget _buildTemperatureSearchCard(
    BuildContext context,
    double currentTemp,
    Function(double) onTemperatureChanged,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.xLargeRadius,
        boxShadow: [AppShadows.soft()],
      ),
      child: Column(
        children: [
          // 타이틀
          const Text(
            '온도로 옷차림 찾아보세요',
            style: TextStyle(
              fontFamily: 'GangwonEduAll',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF494A4B),
            ),
          ),

          const SizedBox(height: AppSpacing.xLarge),

          // 온도 표시 (크게)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentTemp.toStringAsFixed(0),
                style: TextStyle(
                  fontFamily: 'GangwonEduPower',
                  fontSize: 80,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: -2,
                  color: AppColors.getTemperatureColor(currentTemp),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontFamily: 'GangwonEduPower',
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xLarge),

          // 슬라이더
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 16,
                elevation: 2,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              activeTrackColor: AppColors.getTemperatureColor(currentTemp),
              inactiveTrackColor: AppColors.getTemperatureColor(
                currentTemp,
              ).withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: AppColors.getTemperatureColor(
                currentTemp,
              ).withOpacity(0.3),
            ),
            child: Slider(
              value: currentTemp,
              min: -10,
              max: 40,
              divisions: 50,
              onChanged: onTemperatureChanged,
            ),
          ),

          // 온도 범위 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '-10°C',
                  style: TextStyle(
                    fontFamily: 'GangwonEduAll',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mediumGray,
                  ),
                ),
                Text(
                  '40°C',
                  style: TextStyle(
                    fontFamily: 'GangwonEduAll',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.large),

          // 온도 단계 버튼들
          // Wrap(
          //   spacing: AppSpacing.small,
          //   runSpacing: AppSpacing.small,
          //   alignment: WrapAlignment.center,
          //   children: [
          //     _buildTemperatureButton(0, currentTemp, onTemperatureChanged),
          //     _buildTemperatureButton(12, currentTemp, onTemperatureChanged),
          //     _buildTemperatureButton(24, currentTemp, onTemperatureChanged),
          //     _buildTemperatureButton(36, currentTemp, onTemperatureChanged),
          //   ],
          // ),
        ],
      ),
    );
  }

  // Widget _buildTemperatureButton(
  //   int temperature,
  //   double currentTemp,
  //   Function(double) onTemperatureChanged,
  // ) {
  //   final isSelected = (currentTemp - temperature).abs() < 1;

  //   return Material(
  //     color: isSelected ? AppColors.primary : AppColors.backgroundSecondary,
  //     borderRadius: AppRadius.mediumRadius,
  //     child: InkWell(
  //       onTap: () => onTemperatureChanged(temperature.toDouble()),
  //       borderRadius: AppRadius.mediumRadius,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: AppSpacing.medium,
  //           vertical: AppSpacing.small,
  //         ),
  //         child: Text(
  //           '$temperature°C',
  //           style: TextStyle(
  //             fontFamily: 'GangwonEduAll',
  //             fontSize: 14,
  //             fontWeight: FontWeight.w700,
  //             color: isSelected ? Colors.white : AppColors.darkGray,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // 추천 옷차림
  Widget _buildOutfitRecommendation(double displayTemp, state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.xLargeRadius,
        boxShadow: [AppShadows.soft()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '추천 옷차림',
                style: TextStyle(
                  fontFamily: 'GangwonEduPower',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494A4B),
                ),
              ),

              // 온도 표시 (작게)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.xSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getTemperatureBackground(displayTemp),
                  borderRadius: AppRadius.smallRadius,
                ),
                child: Text(
                  '${displayTemp.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontFamily: 'GangwonEduPower',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.getTemperatureColor(displayTemp),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),

          // 옷차림 항목들
          if (state.tops.isNotEmpty) ...[
            _buildOutfitRow(
              '상의',
              state.tops.map((OutfitItem e) => e.name).toList().cast<String>(),
            ),
            const SizedBox(height: AppSpacing.medium),
          ],

          if (state.bottoms.isNotEmpty) ...[
            _buildOutfitRow(
              '하의',
              state.bottoms
                  .map((OutfitItem e) => e.name)
                  .toList()
                  .cast<String>(),
            ),
            const SizedBox(height: AppSpacing.medium),
          ],

          if (state.outers.isNotEmpty) ...[
            _buildOutfitRow(
              '아우터',
              state.outers
                  .map((OutfitItem e) => e.name)
                  .toList()
                  .cast<String>(),
            ),
          ],

          if (state.accessories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.medium),
            _buildOutfitRow(
              '액세서리',
              state.accessories
                  .map((OutfitItem e) => e.name)
                  .toList()
                  .cast<String>(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOutfitRow(String category, List<String> items) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            category,
            style: const TextStyle(
              fontFamily: 'GangwonEduAll',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8E8E8E),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.xSmall,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FB),
                  borderRadius: AppRadius.smallRadius,
                ),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontFamily: 'GangwonEduAll',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF494A4B),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
