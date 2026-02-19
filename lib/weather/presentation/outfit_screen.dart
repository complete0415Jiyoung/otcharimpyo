import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_styles.dart';
import '../../core/routing/routes.dart';
import '../../location/presentation/location_search_screen.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

class OutfitScreen extends StatefulWidget {
  final OutfitState state;
  final void Function(OutfitAction action) onAction;
  final VoidCallback? onClearLocationError;

  const OutfitScreen({
    super.key,
    required this.state,
    required this.onAction,
    this.onClearLocationError,
  });

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  static const String _privacyPolicyUrl = 'https://www.notion.so/3047eab3764980659c98ddc8d0dad264';

  void _refresh() {
    widget.onAction(const OutfitAction.onRefresh());
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.xLarge),
            const Text(
              '앱 정보',
              style: TextStyle(
                fontFamily: 'GangwonEduPower',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494A4B),
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF0E8AE4)),
              title: const Text(
                '개인정보처리방침',
                style: TextStyle(
                  fontFamily: 'GangwonEduAll',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                Navigator.pop(context);
                final uri = Uri.parse(_privacyPolicyUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            const Text(
              '옷차림표 v1.0.0',
              style: TextStyle(
                fontFamily: 'GangwonEduAll',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8E8E8E),
              ),
            ),
            const SizedBox(height: AppSpacing.large),
          ],
        ),
      ),
    );
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

              // 상단 인사말 + 온도 검색 버튼
              _buildHeader(),

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

  // 헤더 (인사말 + 온도 검색 버튼)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 인사말
        Column(
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
        ),

        // 버튼들
        Row(
          children: [
            // 온도 검색 버튼
            Material(
              color: Colors.white,
              borderRadius: AppRadius.circle,
              elevation: 2,
              child: InkWell(
                onTap: () {
                  context.push('/temperature-search');
                },
                borderRadius: AppRadius.circle,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF0E8AE4),
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            // 정보 버튼
            Material(
              color: Colors.white,
              borderRadius: AppRadius.circle,
              elevation: 2,
              child: InkWell(
                onTap: _showInfoBottomSheet,
                borderRadius: AppRadius.circle,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF8E8E8E),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 위치 검색 화면으로 이동
  Future<void> _goToLocationSearch() async {
    final result = await context.push<LocationSearchResult>(Routes.locationSearch);
    if (result != null && mounted) {
      widget.onAction(OutfitAction.onChangeLocation(
        latitude: result.latitude,
        longitude: result.longitude,
        locationName: result.name,
      ));
    }
  }

  // 현재 위치 사용
  void _useCurrentLocation() {
    widget.onAction(const OutfitAction.onUseCurrentLocation());
  }

  @override
  void didUpdateWidget(covariant OutfitScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 위치 권한 에러 감지
    if (widget.state.locationPermissionError != LocationPermissionError.none &&
        oldWidget.state.locationPermissionError == LocationPermissionError.none) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationPermissionDialog(widget.state.locationPermissionError);
      });
    }
  }

  // 위치 권한 다이얼로그 표시
  void _showLocationPermissionDialog(LocationPermissionError error) {
    String title;
    String message;
    String settingsButtonText;
    VoidCallback onSettingsPressed;

    switch (error) {
      case LocationPermissionError.serviceDisabled:
        title = '위치 서비스 꺼짐';
        message = Platform.isIOS
            ? '현재 위치를 사용하려면 설정에서\n위치 서비스를 켜주세요.'
            : '현재 위치를 사용하려면 설정에서\n위치를 켜주세요.';
        settingsButtonText = '설정으로 이동';
        onSettingsPressed = () {
          Navigator.pop(context);
          widget.onClearLocationError?.call();
          Geolocator.openLocationSettings();
        };
        break;
      case LocationPermissionError.permissionDenied:
      case LocationPermissionError.permissionDeniedForever:
        title = '위치 권한 필요';
        message = Platform.isIOS
            ? '현재 위치를 사용하려면\n설정 > 개인 정보 보호 > 위치 서비스에서\n옷차림표 앱의 위치 접근을 허용해주세요.'
            : '현재 위치를 사용하려면\n설정 > 앱 > 옷차림표 > 권한에서\n위치 권한을 허용해주세요.';
        settingsButtonText = '설정으로 이동';
        onSettingsPressed = () {
          Navigator.pop(context);
          widget.onClearLocationError?.call();
          Geolocator.openAppSettings();
        };
        break;
      case LocationPermissionError.none:
        return;
    }

    showDialog(
      context: context,
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
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'GangwonEduPower',
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
                  fontFamily: 'GangwonEduAll',
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
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onClearLocationError?.call();
                      },
                      style: TextButton.styleFrom(
                        padding: AppSpacing.mediumVertical,
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontFamily: 'GangwonEduAll',
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
                      onPressed: onSettingsPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E8AE4),
                        foregroundColor: Colors.white,
                        padding: AppSpacing.mediumVertical,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mediumRadius,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        settingsButtonText,
                        style: const TextStyle(
                          fontFamily: 'GangwonEduAll',
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
          // 위치 (탭하여 검색)
          InkWell(
            onTap: _goToLocationSearch,
            borderRadius: AppRadius.mediumRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: AppRadius.mediumRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xFF8E8E8E),
                  ),
                ],
              ),
            ),
          ),

          // 현재 위치 사용 버튼 (사용자가 위치를 선택했을 때만 표시)
          if (!widget.state.useCurrentLocation) ...[
            const SizedBox(height: AppSpacing.small),
            TextButton.icon(
              onPressed: _useCurrentLocation,
              icon: const Icon(
                Icons.my_location_rounded,
                size: 16,
                color: Color(0xFF0E8AE4),
              ),
              label: const Text(
                '현재 위치 사용',
                style: TextStyle(
                  fontFamily: 'GangwonEduAll',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0E8AE4),
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                  vertical: 0,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],

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
