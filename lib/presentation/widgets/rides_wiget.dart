import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/text_styles.dart';
import 'dart:ui' as ui;

class RidesWidget extends StatelessWidget {
  final String startCity;
  final String endCity;
  final DateTime startTime;
  final int passengers;

  const RidesWidget({
    super.key,
    required this.startCity,
    required this.endCity,
    required this.startTime,
    required this.passengers,
  });

  bool _isTextOverflowing(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: silverColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [_leftInfo(), _rightInfo()],
      ),
    );
  }

  Widget _leftInfo() {
    String formattedDate = DateFormat('dd.MM.yyyy - HH.mm').format(startTime);
    final text = "$startCity - $endCity";
    final textStyle = StyledText().descriptionText(
      color: blackColor,
      fontSize: 20,
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
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: StyledText().descriptionText(
                  color: blackColor,
                  fontSize: 12,
                  fontWeight: StyledText().regular,
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
          children: [
            const Icon(
              Icons.people_alt_outlined,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              "$passengers Passengers",
              style: StyledText().descriptionText(
                fontSize: 14,
                color: blackColor,
              ),
            ),
          ],
        ),
        customArrowButton(text: "Reserve", onPressed: () {}),
      ],
    );
  }
}
