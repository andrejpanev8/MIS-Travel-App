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
    bool noIcon = false,
    double? iconSize,
    Color? textColor = whiteColor,
    BorderSide? border,
    double? fontSize,
    double horizontalPadding = 10,
    double verticalPadding = 4}) {
  return noIcon
      ? TextButton(
          onPressed: onPressed,
          style: _buttonStyle(backgroundColor, splashColor, border, horizontalPadding, verticalPadding),
          child: Text(
            text,
            style: StyledText()
                .descriptionText(color: textColor, fontSize: fontSize),
          ),
        )
      : TextButton.icon(
          onPressed: onPressed,
          label: Text(text,
              style: StyledText()
                  .descriptionText(fontSize: fontSize, color: textColor)),
          style: _buttonStyle(backgroundColor, splashColor, border, horizontalPadding, verticalPadding),
          icon: _getProperIcon(customIcon, iconColor, iconSize),
          iconAlignment:
              customIcon == null ? IconAlignment.end : IconAlignment.start,
        );
}

Widget _getProperIcon(IconData? customIcon, Color iconColor, double? iconSize) {
  return customIcon != null
      ? Icon(
          customIcon,
          color: iconColor,
          size: iconSize,
        )
      : Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(-1.0, 1.0), // Flip arrow icon horizontally
          child: Icon(
            Icons.arrow_back,
            color: iconColor,
            size: iconSize ?? 14,
          ),
        );
}

ButtonStyle _buttonStyle(
    Color backgroundColor, Color splashColor, BorderSide? border, horizontalPadding, verticalPadding) {
  return ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(backgroundColor),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: border ?? BorderSide.none,
      ),
    ),
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) =>
          states.contains(WidgetState.pressed) ? splashColor : null,
    ),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
    ),
    minimumSize: WidgetStatePropertyAll(Size(0, 30)),
  );
}
