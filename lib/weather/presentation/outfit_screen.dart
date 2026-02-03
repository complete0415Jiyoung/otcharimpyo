import 'package:flutter/material.dart';

import '../domain/model/outfit_item.dart';
import 'outfit_state.dart';
import 'outfit_action.dart';

class OutfitScreen extends StatelessWidget {
  final OutfitState state;
  final void Function(OutfitAction action) onAction;

  const OutfitScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 옷차림'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTemperatureCard(theme),
            const SizedBox(height: 16),
            _buildTemperatureSlider(theme),
            const SizedBox(height: 24),
            if (state.outers.isNotEmpty)
              _buildCategorySection(theme, '아우터', Icons.checkroom, state.outers),
            if (state.tops.isNotEmpty)
              _buildCategorySection(theme, '상의', Icons.dry_cleaning, state.tops),
            if (state.bottoms.isNotEmpty)
              _buildCategorySection(
                  theme, '하의', Icons.accessibility_new, state.bottoms),
            if (state.accessories.isNotEmpty)
              _buildCategorySection(
                  theme, '악세서리', Icons.watch, state.accessories),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(
              _getWeatherIcon(state.temperature),
              size: 48,
              color: _getTemperatureColor(state.temperature),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.temperature.toStringAsFixed(0)}°C',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getTemperatureColor(state.temperature),
                  ),
                ),
                Text(
                  state.weatherDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureSlider(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기온 조절',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Slider(
              value: state.temperature,
              min: -10,
              max: 40,
              divisions: 50,
              label: '${state.temperature.toStringAsFixed(0)}°C',
              onChanged: (value) {
                onAction(OutfitAction.onChangeTemperature(value));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '-10°C',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '40°C',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    ThemeData theme,
    String title,
    IconData icon,
    List<OutfitItem> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Chip(
                    label: Text(item.name),
                    avatar: Icon(
                      _getCategoryIcon(item.category),
                      size: 18,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(double temp) {
    if (temp >= 28) return Icons.wb_sunny;
    if (temp >= 20) return Icons.wb_cloudy;
    if (temp >= 9) return Icons.cloud;
    if (temp >= 0) return Icons.ac_unit;
    return Icons.severe_cold;
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 28) return Colors.red;
    if (temp >= 23) return Colors.orange;
    if (temp >= 17) return Colors.amber;
    if (temp >= 9) return Colors.teal;
    if (temp >= 0) return Colors.blue;
    return Colors.indigo;
  }

  IconData _getCategoryIcon(OutfitCategory category) {
    return switch (category) {
      OutfitCategory.top => Icons.dry_cleaning,
      OutfitCategory.bottom => Icons.accessibility_new,
      OutfitCategory.outer => Icons.checkroom,
      OutfitCategory.accessory => Icons.watch,
    };
  }
}
