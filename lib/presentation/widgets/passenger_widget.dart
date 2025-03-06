import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';

import '../../data/models/passenger_trip.dart';
import '../../utils/decorations.dart';

class PassengerWidget extends StatelessWidget {
  final PassengerTrip passenger;
  const PassengerWidget({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: DecorationsCustom().silverBoxRoundedCorners(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_leftInfo(), _rightInfo()],
      ),
    );
  }

  Widget _leftInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline),
              const SizedBox(width: 8),
              Text(
                "${passenger.user.firstName} ${passenger.user.lastName}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              //TO:DO Change with resolved location
              Text(
                "${passenger.startLocation}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              //TO:DO Change with resolved location
              Text(
                "${passenger.endLocation}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo() {
    return customArrowButton(
      text: passenger.user.phoneNumber,
      customIcon: Icons.local_phone_outlined,
    );
  }
}
