import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/user.dart';

class TaskTrip {
  int id;
  final Location startLocation;
  final Location endLocation;
  final String description;
  final User user;

  TaskTrip({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    this.description = "",
    required this.user
  });

  TaskTrip.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        startLocation = Location.fromJson(data['startLocation']),
        endLocation = Location.fromJson(data['endLocation']),
        description = data['description'] ?? "",
        user = User.fromJson(data['user']);


  Map<String, dynamic> toJson() => {
    'id': id,
    'startLocation': startLocation.toJson(),
    'endLocation': endLocation.toJson(),
    'description': description,
    'user' : user.toJson()
  };

}