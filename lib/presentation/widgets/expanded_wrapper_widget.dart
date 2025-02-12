import 'package:flutter/material.dart';

Widget expandedWidget(Widget child, {int flex = 1}) {
  return Expanded(flex: flex, child: child);
}