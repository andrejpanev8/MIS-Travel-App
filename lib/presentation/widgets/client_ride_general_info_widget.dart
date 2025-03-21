import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/presentation/widgets/map_static.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/enums/user_role.dart';
import '../../data/models/trip.dart';
import '../../utils/color_constants.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget clientRideGeneralInfo(BuildContext context, Trip? trip,
    PassengerTrip? passengerTrip, UserRole userRole) {
  return (trip != null && passengerTrip != null)
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 22),
                    SizedBox(width: 10),
                    Text("${trip.startCity} - ${trip.endCity}",
                        style:
                            StyledText().appBarText().copyWith(fontSize: 20)),
                  ],
                ),
                userRole == UserRole.ADMIN
                    ? _getButtons(context, passengerTrip)
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 20),
            _buildRow(
                icon: Icons.access_time, text: trip.formattedStartDateTime),
            SizedBox(height: 10),
            _buildRow(
                text: "${trip.deliveryPrice} ${AppStrings.denars}",
                icon: Icons.monetization_on),
            SizedBox(height: 10),
            _buildRow(
                text: passengerTrip.user.fullName, icon: Icons.person_outline),
            SizedBox(height: 6),
            _buildRow(
                text: passengerTrip.user.phoneNumber,
                icon: Icons.phone_outlined),
            SizedBox(height: 20),
            _text(AppStrings.startLocation),
            SizedBox(height: 10),
            _buildRow(
                text: passengerTrip.startLocation.address ??
                    "No Location Provided",
                icon: Icons.location_on),
            SizedBox(height: 12),
            MapStatic(
              uniqueKey: START_LOCATION_CLIENT_RIDE_DETAILS_SCREEN,
            ),
            SizedBox(height: 20),
            _text(AppStrings.endLocation),
            SizedBox(height: 10),
            _buildRow(
                text:
                    passengerTrip.endLocation.address ?? "No Location provided",
                icon: Icons.location_on),
            SizedBox(height: 12),
            MapStatic(uniqueKey: END_LOCATION_CLIENT_RIDE_DETAILS_SCREEN),
            SizedBox(height: 10),
          ],
        )
      : SizedBox.shrink();
}

Widget _getButtons(BuildContext context, PassengerTrip passengerTrip) {
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.delete, color: redColor),
        onPressed: () {
          Functions.emitUserEvent(
              context: context, event: DeletePassengerTripEvent(passengerTrip));
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home", (route) => false);
        },
      ),
    ],
  );
}

Widget _text(String text) {
  return Text(text, style: StyledText().descriptionText());
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
      Expanded(
        child: Text(
          text,
          style: StyledText().descriptionText(),
          softWrap: true, // Allow wrapping
        ),
      ),
    ],
  );
}
