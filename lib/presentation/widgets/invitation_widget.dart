import 'package:flutter/material.dart';
import 'package:travel_app/data/models/invitation.dart';

import '../../utils/color_constants.dart';
import '../../utils/decorations.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

class InvitationWidget extends StatelessWidget {
  final BuildContext context;
  final Invitation invitation;

  const InvitationWidget({
    super.key,
    required this.context,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: DecorationsCustom().silverBoxRoundedCorners(),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            _leftInfo(),
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
              const SizedBox(width: 5),
              const Icon(Icons.email_outlined,
                  size: 14, semanticLabel: AppStrings.emailIconTooltip),
              const SizedBox(width: 4),
              Text(
                invitation.email,
                style: StyledText()
                    .descriptionText(color: blackColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.access_time_outlined,
                  size: 14, semanticLabel: AppStrings.timeIconTooltip),
              const SizedBox(width: 4),
              Text(
                "Expires on: ${invitation.getFormattedExpirationDate()}",
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
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(Icons.info_outline,
                  size: 14, semanticLabel: AppStrings.infoTooltip),
              const SizedBox(width: 4),
              Text(
                invitation.getStatus(),
                style: StyledText().descriptionText(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: StyledText().regular),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
