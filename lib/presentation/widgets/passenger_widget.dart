import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/utils/color_constants.dart';

import '../../data/models/passenger_trip.dart';
import '../../utils/decorations.dart';

class PassengerWidget extends StatelessWidget {
  PassengerTrip passenger;
  PassengerWidget({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
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
      children: [
        Row(
          children: [
            Icon(Icons.person_outline),
            Text("${passenger.user.firstName} ${passenger.user.lastName}")
          ],
        ),
        Row(
          children: [
            Icon(Icons.location_on_outlined),
            //TO:DO Change with resolved location
            Text("${passenger.startLocation}")
          ],
        ),
        Row(
          children: [
            Icon(Icons.location_on_outlined),
            //TO:DO Change with resolved location
            Text("${passenger.endLocation}")
          ],
        )
      ],
    ));
  }

  Widget _rightInfo() {
    return customArrowButton(
        text: passenger.user.phoneNumber,
        customIcon: Icons.local_phone_outlined);
  }
}
