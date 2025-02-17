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
    Color? textColor,
    BorderSide? border,
    double? fontSize}) {
  return noIcon
      ? TextButton(
          onPressed: onPressed,
          style: _buttonStyle(backgroundColor, splashColor, border),
          child: Text(
            text,
            style: StyledText().descriptionText(),
          ),
        )
      : TextButton.icon(
          onPressed: onPressed,
          label: Text(text,
              style: StyledText()
                  .descriptionText(fontSize: fontSize, color: textColor)),
          style: _buttonStyle(backgroundColor, splashColor, border),
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
    Color backgroundColor, Color splashColor, BorderSide? border) {
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
      EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    minimumSize: WidgetStatePropertyAll(Size(0, 30)),
  );
}
