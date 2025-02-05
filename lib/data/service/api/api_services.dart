import 'package:flutter/material.dart';
import 'package:travel_app/data/mock/mock_trips.dart';

class ApiServices {
  ApiServices._instantiate();
  static final ApiServices instance = ApiServices._instantiate();

  Future<dynamic> getDriverRides() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return mockTrips;
    } on Exception catch (err) {
      debugPrint("Get driver rides exception $err");
      return false;
    }
  }
}
