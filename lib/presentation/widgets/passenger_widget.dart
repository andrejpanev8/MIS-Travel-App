import 'package:flutter/material.dart';

import '../../data/models/passenger_trip.dart';
import '../../utils/decorations.dart';

class PassengerWidget extends StatelessWidget {
  PassengerTrip passenger;
  PassengerWidget({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: DecorationsCustom().silverBoxRoundedCorners());
  }
}
