import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _getBackgroundColor(widget.state.temperature),
      body: widget.state.loadingStatus == WeatherLoadingStatus.loading
          ? _buildLoadingView()
          : widget.state.loadingStatus == WeatherLoadingStatus.error
          ? _buildErrorView()
          : RefreshIndicator(
              onRefresh: () async {
                _refresh();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: Colors.white,
              backgroundColor: _getAccentColor(widget.state.temperature),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  _buildSliverAppBar(theme),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildTemperatureHero(theme),
                        const SizedBox(height: 24),
                        _buildOutfitRecommendations(theme),
                        const SizedBox(height: 40),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cloud_download_rounded,
                  size: 64,
                  color: Color(0xFF4FACFE),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '날씨 정보를 불러오는 중...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9),
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
          colors: [
            const Color(0xFFFF6B6B).withOpacity(0.8),
            const Color(0xFFFFB347).withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '날씨 정보를 불러올 수 없습니다',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.state.errorMessage ?? '네트워크 연결을 확인해주세요',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded, size: 24),
                  label: const Text(
                    '다시 시도하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  Widget _buildSliverAppBar(ThemeData theme) {
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
              colors: _getGradientColors(widget.state.temperature),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '옷차림표',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          color: Colors.white,
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

  Widget _buildTemperatureHero(ThemeData theme) {
    return FadeTransition(
      opacity: _headerAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(_headerAnimation),
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: _getAccentColor(
                  widget.state.temperature,
                ).withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
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
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _getGradientColors(
                                widget.state.temperature,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: Colors.white,
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.state.temperature.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w900,
                                color: _getAccentColor(
                                  widget.state.temperature,
                                ),
                                height: 0.9,
                                letterSpacing: -3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '°',
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w300,
                                  color: _getAccentColor(
                                    widget.state.temperature,
                                  ).withOpacity(0.7),
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.state.weatherDescription,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.3,
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
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _getGradientColors(
                                  widget.state.temperature,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: _getAccentColor(
                                    widget.state.temperature,
                                  ).withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getWeatherIcon(widget.state.temperature),
                              size: 56,
                              color: Colors.white,
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

  Widget _buildOutfitRecommendations(ThemeData theme) {
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '추천 옷차림',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _getCategoryGradient(index)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getCategoryGradient(
            categoryIndex,
          ).map((c) => c.withOpacity(0.1)).toList(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getCategoryGradient(categoryIndex)[0].withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        item.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _getCategoryGradient(categoryIndex)[0],
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Color _getBackgroundColor(double temp) {
    if (temp >= 28) return const Color(0xFFFFF5E6);
    if (temp >= 20) return const Color(0xFFFFF9F0);
    if (temp >= 9) return const Color(0xFFF5F8FF);
    if (temp >= 0) return const Color(0xFFEEF5FF);
    return const Color(0xFFE8F0F8);
  }

  List<Color> _getGradientColors(double temp) {
    if (temp >= 28) {
      return [const Color(0xFFFF6B6B), const Color(0xFFFFB347)];
    } else if (temp >= 20) {
      return [const Color(0xFFFFB347), const Color(0xFFFFD93D)];
    } else if (temp >= 9) {
      return [const Color(0xFF6BCF7F), const Color(0xFF4ECDC4)];
    } else if (temp >= 0) {
      return [const Color(0xFF4ECDC4), const Color(0xFF4A90E2)];
    }
    return [const Color(0xFF4A90E2), const Color(0xFF7B68EE)];
  }

  Color _getAccentColor(double temp) {
    return _getGradientColors(temp)[0];
  }

  List<Color> _getCategoryGradient(int index) {
    const gradients = [
      [Color(0xFF667EEA), Color(0xFF764BA2)],
      [Color(0xFFF093FB), Color(0xFFF5576C)],
      [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      [Color(0xFFFA709A), Color(0xFFFEE140)],
    ];
    return gradients[index % gradients.length];
  }

  IconData _getWeatherIcon(double temp) {
    if (temp >= 28) return Icons.wb_sunny_rounded;
    if (temp >= 20) return Icons.wb_cloudy_rounded;
    if (temp >= 9) return Icons.cloud_rounded;
    if (temp >= 0) return Icons.ac_unit_rounded;
    return Icons.severe_cold_rounded;
  }
}
