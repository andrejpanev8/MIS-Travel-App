import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';
import 'package:travel_app/utils/functions.dart';

import '../../bloc/user_bloc/user_bloc.dart';
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
        children: [_leftInfo(), _rightInfo(context)],
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
              Expanded(child: _futureBuilder(passenger.startLocationAddress)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Expanded(child: _futureBuilder(passenger.endLocationAddress)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo(BuildContext context) {
    return customArrowButton(
      text: passenger.user.phoneNumber,
      customIcon: Icons.local_phone_outlined,
      onPressed: () => Functions.emitUserEvent(
        context: context,
        event: CallPhone(passenger.user.phoneNumber),
      ),
    );
  }

  // Method needed to asynchronously fetch the address from the coordinates
  Widget _futureBuilder(Future<String?> address) {
    return FutureBuilder<String?>(
        future: address,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Fetching address...");
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Text("Address not available");
          }
          return marqueeCustom(
              text: snapshot.data!, textStyle: TextStyle(fontSize: 14));
        });
  }
}
