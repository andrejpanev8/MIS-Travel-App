import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';

import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_constants.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget rideGeneralInfo(Trip? trip, UserModel? driver) {
  return (trip != null && driver != null)
      ? Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.location_on_outlined, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: marqueeCustom(
                      text: "${trip.startCity} - ${trip.endCity}",
                      textStyle:
                          StyledText().appBarText().copyWith(fontSize: 20),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              _buildRow(
                  icon: Icons.access_time, text: trip.formattedStartDateTime),
              SizedBox(height: 6),
              _buildRow(
                  icon: Icons.badge_outlined,
                  text: "${driver.firstName} ${driver.lastName}"),
              SizedBox(height: 6),
              _buildRow(
                  icon: Icons.people_alt_outlined,
                  text:
                      "${AppStrings.numberOfPassengers}: ${trip.passengerTrips.length}"),
              SizedBox(height: 6),
              _buildRow(
                  text:
                      "${AppStrings.numberOfPackages}: ${trip.taskTrips.length}",
                  assetIcon: boxIcon),
            ],
          ),
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
      Text(text, style: TextStyle(fontSize: 15))
    ],
  );
}
