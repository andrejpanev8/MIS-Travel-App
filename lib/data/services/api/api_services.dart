import 'package:flutter/material.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/mock/mock_task_trips.dart';
import 'package:travel_app/data/mock/mock_trips.dart';
import 'package:travel_app/data/mock/mock_users.dart';

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

  Future<dynamic> getDriverDeliveries() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return mockTaskTrips;
    } on Exception catch (err) {
      debugPrint("Get driver rides exception $err");
      return false;
    }
  }

  Future<dynamic> getDrivers() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return mockUsers.where((user) => user.role == UserRole.DRIVER);
    } on Exception catch (err) {
      debugPrint("Get driver rides exception $err");
      return false;
    }
  }
}
