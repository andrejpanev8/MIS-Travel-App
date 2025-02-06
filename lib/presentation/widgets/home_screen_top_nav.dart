import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../utils/functions.dart';

class RidesDeliveriesToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        bool isRidesActive = state is RidesActive;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToggleButton(context, "Rides", isRidesActive, true),
            _buildToggleButton(context, "Deliveries", !isRidesActive, false),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(
      BuildContext context, String text, bool isActive, bool showRides) {
    return GestureDetector(
      onTap: () => Functions.emitScreenEvent(
              context: context,
              event: ToggleActiveScreen(ridesActive: showRides))
          .whenComplete(() => showRides
              ? Functions.emitEvent(
                  context: context, event: GetDriverUpcomingRides())
              : Functions.emitEvent(
                  context: context, event: GetDriverUpcomingDeliveries())),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
