import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_constants.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget rideGeneralShortInfo(Trip? trip, UserModel? driver) {
  return (trip != null && driver != null)
      ? Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.location_on_outlined, size: 22),
          SizedBox(width: 4),
          Text("${trip.startCity} - ${trip.endCity}",
              style: StyledText().appBarText().copyWith(fontSize: 20))
        ],
      ),
      SizedBox(height: 10),
      _buildRow(icon: Icons.access_time, text: trip.formattedStartDateTime),
      SizedBox(height: 6),
      _buildRow(
          icon: Icons.badge_outlined,
          text: driver != null
              ? "${driver.firstName} ${driver.lastName}"
              : ""),
    ],
  )
      : SizedBox.shrink();
}


Widget _buildRow({IconData? icon, String text = "", String? assetIcon}) {
  return Row(
    children: [
      icon != null
          ? Icon(icon, size: 16)
          : assetIcon != null
          ? SvgPicture.asset(
        assetIcon,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
      )
          : SizedBox(width: 25),
      SizedBox(width: 10),
      Text(text, style: const TextStyle(fontSize: 15))
    ],
  );
}
