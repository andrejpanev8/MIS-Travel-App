import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';

import '../../data/models/task_trip.dart';
import '../../utils/decorations.dart';

class TaskTripDetailsWidget extends StatelessWidget {
  final TaskTrip taskTrip;
  const TaskTripDetailsWidget({super.key, required this.taskTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationsCustom().silverBoxRoundedCorners(),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person_outline),
              Text("${taskTrip.user.firstName} ${taskTrip.user.lastName}")
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              // TO:DO Change with resolved location
              Text("${taskTrip.startLocation}")
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              // TO:DO Change with resolved location
              Text("${taskTrip.endLocation}")
            ],
          ),
          Row(
            children: [Icon(Icons.description_outlined), Text(AppStrings.description)],
          ),
          Row(
            children: [Text(taskTrip.description)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: customArrowButton(
                    customIcon: Icons.local_phone_outlined,
                    iconColor: blueDeepColor,
                    border: BorderSide(color: blueDeepColor),
                    backgroundColor: silverColorLight,
                    textColor: blackColor,
                    text: taskTrip.user.phoneNumber),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: customArrowButton(
                    customIcon: Icons.local_phone_outlined,
                    text: taskTrip.user.phoneNumber),
              )
            ],
          )
        ],
      ),
    );
  }
}
