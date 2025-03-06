import '../models/location.dart';

class ReserveAdhocDeliveryDTO {
  final String pickUpPhoneNumber;
  final Location startLocation;
  final String dropOffPhoneNumber;
  final Location endLocation;
  final String tripId;
  final String firstName;
  final String lastName;
  final String description;

  //TODO remove client id and call the other event reserve delivery when there's client id
  ReserveAdhocDeliveryDTO({
    required this.pickUpPhoneNumber,
    required this.startLocation,
    required this.dropOffPhoneNumber,
    required this.endLocation,
    required this.tripId,
    required this.firstName,
    required this.lastName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "pickUpPhoneNumber": pickUpPhoneNumber,
      "startLocation": startLocation.toJson(),
      "dropOffPhoneNumber": dropOffPhoneNumber,
      "endLocation": endLocation.toJson(),
      "tripId": tripId,
      "firstName": firstName,
      "lastName": lastName,
      "description": description,
    };
  }
}
