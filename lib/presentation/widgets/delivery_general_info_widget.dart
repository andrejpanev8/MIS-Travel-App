import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/presentation/widgets/map_static.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/enums/user_role.dart';
import '../../data/models/trip.dart';
import '../../utils/color_constants.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';

Widget deliveryGeneralInfo(
    BuildContext context, Trip? trip, TaskTrip? taskTrip, UserRole? userRole) {
  return (trip != null && taskTrip != null)
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 22),
                SizedBox(width: 10),
                Text("${trip.startCity} - ${trip.endCity}",
                    style: StyledText().appBarText().copyWith(fontSize: 20)),
                userRole == UserRole.ADMIN
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Functions.emitUserEvent(
                              context: context,
                              event: EditDeliveryEvent(taskTrip, trip));
                          Navigator.of(context).pushNamed("/addDelivery");
                        },
                      )
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
            _text(AppStrings.pickUpLocation),
            SizedBox(height: 6),
            _buildRow(
                text: "${taskTrip.startLocation}", icon: Icons.location_on),
            SizedBox(height: 10),
            _text(AppStrings.pickUpPhoneNumber),
            SizedBox(height: 6),
            _buildRow(
                text: taskTrip.pickUpPhoneNumber, icon: Icons.phone_callback),
            SizedBox(height: 6),
            MapStatic(
              uniqueKey: START_LOCATION_DELIVERY_DETAILS_SCREEN,
            ),
            SizedBox(height: 15),
            _text(AppStrings.dropOffLocation),
            SizedBox(height: 6),
            _buildRow(text: "${taskTrip.endLocation}", icon: Icons.location_on),
            SizedBox(height: 10),
            _text(AppStrings.dropOffPhoneNumber),
            SizedBox(height: 6),
            _buildRow(
                text: taskTrip.dropOffPhoneNumber, icon: Icons.phone_forwarded),
            SizedBox(height: 6),
            MapStatic(uniqueKey: END_LOCATION_DELIVERY_DETAILS_SCREEN),
          ],
        )
      : SizedBox.shrink();
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
      Text(text, style: StyledText().descriptionText())
    ],
  );
}
