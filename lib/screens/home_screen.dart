import 'package:flutter/material.dart';
import '../widgets/food_type_selector.dart';
import '../widgets/price_range_slider.dart';
import '../widgets/distance_slider.dart';
import '../widgets/preference_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedFoodTypes = [];
  double selectedPriceRange = 1.0;
  double selectedDistance = 5.0;
  String? selectedPreference;
  String? selectedLocation;
  final locations = ['서울시 강남구 역삼동', '성남시 분당구 삼평동', '서울시 성동구 성수동'];

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
    if (useDefault) {
      Navigator.pushNamed(context, '/results', arguments: {
        'foodTypes': ['한식'],
        'location': '서울시 강남구 역삼동',
        'price': '1만원대',
        'distance': '10분',
        'preference': '소개팅',
      });
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치를 선택해주세요')),
      );
      return;
    }

    if (selectedFoodTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('음식 종류를 선택해주세요')),
      );
      return;
    }

    Navigator.pushNamed(context, '/results', arguments: {
      'foodTypes': selectedFoodTypes,
      'location': selectedLocation,
      'price': _getPriceLabel(selectedPriceRange),
      'distance': _getDistanceLabel(selectedDistance),
      'preference': selectedPreference,
    });
  }

  String _getPriceLabel(double value) {
    if (value <= 1) return '1만원 미만';
    if (value <= 2) return '2만원대';
    return '3만원 이상';
  }

  String _getDistanceLabel(double value) {
    if (value <= 5) return '5분 이내';
    if (value <= 10) return '10분';
    if (value <= 15) return '15분';
    return '20분 이상';
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
                    selectedTypes: selectedFoodTypes,
                    onSelectionChanged: (types) {
                      setState(() => selectedFoodTypes = types);
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
                  const SizedBox(height: 32),
                  PreferenceSelector(
                    selectedPreference: selectedPreference,
                    onSelected: (pref) {
                      setState(() => selectedPreference = pref);
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
                    onPressed: () => _searchRestaurants(useDefault: true),
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
