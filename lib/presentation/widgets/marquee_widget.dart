import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../utils/functions.dart';

Widget marqueeCustom(
    {required String text, required TextStyle textStyle, double height = 24}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isOverflowing = Functions.isTextOverflowing(
        text,
        textStyle,
        constraints.maxWidth,
      );
      return SizedBox(
        height: height,
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
  );
}
