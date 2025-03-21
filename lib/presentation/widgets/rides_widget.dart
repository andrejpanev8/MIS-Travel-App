import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/marquee_widget.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';
import 'package:travel_app/data/enums/screen_type.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/passenger_trip.dart';
import '../../data/models/trip.dart';
import '../../utils/decorations.dart';
import '../../utils/functions.dart';

class RidesWidget extends StatelessWidget {
  final BuildContext context;
  final Trip ride;
  final ScreenType screenType;
  final PassengerTrip? passengerTrip;

  const RidesWidget(
      {super.key,
      required this.context,
      required this.ride,
      required this.screenType,
      this.passengerTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: DecorationsCustom().silverBoxRoundedCorners(),
      child: Row(
        children: [_leftInfo(), SizedBox(width: 20), _rightInfo(ride)],
      ),
    );
  }

  Widget _leftInfo() {
    String formattedDate =
        DateFormat('dd.MM.yyyy - HH.mm').format(ride.startTime);
    final text = "${ride.startCity} - ${ride.endCity}";
    final textStyle = StyledText().descriptionText(fontSize: 16);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  semanticLabel: AppStrings.locationIconTooltip, size: 22),
              const SizedBox(width: 4),
              Expanded(
                child: marqueeCustom(text: text, textStyle: textStyle),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 5),
              const Icon(
                Icons.access_time,
                size: 14,
                semanticLabel: AppStrings.timeIconTooltip,
              ),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: StyledText().descriptionText(
                  fontSize: 12,
                  fontWeight: StyledText().regular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightInfo(Trip trip) {
    UserRole? userRole;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        screenType == ScreenType.HOME_RIDES_SCREEN
            ? Row(
                children: [
                  const Icon(
                    Icons.people_alt_outlined,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${ride.maxCapacity - ride.passengerTrips.length} Places left",
                    style: StyledText().descriptionText(fontSize: 12),
                  )
                ],
              )
            : Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: greenColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${ride.deliveryPrice} ${AppStrings.denars}",
                    style: StyledText().descriptionText(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
        const SizedBox(height: 8),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is UserIsLoggedIn) {
              userRole = state.user.role;
            }
            return customArrowButton(
              text: _getButtonText(userRole),
              fontSize: 12,
              horizontalPadding: 20,
              onPressed: () {
                if (userRole == UserRole.CLIENT) {
                  if (screenType == ScreenType.MY_RIDES_SCREEN) {
                    Functions.emitUserEvent(
                        context: context,
                        event: GetClientRideDetails(tripId: trip.id));
                    Navigator.pushNamed(context, '/clientRideDetails',
                        arguments: passengerTrip);
                  } else {
                    Functions.emitUserEvent(
                        context: context, event: GetTripInfo(trip.id));
                    Navigator.pushNamed(
                        context,
                        screenType == ScreenType.HOME_RIDES_SCREEN
                            ? '/reserveRide'
                            : '/reserveDelivery',
                        arguments: trip);
                  }
                } else if (userRole == UserRole.DRIVER ||
                    userRole == UserRole.ADMIN) {
                  Functions.emitUserEvent(
                      context: context,
                      event: GetTripDetails(
                          driverId: trip.driverId, tripId: trip.id));
                  Functions.emitMapEvent(
                      context: context, event: LoadWaypointsEvent(trip));
                  Navigator.pushNamed(context, '/rideDetails', arguments: trip);
                }
              },
            );
          },
        ),
      ],
    );
  }

  String _getButtonText(UserRole? userRole) {
    if (screenType == ScreenType.HOME_RIDES_SCREEN &&
        userRole == UserRole.CLIENT) {
      return AppStrings.reserve;
    } else if (screenType == ScreenType.HOME_DELIVERIES_SCREEN &&
        userRole == UserRole.CLIENT) {
      return AppStrings.sendPackage;
    }
    return AppStrings.viewDetails;
  }
}
