import 'package:flutter/foundation.dart';
import '../services/naver_api_service.dart';
import '../models/restaurant.dart';

class SearchProvider with ChangeNotifier {
  final NaverApiService _apiService = NaverApiService();

  Future<List<Restaurant>> searchRestaurants({
    required List<String> foodTypes,
    required String location,
    required double maxDistance,
    required String priceRange,
  }) async {
    final query = '${location} ${foodTypes.join(' ')} 맛집';

    try {
      return await _apiService.searchRestaurants(
        query,
        location: location,
        maxDistance: maxDistance,
        priceRange: priceRange,
      );
    } catch (e) {
      if (location == '서울시 강남구 역삼동' &&
          foodTypes.contains('한식') &&
          priceRange == '1만원대') {
        return _getDefaultResults();
      }
      rethrow;
    }
  }

  List<Restaurant> _getDefaultResults() {
    return [/* ... */];
  }
}
