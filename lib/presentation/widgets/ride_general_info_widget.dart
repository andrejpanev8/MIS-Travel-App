import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_constants.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget rideGeneralInfo(Trip? trip, UserModel? driver) {
  return (trip != null && driver != null)
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                Text("${trip.startCity} - ${trip.endCity}",
                    style: StyledText().appBarText())
              ],
            ),
            _buildRow(icon: Icons.access_time, text: "${trip.startTime}"),
            _buildRow(
                icon: Icons.badge_outlined,
                text: driver != null
                    ? "${driver.firstName} ${driver.lastName}"
                    : ""),
            _buildRow(
                text: "${AppStrings.startingLocation}: ${trip.startLocation}"),
            _buildRow(
                icon: Icons.people_alt_outlined,
                text:
                    "${AppStrings.numberOfPassengers}: ${trip.passengerTrips.length}"),
            _buildRow(
                text:
                    "${AppStrings.numberOfPackages}: ${trip.taskTrips.length}",
                assetIcon: boxIcon),
          ],
        )
      : SizedBox.shrink();
}

Widget _buildRow({IconData? icon, String text = "", String? assetIcon}) {
  return Row(
    children: [
      icon != null
          ? Icon(icon)
          : assetIcon != null
              ? SvgPicture.asset(
                  assetIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                )
              : SizedBox(width: 25),
      SizedBox(width: 10),
      Text(text)
    ],
  );
}
