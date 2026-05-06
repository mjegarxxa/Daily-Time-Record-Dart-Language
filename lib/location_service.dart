import 'package:geolocator/geolocator.dart';

class LocationService {
  // Define the Office Location (RRJ Office)
  // You can change these to the exact coordinates of your site
  static const double targetLatitude = 14.5954; 
  static const double targetLongitude = 121.1005;
  
  // Define the Geofence Radius (in meters)
  static const double geofenceRadius = 30.0; 

  // The logic to check position
  static Future<bool> isWithinGeofence() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLatitude,
      targetLongitude,
    );

    return distance <= geofenceRadius;
  }
}