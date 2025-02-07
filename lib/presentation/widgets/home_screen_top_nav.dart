import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/image_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../utils/functions.dart';

class RidesDeliveriesToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        bool isRidesActive = state is RidesActive;
        isRidesActive
            ? Functions.emitEvent(
                context: context, event: GetDriverUpcomingRides())
            : Functions.emitEvent(
                context: context, event: GetDriverUpcomingDeliveries());
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildToggleButton(context, "Rides", isRidesActive, true, carIcon),
            _buildToggleButton(
                context, "Deliveries", !isRidesActive, false, boxIcon),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(BuildContext context, String text, bool isActive,
      bool showRides, String iconPath) {
    return GestureDetector(
      onTap: () => _onNavButtonTap(context, showRides),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? blueDeepColor : transparentColor,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _icon(showRides, isActive, iconPath),
            SizedBox(width: 8),
            Text(
              text,
              style: StyledText()
                  .appBarText(color: isActive ? blueDeepColor : silverColor),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _icon(bool showRides, bool isActive, String iconPath) {
  return SvgPicture.asset(
    iconPath,
    width: 20,
    height: 20,
    colorFilter: ColorFilter.mode(
        isActive ? blueDeepColor : silverColor, BlendMode.srcIn),
  );
}

Future<void> _onNavButtonTap(BuildContext context, bool showRides) async {
  if (context.mounted) {
    Functions.emitScreenEvent(
            context: context, event: ToggleActiveScreen(ridesActive: showRides))
        .whenComplete(() => showRides
            ? Functions.emitEvent(
                context: context, event: GetDriverUpcomingRides())
            : Functions.emitEvent(
                context: context, event: GetDriverUpcomingDeliveries()));
  }
}
