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
        name: '강남 맛집 1',
        type: '한식',
        address: '서울시 강남구 역삼동 123-45',
        rating: 4.5,
        link: 'https://naver.com',
        distance: 500, // 5분
        imageUrl: null,
      ),
      // ... 4개 더 추가 ...
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return ListTile(
          onTap: () => _onRestaurantTap(restaurant),
          title: Text(restaurant.name),
          subtitle: Text(restaurant.address),
          trailing: IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => launchUrl(Uri.parse(restaurant.link)),
          ),
        );
      },
    );
  }
}
