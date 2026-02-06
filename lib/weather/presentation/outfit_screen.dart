import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_styles.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

class OutfitScreen extends StatefulWidget {
  final OutfitState state;
  final void Function(OutfitAction action) onAction;

  const OutfitScreen({super.key, required this.state, required this.onAction});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  void _refresh() {
    widget.onAction(const OutfitAction.onRefresh());
  }

  // 시간대별 인사말
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '좋은 아침입니다!';
    if (hour < 18) return '좋은 오후입니다!';
    return '좋은 저녁입니다!';
  }

  // 현재 날짜
  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('M월 d일').format(now);
  }

  @override
  Widget build(BuildContext context) {
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
          widget.state.loadingStatus == WeatherLoadingStatus.loading
              ? _buildLoadingView()
              : widget.state.loadingStatus == WeatherLoadingStatus.error
              ? _buildErrorView()
              : _buildSuccessView(),
        ],
      ),
    );
  }

  // 로딩 화면
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.xxLargeRadius,
              boxShadow: [AppShadows.large()],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF0E8AE4),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                const Text(
                  '날씨 정보를 불러오는 중...',
                  style: TextStyle(
                    fontFamily: 'GangwonEduAll',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF494A4B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 에러 화면
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xLarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.xxLargeRadius,
            boxShadow: [AppShadows.large()],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 40,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              const Text(
                '날씨 정보를 불러올 수 없습니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'GangwonEduPower',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494A4B),
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                widget.state.errorMessage ?? '네트워크 연결을 확인해주세요',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'GangwonEduAll',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: AppSpacing.xLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    '다시 시도하기',
                    style: TextStyle(
                      fontFamily: 'GangwonEduAll',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 성공 화면
  Widget _buildSuccessView() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          _refresh();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: const Color(0xFF0E8AE4),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.small),

              // 상단 인사말
              _buildGreeting(),

              const SizedBox(height: AppSpacing.xLarge),

              // 온도 카드
              _buildTemperatureCard(),

              const SizedBox(height: AppSpacing.medium),

              // 세부 정보 (체감온도, 습도, 강수량)
              _buildWeatherDetails(),

              const SizedBox(height: AppSpacing.large),

              // 추천 옷차림
              _buildOutfitRecommendation(),

              const SizedBox(height: AppSpacing.xxLarge),
            ],
          ),
        ),
      ),
    );
  }

  // 인사말
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: const TextStyle(
            fontFamily: 'GangwonEduPower',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494A4B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getCurrentDate(),
          style: const TextStyle(
            fontFamily: 'GangwonEduAll',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8E8E8E),
          ),
        ),
      ],
    );
  }

  // 온도 카드
  Widget _buildTemperatureCard() {
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
          // 위치
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 20,
                color: Color(0xFF0E8AE4),
              ),
              const SizedBox(width: 4),
              Text(
                widget.state.location,
                style: const TextStyle(
                  fontFamily: 'GangwonEduAll',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF494A4B),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.large),

          // 온도
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.thermostat_rounded,
                size: 60,
                color: Color(0xFF8E8E8E),
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                widget.state.temperature.toStringAsFixed(0),
                style: const TextStyle(
                  fontFamily: 'GangwonEduPower',
                  fontSize: 80,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: -2,
                  color: Color(0xFF494A4B),
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

          const SizedBox(height: AppSpacing.small),

          // 시간
          Text(
            widget.state.lastUpdated != null
                ? DateFormat(
                    'yyyy/MM/dd HH:mm',
                  ).format(widget.state.lastUpdated!)
                : DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
            style: const TextStyle(
              fontFamily: 'GangwonEduAll',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E8E),
            ),
          ),
        ],
      ),
    );
  }

  // 세부 정보
  Widget _buildWeatherDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            icon: Icons.thermostat_auto_rounded,
            label: '체감온도',
            value: widget.state.feelsLike.toStringAsFixed(0),
            unit: '°C',
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: _buildDetailItem(
            icon: Icons.water_drop_rounded,
            label: '습도',
            value: widget.state.humidity.toString(),
            unit: '%',
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: _buildDetailItem(
            icon: Icons.umbrella_rounded,
            label: '강수량',
            value: widget.state.precipitation.toStringAsFixed(1),
            unit: 'mm',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.large,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: [AppShadows.soft()],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF8E8E8E)),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'GangwonEduAll',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: AppSpacing.xxSmall),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontFamily: 'GangwonEduPower',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494A4B),
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontFamily: 'GangwonEduAll',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF494A4B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 추천 옷차림
  Widget _buildOutfitRecommendation() {
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
          const Text(
            '오늘의 추천 옷차림',
            style: TextStyle(
              fontFamily: 'GangwonEduPower',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF494A4B),
            ),
          ),
          const SizedBox(height: AppSpacing.large),

          // ✅ state의 tops, bottoms, outers 사용
          if (widget.state.tops.isNotEmpty) ...[
            _buildOutfitRow(
              '상의',
              widget.state.tops.map((e) => e.name).toList(),
            ),
            const SizedBox(height: AppSpacing.medium),
          ],

          if (widget.state.bottoms.isNotEmpty) ...[
            _buildOutfitRow(
              '하의',
              widget.state.bottoms.map((e) => e.name).toList(),
            ),
            const SizedBox(height: AppSpacing.medium),
          ],

          if (widget.state.outers.isNotEmpty) ...[
            _buildOutfitRow(
              '아우터',
              widget.state.outers.map((e) => e.name).toList(),
            ),
          ],

          // 액세서리도 추가
          if (widget.state.accessories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.medium),
            _buildOutfitRow(
              '액세서리',
              widget.state.accessories.map((e) => e.name).toList(),
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
