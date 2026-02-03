import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

import '../../core/theme/app_styles.dart';
import '../domain/model/outfit_item.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

class OutfitScreen extends StatefulWidget {
  final OutfitState state;
  final void Function(OutfitAction action) onAction;

  const OutfitScreen({super.key, required this.state, required this.onAction});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _itemsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _itemsAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _itemsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _itemsAnimation = CurvedAnimation(
      parent: _itemsController,
      curve: Curves.easeOutCubic,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _itemsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  void _refresh() {
    widget.onAction(const OutfitAction.onRefresh());
    _headerController.reset();
    _itemsController.reset();
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _itemsController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getTemperatureBackground(
        widget.state.temperature,
      ),
      body: widget.state.loadingStatus == WeatherLoadingStatus.loading
          ? _buildLoadingView()
          : widget.state.loadingStatus == WeatherLoadingStatus.error
          ? _buildErrorView()
          : RefreshIndicator(
              onRefresh: () async {
                _refresh();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: AppColors.textWhite,
              backgroundColor: AppColors.getTemperatureAccent(
                widget.state.temperature,
              ),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildTemperatureHero(),
                        const SizedBox(height: AppSpacing.large),
                        _buildOutfitRecommendations(),
                        const SizedBox(height: AppSpacing.xxLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.coolGradient,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: AppRadius.extraLargeRadius,
                  boxShadow: [AppShadows.large()],
                ),
                child: const Icon(
                  Icons.cloud_download_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xLarge),
              Text(
                '날씨 정보를 불러오는 중...',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textWhite.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.veryHotGradient
              .map((c) => c.withOpacity(0.8))
              .toList(),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    borderRadius: AppRadius.extraLargeRadius,
                    boxShadow: [AppShadows.large()],
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.xLarge),
                Text(
                  '날씨 정보를 불러올 수 없습니다',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  widget.state.errorMessage ?? '네트워크 연결을 확인해주세요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxLarge),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded, size: 24),
                  label: Text('다시 시도하기', style: AppTextStyles.labelLarge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textWhite,
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xLarge,
                      vertical: AppSpacing.medium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      forceElevated: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.getTemperatureGradient(
                widget.state.temperature,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.medium,
                AppSpacing.large,
                AppSpacing.medium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '옷차림표',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.textWhite.withOpacity(0.2),
                          borderRadius: AppRadius.mediumRadius,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          color: AppColors.textWhite,
                          iconSize: 24,
                          onPressed: _refresh,
                          tooltip: '새로고침',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureHero() {
    return FadeTransition(
      opacity: _headerAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(_headerAnimation),
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.large,
            AppSpacing.large,
            AppSpacing.large,
            AppSpacing.large,
          ),
          padding: const EdgeInsets.all(AppSpacing.xLarge),
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: AppRadius.xxLargeRadius,
            boxShadow: [
              AppShadows.temperatureCard(
                AppColors.getTemperatureAccent(widget.state.temperature),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.small,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.getTemperatureGradient(
                                widget.state.temperature,
                              ),
                            ),
                            borderRadius: AppRadius.smallRadius,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.textWhite,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.state.lastUpdated != null
                                    ? DateFormat(
                                        'M월d일 HH시mm분',
                                      ).format(widget.state.lastUpdated!)
                                    : DateFormat(
                                        'M월d일 HH시mm분',
                                      ).format(DateTime.now()),
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.large),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.state.temperature.toStringAsFixed(0),
                              style: AppTextStyles.displayLarge.copyWith(
                                color: AppColors.getTemperatureAccent(
                                  widget.state.temperature,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '°',
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: AppColors.getTemperatureAccent(
                                    widget.state.temperature,
                                  ).withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          widget.state.weatherDescription,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Transform.rotate(
                          angle: (1 - value) * math.pi / 4,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.large),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.getTemperatureGradient(
                                  widget.state.temperature,
                                ),
                              ),
                              borderRadius: AppRadius.extraLargeRadius,
                              boxShadow: [
                                AppShadows.gradientCard(
                                  AppColors.getTemperatureAccent(
                                    widget.state.temperature,
                                  ),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getWeatherIcon(widget.state.temperature),
                              size: 56,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitRecommendations() {
    final categories = [
      if (widget.state.outers.isNotEmpty)
        ('아우터', Icons.checkroom_rounded, widget.state.outers),
      if (widget.state.tops.isNotEmpty)
        ('상의', Icons.dry_cleaning_rounded, widget.state.tops),
      if (widget.state.bottoms.isNotEmpty)
        ('하의', Icons.accessibility_new_rounded, widget.state.bottoms),
      if (widget.state.accessories.isNotEmpty)
        ('악세서리', Icons.watch_rounded, widget.state.accessories),
    ];

    return FadeTransition(
      opacity: _itemsAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_itemsAnimation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '추천 옷차림',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              ...categories.asMap().entries.map((entry) {
                final index = entry.key;
                final (title, icon, items) = entry.value;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildCategoryCard(title, icon, items, index),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    List<OutfitItem> items,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: AppRadius.largeRadius,
        boxShadow: [AppShadows.medium()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.getCategoryGradient(index),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 22, color: AppColors.textWhite),
              ),
              const SizedBox(width: AppSpacing.small),
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.asMap().entries.map((entry) {
              final itemIndex = entry.key;
              final item = entry.value;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (itemIndex * 50)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: _buildOutfitChip(item, index),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitChip(OutfitItem item, int categoryIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getCategoryGradient(
            categoryIndex,
          ).map((c) => c.withOpacity(0.1)).toList(),
        ),
        borderRadius: AppRadius.smallRadius,
        border: Border.all(
          color: AppColors.getCategoryGradient(
            categoryIndex,
          )[0].withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        item.name,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.getCategoryGradient(categoryIndex)[0],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(double temp) {
    if (temp >= 28) return Icons.wb_sunny_rounded;
    if (temp >= 20) return Icons.wb_cloudy_rounded;
    if (temp >= 9) return Icons.cloud_rounded;
    if (temp >= 0) return Icons.ac_unit_rounded;
    return Icons.severe_cold_rounded;
  }
}
