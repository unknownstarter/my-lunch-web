import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // 페이지 조회 이벤트
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // 검색 이벤트
  Future<void> logSearch({
    required List<String> foodTypes,
    required String location,
    required String price,
    required String distance,
    String? preference,
  }) async {
    await _analytics.logEvent(
      name: 'search_restaurants',
      parameters: {
        'food_types': foodTypes.join(','),
        'location': location,
        'price': price,
        'distance': distance,
        'preference': preference ?? 'none',
      },
    );
  }

  // 식당 선택 이벤트
  Future<void> logSelectRestaurant({
    required String restaurantName,
    required String type,
    required String location,
  }) async {
    await _analytics.logEvent(
      name: 'select_restaurant',
      parameters: {
        'restaurant_name': restaurantName,
        'type': type,
        'location': location,
      },
    );
  }

  // 필터 변경 이벤트
  Future<void> logFilterChange({
    required String filterName,
    required String value,
  }) async {
    await _analytics.logEvent(
      name: 'filter_change',
      parameters: {
        'filter_name': filterName,
        'value': value,
      },
    );
  }
}
