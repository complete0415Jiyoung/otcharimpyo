import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_styles.dart';

/// 위치 검색 결과 모델
class LocationSearchResult {
  final String name;
  final double latitude;
  final double longitude;

  const LocationSearchResult({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

/// 위치 검색 화면
class LocationSearchScreen extends StatefulWidget {
  final void Function(LocationSearchResult result)? onLocationSelected;

  const LocationSearchScreen({super.key, this.onLocationSelected});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  List<LocationSearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 자주 사용하는 도시 목록
  static const List<Map<String, dynamic>> _popularCities = [
    {'name': '서울', 'lat': 37.5665, 'lon': 126.9780},
    {'name': '부산', 'lat': 35.1796, 'lon': 129.0756},
    {'name': '대구', 'lat': 35.8714, 'lon': 128.6014},
    {'name': '인천', 'lat': 37.4563, 'lon': 126.7052},
    {'name': '광주', 'lat': 35.1595, 'lon': 126.8526},
    {'name': '대전', 'lat': 36.3504, 'lon': 127.3845},
    {'name': '울산', 'lat': 35.5384, 'lon': 129.3114},
    {'name': '세종', 'lat': 36.4800, 'lon': 127.2890},
    {'name': '제주', 'lat': 33.4996, 'lon': 126.5312},
    {'name': '수원', 'lat': 37.2636, 'lon': 127.0286},
    {'name': '창원', 'lat': 35.2280, 'lon': 128.6811},
    {'name': '고양', 'lat': 37.6584, 'lon': 126.8320},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final locations = await locationFromAddress(query);

      if (locations.isEmpty) {
        setState(() {
          _searchResults = [];
          _errorMessage = '검색 결과가 없습니다';
          _isLoading = false;
        });
        return;
      }

      // 검색 결과를 LocationSearchResult로 변환
      final results = <LocationSearchResult>[];
      for (final location in locations.take(5)) {
        try {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final name = _formatPlaceName(place);
            results.add(LocationSearchResult(
              name: name,
              latitude: location.latitude,
              longitude: location.longitude,
            ));
          }
        } catch (_) {
          results.add(LocationSearchResult(
            name: query,
            latitude: location.latitude,
            longitude: location.longitude,
          ));
        }
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _errorMessage = '위치를 검색할 수 없습니다';
        _isLoading = false;
      });
    }
  }

  String _formatPlaceName(Placemark place) {
    final parts = <String>[];

    if (place.administrativeArea?.isNotEmpty == true) {
      parts.add(place.administrativeArea!);
    }
    if (place.subLocality?.isNotEmpty == true) {
      parts.add(place.subLocality!);
    }
    if (place.thoroughfare?.isNotEmpty == true) {
      parts.add(place.thoroughfare!);
    }

    return parts.isEmpty ? '알 수 없는 위치' : parts.join(' ');
  }

  void _selectLocation(LocationSearchResult result) {
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(result);
    }
    context.pop(result);
  }

  void _selectPopularCity(Map<String, dynamic> city) {
    final result = LocationSearchResult(
      name: city['name'] as String,
      latitude: city['lat'] as double,
      longitude: city['lon'] as double,
    );
    _selectLocation(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경
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
            child: Column(
              children: [
                // 헤더
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Row(
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
                              color: Color(0xFF0E8AE4),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      const Expanded(
                        child: Text(
                          '위치 검색',
                          style: TextStyle(
                            fontFamily: 'GangwonEduPower',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494A4B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 검색 바
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.mediumRadius,
                      boxShadow: [AppShadows.soft()],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) {
                        if (value.length >= 2) {
                          _searchLocation(value);
                        } else {
                          setState(() {
                            _searchResults = [];
                            _errorMessage = null;
                          });
                        }
                      },
                      onSubmitted: _searchLocation,
                      style: const TextStyle(
                        fontFamily: 'GangwonEduAll',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494A4B),
                      ),
                      decoration: InputDecoration(
                        hintText: '도시 또는 지역 이름 입력',
                        hintStyle: const TextStyle(
                          fontFamily: 'GangwonEduAll',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8E8E8E),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF8E8E8E),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: Color(0xFF8E8E8E),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                    _errorMessage = null;
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.medium,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.large),

                // 검색 결과 또는 인기 도시
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0E8AE4),
                          ),
                        )
                      : _searchResults.isNotEmpty
                          ? _buildSearchResults()
                          : _errorMessage != null
                              ? _buildErrorMessage()
                              : _buildPopularCities(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildLocationTile(
          name: result.name,
          onTap: () => _selectLocation(result),
        );
      },
    );
  }

  Widget _buildPopularCities() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.medium),
            child: Text(
              '주요 도시',
              style: TextStyle(
                fontFamily: 'GangwonEduPower',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494A4B),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.mediumRadius,
              boxShadow: [AppShadows.soft()],
            ),
            child: Column(
              children: _popularCities.map((city) {
                final isLast = city == _popularCities.last;
                return Column(
                  children: [
                    _buildCityTile(
                      name: city['name'] as String,
                      onTap: () => _selectPopularCity(city),
                    ),
                    if (!isLast)
                      const Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xxLarge),
        ],
      ),
    );
  }

  Widget _buildLocationTile({
    required String name,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: [AppShadows.soft()],
      ),
      child: ListTile(
        leading: const Icon(
          Icons.location_on_rounded,
          color: Color(0xFF0E8AE4),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontFamily: 'GangwonEduAll',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF494A4B),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Color(0xFF8E8E8E),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCityTile({
    required String name,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: const Icon(
        Icons.location_city_rounded,
        color: Color(0xFF0E8AE4),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontFamily: 'GangwonEduAll',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF494A4B),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Color(0xFF8E8E8E),
      ),
      onTap: onTap,
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xFF8E8E8E),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            _errorMessage ?? '검색 결과가 없습니다',
            style: const TextStyle(
              fontFamily: 'GangwonEduAll',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E8E),
            ),
          ),
        ],
      ),
    );
  }
}
