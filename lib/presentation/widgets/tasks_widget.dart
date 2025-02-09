import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

class TaskTripWidget extends StatelessWidget {
  final String startCity;
  final String endCity;
  final String description;
  final double price;

  const TaskTripWidget({
    super.key,
    required this.startCity,
    required this.endCity,
    required this.description,
    required this.price,
  });

  bool _isTextOverflowing(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: silverColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
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
    final text = "$startCity - $endCity";
    final textStyle = StyledText().descriptionText(
      color: blackColor,
      fontSize: 16,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 4),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isOverflowing = _isTextOverflowing(
                      text,
                      textStyle,
                      constraints.maxWidth,
                    );
                    return SizedBox(
                      height: 24,
                      child: isOverflowing
                          ? Marquee(
                              text: text,
                              style: textStyle,
                              pauseAfterRound: Durations.medium1,
                              startAfter: Durations.medium1,
                              blankSpace: 20,
                              velocity: 30,
                            )
                          : Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: textStyle,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 6),
              const Icon(
                  Icons.description_outlined,
                  size: 14
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: StyledText().descriptionText(
                    color: blackColor,
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
              "${price.toStringAsFixed(0)} ден",
              style: StyledText().descriptionText(
                fontSize: 12,
                color: blackColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        customArrowButton(
          text: "View details",
          fontSize: 12,
          onPressed: () {},
        ),
      ],
    );
  }
}
