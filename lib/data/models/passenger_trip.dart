import 'package:travel_app/data/enums/trip_status_for_client.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/service/map_service.dart';

import '../../service/interface/LocationToAddress.dart';
import 'location.dart';

class PassengerTrip implements LocationToAddress {
  final String id;
  final Location startLocation;
  final Location endLocation;
  ClientTripStatus tripStatus;
  final UserModel user;
  final String tripId;

  PassengerTrip(
      {this.id = "",
      required this.startLocation,
      required this.endLocation,
      this.tripStatus = ClientTripStatus.RESERVED,
      required this.user,
      required this.tripId});

  @override
  Future<String?> get startLocationAddress async {
    return await MapService().getAddressFromCoordinates(
        startLocation.latitude, startLocation.longitude);
  }

  @override
  Future<String?> get endLocationAddress async {
    return await MapService()
        .getAddressFromCoordinates(endLocation.latitude, endLocation.longitude);
  }

  PassengerTrip.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        startLocation = Location.fromJson(data['startLocation']),
        endLocation = Location.fromJson(data['endLocation']),
        tripStatus = ClientTripStatus.values[data['tripStatus'] ?? 0],
        user = UserModel.fromJson(data['user']),
        tripId = data['tripId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'startLocation': startLocation.toJson(),
        'endLocation': endLocation.toJson(),
        'tripStatus': tripStatus.index,
        'user': user.toJson(),
        'tripId': tripId
      };
}
