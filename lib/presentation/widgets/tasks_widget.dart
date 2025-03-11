import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../utils/decorations.dart';

class TaskTripWidget extends StatelessWidget {
  BuildContext context;
  TaskTripDTO task;

  TaskTripWidget({super.key, required this.context, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: DecorationsCustom().silverBoxRoundedCorners(),
      child: Row(
        children: [
          _leftInfo(),
          const SizedBox(width: 20),
          _rightInfo(),
        ],
      ),
    );
  }

  Widget _leftInfo() {
    final text = "${task.trip!.startCity} - ${task.trip!.endCity}";
    final textStyle = StyledText().descriptionText();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 4),
              Expanded(
                child: marqueeCustom(text: text, textStyle: textStyle),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 6),
              const Icon(Icons.description_outlined, size: 14),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  task.taskTrip!.description.isNotEmpty
                      ? task.taskTrip!.description
                      : AppStrings.noDescription,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: StyledText().descriptionText(
                    fontSize: 12,
                    fontWeight: StyledText().regular,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on_outlined,
              color: greenColor,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              // "${task.price.toStringAsFixed(0)} ден",
              // TO:DO price missing in TaskTrip model
              "200 ден",
              style: StyledText().descriptionText(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // TO:DO implement a possible pop-up here,
        // Main goal: viewing entire description with bigger letters,
        // Possible additions: view location on map or smth
        customArrowButton(
          text: AppStrings.viewDetails,
          fontSize: 12,
          //TO:DO add screen nav and proper event emit
          onPressed: () => Navigator.pop,
        ),
      ],
    );
  }
}
