import 'dart:math';

class QiblaLocator {
  static double calculateQiblaDirection(double latitude, double longitude) {
    // Latitude and longitude of Mecca (in degrees)
    double latMecca = 21.4225;
    double lonMecca = 39.8262;

    // Convert degrees to radians
    double currentLat = _degreesToRadians(latitude);
    double currentLong = _degreesToRadians(longitude);
    double lat2 = _degreesToRadians(latMecca);
    double lon2 = _degreesToRadians(lonMecca);

    // Calculate the difference in longitude
    double dLon = lon2 - currentLong;

    // Calculate the Qibla direction
    double y = sin(dLon) * cos(lat2);
    double x =
        cos(currentLat) * sin(lat2) - sin(currentLat) * cos(lat2) * cos(dLon);
    double qiblaDirection = atan2(y, x);

    // Convert radians to degrees
    qiblaDirection = _radiansToDegrees(qiblaDirection);

    // Adjust the Qibla direction to be in the range [0, 360)
    if (qiblaDirection < 0) {
      qiblaDirection += 360;
    }
    return qiblaDirection;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static double _radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }
}

// void main() {
//   double latitude = 21.705; // Bharuch latitude
//   double longitude = 72.99; // Bharuch longitude
//
//   double qiblaDirection = QiblaLocator.calculateQiblaDirection(latitude, longitude);
//   print('Qibla direction from the given location: $qiblaDirection degrees');
// }
