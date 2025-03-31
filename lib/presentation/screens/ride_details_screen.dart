// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/presentation/screens/qr_scanner_screen.dart';
import 'package:travel_app/service/passenger_trip_service.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/passenger_trip.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/color_constants.dart';
import '../../utils/error_handler.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/success_handler.dart';
import '../../utils/text_styles.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_arrow_button.dart';
import '../widgets/infoText_widget.dart';
import '../widgets/map_static.dart';
import '../widgets/passenger_widget.dart';
import '../widgets/ride_general_info_widget.dart';
import '../widgets/task_details_widget.dart';
import '../widgets/widget_builder.dart';

class RideDetailsScreen extends StatelessWidget {
  Trip? trip;
  UserModel? driver;
  List<PassengerTrip>? passengerTrips;
  List<TaskTrip>? taskTrips;

  RideDetailsScreen({super.key, this.trip});

  dynamic user;

  @override
  Widget build(BuildContext context) {
    trip = ModalRoute.of(context)?.settings.arguments as Trip?;

    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body:
                BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
              if (authState is UserIsLoggedIn) {
                user = authState.user;
              }
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (user == null) {
                    return Center(
                        child: infoText(AppStrings.loginRequiredMessage1));
                  }

                  if (state is TripDetailsLoaded) {
                    driver = state.driver!;
                    passengerTrips = state.passengerTrips;
                    taskTrips = state.taskTrips;
                  }
                  return driver != null &&
                          passengerTrips != null &&
                          taskTrips != null
                      ? _buildContent(context)
                      : Center(child: CircularProgressIndicator());
                },
              );
            })));
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rideGeneralInfo(trip!, driver),
              user.role == UserRole.ADMIN
                  ? _getButtons(context)
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(AppStrings.passengers),
          _buildPassengerList(context),
          const SizedBox(height: 20),
          user.role == UserRole.DRIVER && user.id == driver!.id && passengerTrips!.isNotEmpty
              ? _scanPassengerTripsButton(context)
              : SizedBox(),
          const SizedBox(height: 20),
          _sectionTitle(AppStrings.packages),
          _buildTaskList(context),
          const SizedBox(height: 20),
          _sectionTitle(AppStrings.yourRoute),
          const MapStatic(
            uniqueKey: "route",
          ),
        ],
      ),
    );
  }

  Widget _getButtons(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Functions.emitUserEvent(
                context: context, event: EditTripEvent(trip!, driver!));
            Navigator.of(context).pushNamed('/addRide');
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: redColor),
          onPressed: () {
            Functions.emitUserEvent(
                context: context, event: DeleteTripEvent(trip!));
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          },
        )
      ],
    );
  }

  Widget _scanPassengerTripsButton(BuildContext context) {
    void validateTicket(String code) async {
      bool isValid =
      await PassengerTripService().validateTicket(code, trip!.id);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isValid) {
          showSuccessDialog(
            context,
            "Success",
            "Ticket is valid!",
                () {
              Navigator.pop(context);
            },
          );
        } else {
          showErrorDialog(context, "Error", "Invalid Ticket!");
        }
      });
    }
    return Center(
      child: customArrowButton(
          customIcon: Icons.qr_code_scanner,
          iconColor: whiteColor,
          border: const BorderSide(color: blueDeepColor),
          text: "Scan Tickets",
          horizontalPadding: 20,
          verticalPadding: 10,
          onPressed: () async {
            var status = await Permission.camera.request();

            if (status.isGranted) {
              final scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScannerScreen()),
              );

              if (scannedCode != null) {
                validateTicket(scannedCode);
              }
            } else {
              showErrorDialog(
                context,
                "Permission Denied",
                "Camera permission is required to scan tickets",
              );
            }
          },
        )
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(
        title,
        style: StyledText().appBarText(),
      ),
    );
  }

  Widget _buildPassengerList(BuildContext context) {
    return widgetBuilder(
      context: context,
      items: passengerTrips!,
      itemBuilder: (context, passengerTrip) =>
          PassengerWidget(passengerTrip: passengerTrip),
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return widgetBuilder(
      context: context,
      items: taskTrips!,
      itemBuilder: (context, taskTrip) =>
          TaskTripDetailsWidget(taskTrip: taskTrip),
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }
}
