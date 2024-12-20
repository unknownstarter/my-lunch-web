import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  Future<Position> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  Future<String> getAddressFromPosition(Position position) async {
    return await _locationService.getAddressFromPosition(position);
  }
}
