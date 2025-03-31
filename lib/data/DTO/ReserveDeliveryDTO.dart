// ignore_for_file: file_names

import '../models/location.dart';

class ReserveDeliveryDTO {
  final String tripId;
  final String pickUpPhoneNumber;
  final Location startLocation;
  final String dropOffPhoneNumber;
  final Location endLocation;
  final String description;

  ReserveDeliveryDTO({
    required this.tripId,
    required this.pickUpPhoneNumber,
    required this.startLocation,
    required this.dropOffPhoneNumber,
    required this.endLocation,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "tripId": tripId,
      "pickUpPhoneNumber": pickUpPhoneNumber,
      "startLocation": startLocation.toJson(),
      "dropOffPhoneNumber": dropOffPhoneNumber,
      "endLocation": endLocation.toJson(),
      "description": description,
    };
  }
}
