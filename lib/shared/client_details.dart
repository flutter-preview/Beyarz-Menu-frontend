import 'package:flutter/material.dart';

typedef Coord = Set<List<double>>;

class ClientDetails with ChangeNotifier {
  double? latitude;
  double? longitude;

  void setCoords(double lat, double lon) {
    latitude = lat;
    longitude = lon;
    notifyListeners();
  }
}
