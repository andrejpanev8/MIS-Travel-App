import 'package:flutter/material.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';

import '../../utils/text_styles.dart';

PreferredSizeWidget customAppBar({
  required BuildContext context,
  final String? appBarText,
}) {
  return AppBar(
    title: Text(
      appBarText ?? AppStrings.appName,
      style: StyledText().appBarText(),
    ),
    backgroundColor: blueDeepColor,
  );
}
