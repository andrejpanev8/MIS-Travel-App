import 'package:travel_app/data/models/passenger_trip.dart';

import '../models/trip.dart';

class PassengerTripDTO {
  late PassengerTrip? passengerTrip;
  late Trip trip;

  PassengerTripDTO({this.passengerTrip, required this.trip});

  factory PassengerTripDTO.fromJson(Map<String, dynamic> json) {
    return PassengerTripDTO(
      passengerTrip: json['passengerTrip'] != null
          ? PassengerTrip.fromJson(json['passengerTrip'])
          : null,
      trip: Trip.fromJson(json['trip']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (passengerTrip != null) {
      data['passengerTrip'] = passengerTrip!.toJson();
    }
    return data;
  }
}
