import 'dart:math' as math;

import 'package:geohash/geohash.dart';

// Javascript version:
// https://levelup.gitconnected.com/nearby-location-queries-with-cloud-firestore-e7f4a2f18f9d

class LocationUtils {
  static final double earth_radius = 3960.0;
  static final double degrees_to_radians = math.pi / 180.0;
  static final double radians_to_degrees = 180.0 / math.pi;

  static Map<String, String> getGeohashRange(
      {double latitude, double longitude, double distance}) {
    math.pi * 100;
    double distLat = (distance / earth_radius) * radians_to_degrees;
    double r = earth_radius * math.cos(latitude * degrees_to_radians);
    double distLon = (distance / r) * radians_to_degrees;
    double lat = 0.0144927536231884; // degrees latitude per mile
    double lon = 0.0181818181818182; // degrees longitude per mile

//    print("distLat: " + distLat.toString());
//    print("oldDistLat: " + (lat * distance).toString());
//    print("totalLat: " + (latitude + distLat).toString());
//
//    print("distLon: " + distLon.toString());
//    print("oldDistLon: " + (lon * distance).toString());
//    print("totalLon: " + (longitude + distLon).toString());

    double lowerLat = latitude - distLat;
    double lowerLon = longitude - distLon;

    double upperLat = latitude + distLat;
    double upperLon = longitude + distLon;

    String lower = Geohash.encode(lowerLat, lowerLon);
    String upper = Geohash.encode(upperLat, upperLon);

    return {"lower": lower, "upper": upper};
  }
}
