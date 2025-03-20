import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
// import 'package:travel_app/data/DTO/PassengerTripDTO.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/presentation/widgets/map_static.dart';
import 'package:travel_app/presentation/widgets/ride_general_info_widget.dart';
import 'package:travel_app/utils/error_handler.dart';
import 'package:travel_app/utils/map_unique_keys.dart';
import 'package:travel_app/utils/success_handler.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';

class ReserveRideScreen extends StatefulWidget {
  const ReserveRideScreen({super.key});

  @override
  State<ReserveRideScreen> createState() => _ReserveRideScreenState();
}

class _ReserveRideScreenState extends State<ReserveRideScreen> {
  Trip? trip;
  UserModel? driver;

  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();

  final FocusNode fromAddressFocusNode = FocusNode();
  final FocusNode toAddressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    fromAddressFocusNode.addListener(_handleFocusChange);
    toAddressFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!fromAddressFocusNode.hasFocus) {
      if (fromAddressController.text.isNotEmpty) {
        Functions.emitMapEvent(
          context: context,
          event: AddressEntryEvent(fromAddressController.text,
              uniqueKey: START_LOCATION_RESERVE_RIDE_SCREEN),
        );
      }
    }

    if (!toAddressFocusNode.hasFocus) {
      if (toAddressController.text.isNotEmpty) {
        Functions.emitMapEvent(
          context: context,
          event: AddressEntryEvent(toAddressController.text,
              uniqueKey: END_LOCATION_RESERVE_RIDE_SCREEN),
        );
      }
    }

    if (!fromAddressFocusNode.hasFocus &&
        !toAddressFocusNode.hasFocus &&
        fromAddressController.text.isNotEmpty &&
        toAddressController.text.isNotEmpty) {
      Functions.emitMapEvent(
        context: context,
        event: AddressDoubleEntryEvent(
          fromAddressController.text,
          toAddressController.text,
          uniqueKey: RESERVE_RIDE_SCREEN,
        ),
      );
    }
  }

  @override
  void dispose() {
    fromAddressController.dispose();
    toAddressController.dispose();
    fromAddressFocusNode.dispose();
    toAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trip = ModalRoute.of(context)!.settings.arguments as Trip;
    return SafeArea(
        child: Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BlocListener<MapBloc, MapState>(
          listener: (context, state) => {
            if (state is MapSingleSelectionLoaded)
              {
                setState(() {
                  state.uniqueKey == START_LOCATION_RESERVE_RIDE_SCREEN
                      ? fromAddressController.text = state.address
                      : toAddressController.text = state.address;
                })
              },
            if (state is MapDoubleSelectionLoaded)
              {
                fromAddressController.text = state.fromAddress,
                toAddressController.text = state.toAddress
              }
          },
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is TripInfoLoaded) {
              trip = state.trip;
              driver = state.driver;
            }
            if (state is RideReserveSuccess) {
              Functions.emitUserEvent(
                  context: context,
                  event: GetClientUpcomingRides(forceRefresh: true));
              showSuccessDialog(
                  context,
                  AppStrings.rideReservedSuccessfullyTitle,
                  AppStrings.rideReservedSuccessfullyMessage,
                  () => Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (route) => false));
            }
            if (state is RideReserveError) {
              showErrorDialog(context, AppStrings.rideReservedFailedTitle,
                  AppStrings.rideReservedFailedMessage);
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _generalInfo(),
                  _buildForm(),
                  SizedBox(height: 32.0),
                  Text(AppStrings.selectALocation,
                      style: StyledText().descriptionText()),
                  MapStatic(
                      multipleSelection: true, uniqueKey: RESERVE_RIDE_SCREEN),
                  SizedBox(height: 32.0),
                  Row(
                    children: [
                      Expanded(
                          child: customArrowButton(
                              text: AppStrings.confirmReservation,
                              fontSize: 16,
                              iconSize: 16,
                              verticalPadding: 10,
                              onPressed: () {
                                Functions.emitUserEvent(
                                    context: context,
                                    event: ReserveRide(
                                        fromAddressController.text,
                                        toAddressController.text,
                                        trip!.id));
                              })),
                    ],
                  )
                ]);
          }),
        ),
      ),
    ));
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.fromWhere, style: StyledText().descriptionText()),
          inputTextFieldCustom(
              context: context,
              controller: fromAddressController,
              focusNode: fromAddressFocusNode,
              suffixIcon: Icon(Icons.map_outlined)),
          SizedBox(height: 16.0),
          Text(AppStrings.toWhere, style: StyledText().descriptionText()),
          inputTextFieldCustom(
              context: context,
              controller: toAddressController,
              focusNode: toAddressFocusNode,
              suffixIcon: Icon(Icons.map_outlined)),
        ],
      ),
    );
  }

  Widget _generalInfo() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: rideGeneralInfo(trip, driver));
  }
}
