import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';

class NaverApiService {
  static const String baseUrl = String.fromEnvironment('API_URL',
      defaultValue: 'https://mylunchweb.netlify.app/.netlify/functions/search');

  Future<List<Restaurant>> searchRestaurants(
    String query, {
    required String location,
    required double maxDistance,
    required String priceRange,
  }) async {
    try {
      final queryParams = Uri(queryParameters: {
        'query': query,
        'location': location,
        'maxDistance': maxDistance.toString(),
        'priceRange': priceRange,
      }).query;

      final response = await http.get(
        Uri.parse('$baseUrl?$queryParams'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = List<Map<String, dynamic>>.from(data['items']);
        return items.map((item) => Restaurant.fromJson(item)).toList();
      } else {
        throw Exception('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 에러: $e');
      return _getDefaultResults();
    }
  }

  List<Restaurant> _getDefaultResults() {
    return [
      Restaurant(
        name: '맛있는 한식당',
        type: '한식',
        address: '서울시 강남구 역삼동 123-45',
        rating: 4.5,
        link: 'https://map.naver.com',
        distance: 500,
        imageUrl: 'https://via.placeholder.com/300x200',
      ),
      Restaurant(
        name: '분위기 좋은 식당',
        type: '한식',
        address: '서울시 강남구 역삼동 234-56',
        rating: 4.3,
        link: 'https://map.naver.com',
        distance: 700,
        imageUrl: 'https://via.placeholder.com/300x200',
      ),
      Restaurant(
        name: '맛집 레스토랑',
        type: '한식',
        address: '서울시 강남구 역삼동 345-67',
        rating: 4.7,
        link: 'https://map.naver.com',
        distance: 300,
        imageUrl: 'https://via.placeholder.com/300x200',
      ),
    ];
  }
}
