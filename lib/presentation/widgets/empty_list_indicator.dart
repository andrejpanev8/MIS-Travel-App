import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

Widget emptyListIndicator(String text) {
  return SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: SizedBox(
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: greyColor),
        ),
      ),
    ),
  );
}
