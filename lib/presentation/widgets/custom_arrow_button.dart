import 'package:flutter/material.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../utils/color_constants.dart';

Widget customArrowButton(
    {String text = "",
    Function()? onPressed,
    Color backgroundColor = blueDeepColor,
    Color iconColor = whiteColor,
    Color splashColor = silverColor,
    IconData? customIcon,
    Color? textColor,
    BorderSide? border,
    double? fontSize}) {
  return TextButton.icon(
    onPressed: onPressed,
    label: Text(text,
        style:
            StyledText().descriptionText(fontSize: fontSize, color: textColor)),
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: border ?? BorderSide.none)),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return splashColor;
          }
          return null;
        },
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      minimumSize: WidgetStatePropertyAll(Size(0, 30)),
    ),
    icon: _getProperIcon(customIcon, iconColor),
    iconAlignment: customIcon == null ? IconAlignment.end : IconAlignment.start,
  );
}

Widget _getProperIcon(IconData? customIcon, Color iconColor) {
  return customIcon != null
      ? Icon(
          customIcon,
          color: iconColor,
        )
      : Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(-1.0, 1.0), // Flip arrow icon horizontally
          child: Icon(
            Icons.arrow_back,
            color: iconColor,
            size: 14,
          ),
        );
}
