import 'package:flutter/foundation.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> checkLocationStatus(locationStreamController) async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      locationStreamController.sink.add(s);
    } else {
      locationStreamController.sink.add(locationStatus);
    }
  }

  // FOR FETCHING CURRENT LOCATION
  Future<void> getLocation(currentLatitude, currentLongitude) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // setState(() {
      //   currentLatitude = position.latitude;
      //   currentLongitude = position.longitude;
      // });
      if (kDebugMode) {
        print('latitude : $currentLatitude');
        print('longitude : $currentLongitude');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }
}
