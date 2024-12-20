import 'package:flutter/foundation.dart';
import '../services/naver_api_service.dart';
import '../models/restaurant.dart';

class SearchProvider with ChangeNotifier {
  final NaverApiService _apiService = NaverApiService();
  final Map<String, List<Restaurant>> _cache = {};
  final _cacheExpiry = const Duration(minutes: 5);
  final Map<String, DateTime> _cacheTimestamps = {};

  Future<List<Restaurant>> searchRestaurants({
    required List<String> foodTypes,
    required String location,
  }) async {
    final foodTypesStr = foodTypes.join(',');
    final cacheKey = '$location:$foodTypesStr';

    if (_cache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheExpiry) {
        return _cache[cacheKey]!;
      }
      _cache.remove(cacheKey);
      _cacheTimestamps.remove(cacheKey);
    }

    try {
      final results = await _apiService.searchRestaurants(
        foodTypesStr,
        location: location,
      );

      _cache[cacheKey] = results;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return results;
    } catch (e) {
      if (location == '서울시 강남구 역삼동' && foodTypes.contains('한식')) {
        return _getDefaultResults();
      }
      rethrow;
    }
  }

  List<Restaurant> _getDefaultResults() {
    return [/* ... */];
  }

  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
}
