import 'package:travel_app/data/enums/passenger_trip_status.dart';
import 'package:travel_app/data/models/user.dart';

import 'location.dart';

class PassengerTrip {
    int id;
    final Location startLocation;
    final Location endLocation;
    PassengerTripStatus tripStatus;
    final User user;

    PassengerTrip({
      required this.id,
      required this.startLocation,
      required this.endLocation,
      required this.tripStatus,
      required this.user
    });

    PassengerTrip.fromJson(Map<String, dynamic> data)
        : id = data['id'],
          startLocation = Location.fromJson(data['startLocation']),
          endLocation = Location.fromJson(data['endLocation']),
          tripStatus = PassengerTripStatus.values.firstWhere(
                (e) => e.toString().split('.').last == data['tripStatus'],
            orElse: () => PassengerTripStatus.CANCELED,
          ),
          user = User.fromJson(data['user']);

    Map<String, dynamic> toJson() => {
      'id': id,
      'startLocation': startLocation.toJson(),
      'endLocation': endLocation.toJson(),
      'tripStatus': tripStatus.toString().split('.').last,
      'user': user.toJson()
    };

}