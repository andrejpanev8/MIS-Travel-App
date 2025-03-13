import 'package:flutter/material.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../utils/decorations.dart';
import '../../utils/functions.dart';

class TaskTripWidget extends StatelessWidget {
  BuildContext context;
  TaskTripDTO taskTrip;

  TaskTripWidget({super.key, required this.context, required this.taskTrip});

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
    final text = "${taskTrip.trip!.startCity} - ${taskTrip.trip!.endCity}";
    final textStyle = StyledText().descriptionText();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  semanticLabel: AppStrings.locationIconTooltip, size: 22),
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
                  taskTrip.taskTrip!.description.isNotEmpty
                      ? taskTrip.taskTrip!.description
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
              "${taskTrip.trip?.deliveryPrice} ${AppStrings.denars}",
              style: StyledText().descriptionText(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        customArrowButton(
            text: AppStrings.viewDetails,
            fontSize: 12,
            onPressed: () => {
                  Functions.emitUserEvent(
                      context: context,
                      event: GetDeliveryDetails(tripId: taskTrip.trip!.id)),
                  Navigator.pushNamed(context, "/deliveryDetails",
                      arguments: taskTrip.taskTrip)
                }),
      ],
    );
  }
}
