import 'package:travel_app/data/enums/trip_status_for_client.dart';
import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/user.dart';

class TaskTrip {
  final String id;
  final Location startLocation;
  final Location endLocation;
  final String description;
  final UserModel user;
  ClientTripStatus tripStatus;
  final String tripId;

  TaskTrip(
      {this.id = "",
      required this.startLocation,
      required this.endLocation,
      this.description = "",
      required this.user,
      this.tripStatus = ClientTripStatus.RESERVED,
      required this.tripId});

  TaskTrip.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        startLocation = Location.fromJson(data['startLocation']),
        endLocation = Location.fromJson(data['endLocation']),
        description = data['description'] ?? "",
        user = UserModel.fromJson(data['user']),
        tripStatus = ClientTripStatus.values[data['tripStatus'] ?? 0],
        tripId = data['tripId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'startLocation': startLocation.toJson(),
        'endLocation': endLocation.toJson(),
        'description': description,
        'user': user.toJson(),
        'tripStatus': tripStatus.index,
        'tripId': tripId
      };
}
