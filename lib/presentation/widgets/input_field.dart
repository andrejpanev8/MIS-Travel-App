import 'package:flutter/material.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

Widget inputTextFieldCustom({
  required BuildContext context,
  TextEditingController? controller,
  String hintText = "",
  bool obscureText = false,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return Expanded(
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: StyledText().descriptionText(fontSize: 12, color: greyColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: silverColorLight,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: silverColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: silverColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: blueDeepColor),
        ),
      ),
    ),
  );
}
