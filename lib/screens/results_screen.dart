import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../models/restaurant.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/analytics_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final AnalyticsService _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.logScreenView(screenName: 'results_screen');
  }

  List<Restaurant> _getDefaultResults() {
    return [
      Restaurant(
        name: '강남 맛있는 식당',
        type: '한식',
        address: '서울시 강남구 강남대로 123',
        rating: 4.5,
        link: 'https://map.naver.com/p/entry/place/1234567890',
        distance: 300,
        imageUrl: null,
      ),
      Restaurant(
        name: '역삼 찌화요리',
        type: '중식',
        address: '서울시 강남구 역삼로 789',
        rating: 4.4,
        link: 'https://map.naver.com/p/entry/place/2345678901',
        distance: 400,
        imageUrl: null,
      ),
      Restaurant(
        name: '일품 스시',
        type: '일식',
        address: '서울시 강남구 테헤란로 321',
        rating: 4.6,
        link: 'https://map.naver.com/p/entry/place/3456789012',
        distance: 600,
        imageUrl: null,
      ),
      Restaurant(
        name: '역삼 찌개마을',
        type: '한식',
        address: '서울시 강남구 역삼로 456',
        rating: 4.3,
        link: 'https://map.naver.com/p/entry/place/0987654321',
        distance: 500,
        imageUrl: null,
      ),
      Restaurant(
        name: '파스타 하우스',
        type: '양식',
        address: '서울시 강남구 논현로 159',
        rating: 4.2,
        link: 'https://map.naver.com/p/entry/place/4567890123',
        distance: 700,
        imageUrl: null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '오늘의 점심',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: Provider.of<SearchProvider>(context, listen: false)
            .searchRestaurants(
          foodTypes: args['foodTypes'],
          location: args['location'],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final defaultResults = _getDefaultResults();
            return _buildRestaurantList(defaultResults);
          }

          final restaurants = snapshot.data!;
          if (restaurants.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다'));
          }

          return _buildRestaurantList(restaurants);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.deepPurple,
        label: const Text('다시 추천받기'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildRestaurantList(List<Restaurant> restaurants) {
    List<Restaurant> displayRestaurants;
    if (restaurants.isEmpty) {
      // 검색 결과가 없는 경우 기본값 5개
      displayRestaurants = _getDefaultResults().take(5).toList();
    } else if (restaurants.length < 5) {
      // 검색 결과가 5개 미만인 경우, 기본값으로 보충
      displayRestaurants = [
        ...restaurants,
        ..._getDefaultResults().take(5 - restaurants.length)
      ];
    } else {
      // 검색 결과가 5개 이상인 경우, 최대 10개까지 표시
      displayRestaurants = restaurants.take(10).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = displayRestaurants[index];
        final distance = (restaurant.distance / 1000).toStringAsFixed(1);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await launchUrlString(
                  restaurant.link,
                  mode: LaunchMode.externalApplication,
                );
                if (!mounted) return;
                _analytics.logSelectRestaurant(
                  restaurantName: restaurant.name,
                  type: restaurant.type,
                  location: restaurant.address,
                );
              } catch (e) {
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('링크를 열 수 없습니다')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '추천 결과 ${index + 1}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    restaurant.address,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${distance}km',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          try {
                            await launchUrlString(
                              restaurant.link,
                              mode: LaunchMode.externalApplication,
                            );
                            if (!mounted) return;
                            _analytics.logSelectRestaurant(
                              restaurantName: restaurant.name,
                              type: restaurant.type,
                              location: restaurant.address,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(content: Text('링크를 열 수 없습니다')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 36),
                        ),
                        child: const Text('바로가기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
