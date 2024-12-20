import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';
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
        link: 'https://map.naver.com',
        distance: 300,
        imageUrl: null,
      ),
      Restaurant(
        name: '역삼 찌개마을',
        type: '한식',
        address: '서울시 강남구 역삼로 456',
        rating: 4.3,
        link: 'https://map.naver.com',
        distance: 500,
        imageUrl: null,
      ),
      // ... 더 많은 기본 결과 추가 ...
    ];
  }

  void _onRestaurantTap(Restaurant restaurant) {
    _analytics.logSelectRestaurant(
      restaurantName: restaurant.name,
      type: restaurant.type,
      location: restaurant.address,
    );
    // 기존 코드...
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
          maxDistance: args['distance'],
          priceRange: args['price'],
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
    final displayRestaurants = restaurants.take(10).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = displayRestaurants[index];
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
            onTap: () => _onRestaurantTap(restaurant),
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
                        restaurant.rating.toString(),
                        style: const TextStyle(
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
                        '${(restaurant.distance / 100).toStringAsFixed(1)}km',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => launchUrl(Uri.parse(restaurant.link)),
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
