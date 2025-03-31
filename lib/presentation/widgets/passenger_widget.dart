import 'package:flutter/material.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';
import 'package:travel_app/utils/functions.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/passenger_trip.dart';
import '../../utils/decorations.dart';

class PassengerWidget extends StatelessWidget {
  final PassengerTrip passengerTrip;
  const PassengerWidget({super.key, required this.passengerTrip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Functions.emitUserEvent(
            context: context,
            event: GetClientRideDetails(tripId: passengerTrip.tripId));
        Functions.emitMapEvent(
            context: context,
            event: AddressDoubleEntryEvent(
              passengerTrip.startLocation.address,
              passengerTrip.endLocation.address,
            ));
        Navigator.pushNamed(
          context,
          '/clientRideDetails',
          arguments: passengerTrip,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: DecorationsCustom().silverBoxRoundedCorners(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_leftInfo(), SizedBox(width: 10), _rightInfo(context)],
        ),
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
                "${passengerTrip.user.firstName} ${passengerTrip.user.lastName}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Expanded(
                  child: marqueeCustom(
                      text: passengerTrip.startLocation.address ?? "",
                      textStyle: TextStyle(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Expanded(
                  child: marqueeCustom(
                      text: passengerTrip.endLocation.address ?? "",
                      textStyle: TextStyle(fontSize: 14))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo(BuildContext context) {
    return customArrowButton(
      text: passengerTrip.user.phoneNumber,
      customIcon: Icons.local_phone_outlined,
      onPressed: () => Functions.emitUserEvent(
        context: context,
        event: CallPhone(passengerTrip.user.phoneNumber),
      ),
    );
  }
}
