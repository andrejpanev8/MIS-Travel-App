import 'package:flutter/material.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';
import '../../data/models/user.dart';
import '../../utils/decorations.dart';

class DriversWidget extends StatelessWidget {
  final BuildContext context;
  final UserModel driver;

  const DriversWidget({
    super.key,
    required this.context,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: DecorationsCustom().silverBoxRoundedCorners(),
        child: Row(
          children: [
            _leftInfo(),
            const SizedBox(width: 20),
            _rightInfo(),
          ],
        ),
      ),
    );
  }

  Widget _leftInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                driver.fullName,
                style: StyledText()
                    .descriptionText(color: blackColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.phone_outlined,
                  size: 14, semanticLabel: AppStrings.timeIconTooltip),
              const SizedBox(width: 4),
              Text(
                driver.phoneNumber,
                style: StyledText().descriptionText(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: StyledText().regular),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.email_outlined,
                  size: 14, semanticLabel: AppStrings.emailIconTooltip),
              const SizedBox(width: 4),
              Text(
                driver.email,
                style: StyledText().descriptionText(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: StyledText().regular),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
