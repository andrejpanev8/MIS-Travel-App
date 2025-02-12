import 'package:flutter/material.dart';

import '../../data/models/task_trip.dart';
import '../../utils/decorations.dart';

class TaskTripDetailsWidget extends StatelessWidget {
  final TaskTrip taskTrip;
  const TaskTripDetailsWidget({super.key, required this.taskTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationsCustom().silverBoxRoundedCorners(),
    );
  }
}
