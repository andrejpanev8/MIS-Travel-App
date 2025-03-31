import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class DropdownCustomButton<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final Function(T?) onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const DropdownCustomButton({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.hintText = "Select an option",
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: silverColorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: silverColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(
            hintText,
            style: TextStyle(fontSize: 12, color: greyColor),
          ),
          value: items.contains(selectedValue) ? selectedValue : null,
          isExpanded: true,
          icon: suffixIcon ?? Icon(Icons.arrow_drop_down, color: greyColor),
          items: items.isNotEmpty
              ? items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: TextStyle(color: blackColor),
                    ),
                  );
                }).toList()
              : null,
          onChanged: items.isNotEmpty ? onChanged : null,
        ),
      ),
    );
  }
}
