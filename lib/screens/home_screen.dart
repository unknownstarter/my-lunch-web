import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/food_type_selector.dart';
import '../widgets/price_range_slider.dart';
import '../widgets/distance_slider.dart';
import '../services/analytics_service.dart';
import '../services/naver_api_service.dart';
import '../providers/search_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  final NaverApiService _apiService = NaverApiService();
  String selectedFoodType = '';
  double selectedPriceRange = 1.0;
  double selectedDistance = 5.0;
  String? selectedLocation;
  final locations = [
    '강남역',
    '서울역',
    '홍대입구역',
    '여의도역',
    '판교역',
    '서현역',
    '정자역',
  ];

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView(screenName: 'home_screen');
    Provider.of<SearchProvider>(context, listen: false).clearCache();
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '위치 선택',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: locations.map((location) {
                  return ChoiceChip(
                    selected: selectedLocation == location,
                    label: Text(location),
                    onSelected: (selected) {
                      setState(() {
                        selectedLocation = selected ? location : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            if (selectedLocation != null)
              TextButton.icon(
                onPressed: () {
                  setState(() => selectedLocation = null);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('다시 선택'),
              ),
          ],
        ),
      ],
    );
  }

  void _searchRestaurants({bool useDefault = false}) {
    Provider.of<SearchProvider>(context, listen: false).clearCache();

    if (useDefault) {
      Navigator.pushNamed(context, '/results', arguments: {
        'foodTypes': <String>['한식'],
        'location': '강남역',
        'price': '1-2만원',
        'distance': '도보 10분',
      });
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치를 선택해주세요')),
      );
      return;
    }

    if (selectedFoodType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('음식 종류를 선택해주세요')),
      );
      return;
    }

    _analytics.logSearch(
      foodTypes: [selectedFoodType],
      location: selectedLocation ?? '',
      price: _getPriceLabel(selectedPriceRange),
      distance: _getDistanceLabel(selectedDistance),
    );

    Navigator.pushNamed(context, '/results', arguments: {
      'foodTypes': <String>[selectedFoodType],
      'location': selectedLocation,
    });
  }

  String _getPriceLabel(double value) {
    if (value <= 1) return '1만원 이하';
    if (value <= 2) return '1-2만원';
    if (value <= 3) return '2-3만원';
    return '3만원 이상';
  }

  String _getDistanceLabel(double value) {
    if (value <= 0.5) return '도보 5분';
    if (value <= 1.0) return '도보 10분';
    if (value <= 1.5) return '도보 15분';
    return '도보 20분';
  }

  Future<void> _testRandomSearch() async {
    final testLocations = ['강남역', '서울역', '홍대입구역'];
    final testFoodTypes = ['맛집', '한식', '중식', '일식'];

    final randomLocation =
        testLocations[DateTime.now().millisecond % testLocations.length];
    final randomFoodType =
        testFoodTypes[DateTime.now().second % testFoodTypes.length];

    try {
      final response = await _apiService.searchRestaurants(
        randomFoodType,
        location: randomLocation,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('테스트 결과: ${response.length}개 검색됨\n'
              '검색어: $randomLocation $randomFoodType\n'
              '${response.isNotEmpty ? "첫번째 결과: ${response.first.name}" : ""}'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('테스트 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '오늘의 점심',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FoodTypeSelector(
                    selectedType: selectedFoodType,
                    onChanged: (type) {
                      setState(() => selectedFoodType = type);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '가격대',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PriceRangeSlider(
                    value: selectedPriceRange,
                    onChanged: (value) {
                      setState(() => selectedPriceRange = value);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '거리',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DistanceSlider(
                    value: selectedDistance,
                    onChanged: (value) {
                      setState(() => selectedDistance = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildLocationSection(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _searchRestaurants(),
                    child: const Text('추천받기'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _searchRestaurants(useDefault: true),
                    child: const Text(
                      '기본 설정으로 추천받기',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _testRandomSearch,
                      child: const Text(
                        '무작위 검색 테스트',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
