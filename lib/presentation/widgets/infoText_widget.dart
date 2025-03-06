// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../utils/text_styles.dart';

Widget infoText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      text,
      style: StyledText().appBarText(),
      textAlign: TextAlign.center,
    ),
  );
}
