import 'package:flutter/material.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';

import '../../utils/text_styles.dart';

PreferredSizeWidget customAppBar({
  required BuildContext context,
  final String? appBarText,
  bool arrowBack = false,
}) {
  return AppBar(
    title: Text(
      appBarText ?? AppStrings.appName,
      style: StyledText().appBarText(),
    ),
    backgroundColor: blueDeepColor,
    leading: arrowBack == true
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            color: whiteColor,
            onPressed: () => Navigator.pop(context))
        : null,
    automaticallyImplyLeading: false,
  );
}
