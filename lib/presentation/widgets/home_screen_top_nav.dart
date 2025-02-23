import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/presentation/widgets/expanded_wrapper_widget.dart';
import 'package:travel_app/utils/image_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../utils/functions.dart';
import 'input_field.dart';

class RidesDeliveriesToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        bool isRidesActive = state is RidesActive;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton(
                    context, AppStrings.rides, isRidesActive, true, carIcon),
                _buildToggleButton(context, AppStrings.deliveries,
                    !isRidesActive, false, boxIcon),
              ],
            ),
            Row(children: [_buildSearchSection(context, isRidesActive)])
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
                  .appBarText(color: isActive ? blueDeepColor : silverColor)
                  .copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSearchSection(BuildContext context, bool showRides) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                expandedWidget(inputTextFieldCustom(
                  context: context,
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: AppStrings.fromWhere,
                )),
                SizedBox(width: 10),
                expandedWidget(inputTextFieldCustom(
                  context: context,
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: AppStrings.toWhere,
                )),
                SizedBox(width: 10),
                expandedWidget(inputTextFieldCustom(
                  context: context,
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  hintText: AppStrings.when,
                )),
              ],
            )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              showRides
                  ? AppStrings.upcomingRides
                  : AppStrings.upcomingDeliveries,
              style: StyledText().appBarText(fontSize: 18),
            )),
      ],
    ),
  );
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
            ? Functions.emitUserEvent(
                context: context, event: GetDriverUpcomingRides())
            : Functions.emitUserEvent(
                context: context, event: GetDriverUpcomingDeliveries()));
  }
}
