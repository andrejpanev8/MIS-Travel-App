import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/presentation/widgets/map_static.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/color_constants.dart';
import '../../utils/image_constants.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget deliveryGeneralInfo(Trip? trip, TaskTrip? taskTrip) {
  return (trip != null && taskTrip != null)
      ? SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 22),
                SizedBox(width: 10),
                Text("${trip.startCity} - ${trip.endCity}",
                    style: StyledText().appBarText().copyWith(fontSize: 20))
              ],
            ),
            SizedBox(height: 20),
            _buildRow(
                icon: Icons.access_time, text: trip.formattedStartDateTime),
            SizedBox(height: 6),
            _buildRow(
                text: "${AppStrings.price}: ${trip.deliveryPrice}",
                icon: Icons.monetization_on),
            SizedBox(height: 6),
            _buildRow(
                text: "${AppStrings.pickUpLocation}: ${taskTrip.startLocation}",
                icon: Icons.location_on),
            SizedBox(height: 6),
            _buildRow(
                text:
                    "${AppStrings.pickUpPhoneNumber}: ${taskTrip.pickUpPhoneNumber}",
                icon: Icons.phone_callback),
            MapStatic(uniqueKey: START_LOCATION_DELIVERY_DETAILS_SCREEN,),
            SizedBox(height: 6),
            _buildRow(
                text: "${AppStrings.dropOffLocation}: ${taskTrip.endLocation}",
                icon: Icons.location_on),
            SizedBox(height: 6),
            _buildRow(
                text:
                    "${AppStrings.dropOffPhoneNumber}: ${taskTrip.dropOffPhoneNumber}",
                icon: Icons.phone_forwarded),
            MapStatic(uniqueKey: END_LOCATION_DELIVERY_DETAILS_SCREEN),
          ],
        ))
      : SizedBox.shrink();
}

Widget _buildRow({IconData? icon, String text = "", String? assetIcon}) {
  return Row(
    children: [
      SizedBox(width: 4),
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
      Text(text, style: StyledText().descriptionText())
    ],
  );
}
