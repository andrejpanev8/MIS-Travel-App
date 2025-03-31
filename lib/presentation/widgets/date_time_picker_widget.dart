// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';

Widget dateTimePicker({
  required BuildContext context,
  required TextEditingController controller,
  FocusNode? focusNode,
  String? hintText,
  Widget? icon,
  required Function(DateTime) onDateTimeSelected,
}) {
  return GestureDetector(
    onTap: () async {
      FocusScope.of(context).unfocus();

      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          onDateTimeSelected(newDateTime);
          controller.text =
              "${"${pickedDate.toLocal()}".split(' ')[0]} ${pickedTime.format(context)}";
        }
      }
    },
    child: AbsorbPointer(
      child: inputTextFieldCustom(
        context: context,
        focusNode: focusNode,
        controller: controller,
        hintText: hintText ?? "",
        suffixIcon: icon ?? Icon(Icons.calendar_today),
      ),
    ),
  );
}
