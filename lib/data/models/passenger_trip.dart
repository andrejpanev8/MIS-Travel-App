import 'package:travel_app/data/enums/trip_status_for_client.dart';
import 'package:travel_app/data/models/user.dart';

import 'location.dart';

class PassengerTrip {
  final String id;
  final Location startLocation;
  final Location endLocation;
  ClientTripStatus tripStatus;
  final UserModel user;

  PassengerTrip(
      {this.id = "",
      required this.startLocation,
      required this.endLocation,
      required this.tripStatus,
      required this.user});

  PassengerTrip.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        startLocation = Location.fromJson(data['startLocation']),
        endLocation = Location.fromJson(data['endLocation']),
        tripStatus = ClientTripStatus.values[data['tripStatus'] ?? 0],
        user = UserModel.fromJson(data['user']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'startLocation': startLocation.toJson(),
        'endLocation': endLocation.toJson(),
        'tripStatus': tripStatus.index,
        'user': user.toJson()
      };
}
