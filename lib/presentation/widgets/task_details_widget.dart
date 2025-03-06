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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: DecorationsCustom().silverBoxRoundedCorners(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 8),
                Text("${taskTrip.user.firstName} ${taskTrip.user.lastName}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                //TO:DO Change with resolved location
                Expanded(
                  child: Text(taskTrip.startLocation.toString(),
                      style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                //TO:DO Change with resolved location
                Expanded(
                  child: Text(taskTrip.endLocation.toString(),
                      style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.description_outlined),
                SizedBox(width: 8),
                Text(AppStrings.description, style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                taskTrip.description.isNotEmpty
                    ? taskTrip.description
                    : AppStrings.noDescription,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: customArrowButton(
                      customIcon: Icons.local_phone_outlined,
                      iconColor: blueDeepColor,
                      border: const BorderSide(color: blueDeepColor),
                      backgroundColor: silverColorLight,
                      textColor: blackColor,
                      text: taskTrip.user.phoneNumber,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: customArrowButton(
                      customIcon: Icons.local_phone_outlined,
                      text: taskTrip.user.phoneNumber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
