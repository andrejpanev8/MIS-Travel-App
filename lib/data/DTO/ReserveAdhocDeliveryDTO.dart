import '../models/location.dart';

class ReserveAdhocDeliveryDTO {
  String taskTripId;
  final String pickUpPhoneNumber;
  final Location startLocation;
  final String dropOffPhoneNumber;
  final Location endLocation;
  final String tripId;
  final String? clientId;
  final String firstName;
  final String lastName;
  final String description;

  ReserveAdhocDeliveryDTO({
    this.taskTripId = "",
    required this.pickUpPhoneNumber,
    required this.startLocation,
    required this.dropOffPhoneNumber,
    required this.endLocation,
    required this.tripId,
    required this.clientId,
    required this.firstName,
    required this.lastName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "taskTripId": taskTripId ?? "",
      "pickUpPhoneNumber": pickUpPhoneNumber,
      "startLocation": startLocation.toJson(),
      "dropOffPhoneNumber": dropOffPhoneNumber,
      "endLocation": endLocation.toJson(),
      "tripId": tripId,
      "clientId": clientId,
      "firstName": firstName,
      "lastName": lastName,
      "description": description,
    };
  }
}
