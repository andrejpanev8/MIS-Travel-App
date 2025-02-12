import 'package:flutter/material.dart';
import 'package:travel_app/utils/color_constants.dart';

class DecorationsCustom {
  BoxDecoration silverBoxRoundedCorners({double borderRadius = 12}) =>
      BoxDecoration(
        color: silverColorLight,
        borderRadius: BorderRadius.circular(borderRadius),
      );
}
