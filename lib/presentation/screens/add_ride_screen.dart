import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/custom_drop_down_button.dart';
import 'package:travel_app/utils/success_handler.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/models/location.dart';
import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/functions.dart';
import '../../utils/map_unique_keys.dart';
import '../../utils/string_constants.dart';
import '../widgets/date_time_picker_widget.dart';
import '../widgets/input_field.dart';
import '../widgets/map_static.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({super.key});

  @override
  State<AddRideScreen> createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  final TextEditingController departureCityController = TextEditingController();
  final TextEditingController arrivalCityController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController driverController = TextEditingController();

  final FocusNode startLocationFocusNode = FocusNode();
  Location? startLocation;
  DateTime? selectedStartDateTime;
  UserModel? selectedDriver;
  List<UserModel> allDrivers = [];
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    startLocationFocusNode.addListener(() {
      if (!startLocationFocusNode.hasFocus) {
        if (startLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: AddressEntryEvent(startLocationController.text,
                uniqueKey: START_LOCATION_ADD_RIDE_SCREEN),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    departureCityController.dispose();
    arrivalCityController.dispose();
    startTimeController.dispose();
    startLocationController.dispose();
    maxCapacityController.dispose();
    priceController.dispose();
    driverController.dispose();
    startLocationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) => {
        if (state is MapSingleSelectionLoaded &&
            state.uniqueKey == START_LOCATION_ADD_RIDE_SCREEN)
          {
            setState(() {
              startLocationController.text = state.address;
              startLocation = Location(
                  latitude: state.location.latitude,
                  longitude: state.location.longitude);
            })
          }
      },
      child: Scaffold(
        appBar: customAppBar(context: context, arrowBack: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is EditTripInfoLoaded) {
                  departureCityController.text = state.trip.startCity;
                  arrivalCityController.text = state.trip.endCity;
                  startTimeController.text = state.trip.startTime.toString();
                  startLocationController.text = state.startLocationAddress;
                  maxCapacityController.text =
                      state.trip.maxCapacity.toString();
                  priceController.text = state.trip.deliveryPrice.toString();
                  selectedDriver = state.driver;
                  Functions.emitMapEvent(
                    context: context,
                    event: AddressEntryEvent(state.startLocationAddress,
                        uniqueKey: START_LOCATION_ADD_RIDE_SCREEN),
                  );
                  isEdit = true;
                }
                if (state is AllDriversLoaded) {
                  allDrivers = state.drivers;
                }
                if (state is TripSaveSuccess) {
                  showSuccessDialog(
                      context,
                      AppStrings.rideSavedSuccessfullyTitle,
                      AppStrings.rideSavedSuccessfullyMessage,
                      () => Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (route) => false));
                }
                if (state is TripSaveError) {}
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(),
                    SizedBox(height: 24.0),
                    Text(AppStrings.selectALocation,
                        style: StyledText().descriptionText(
                            fontSize: 18, fontWeight: StyledText().regular)),
                    MapStatic(uniqueKey: START_LOCATION_ADD_RIDE_SCREEN),
                    Row(
                      children: [
                        Expanded(
                            child: customArrowButton(
                                text: "Save",
                                verticalPadding: 10,
                                onPressed: () {
                                  Functions.emitUserEvent(
                                      context: context,
                                      event: SaveTripEvent(createTrip()));
                                })),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Trip createTrip() {
    Trip newTrip = Trip(
      startCity: departureCityController.text,
      endCity: arrivalCityController.text,
      startTime: selectedStartDateTime!,
      startLocation: startLocation!,
      ridePrice: int.parse(priceController.text),
      deliveryPrice: int.parse(priceController.text),
      maxCapacity: int.parse(maxCapacityController.text),
      driverId: selectedDriver!.id,
    );

    return newTrip;
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.rideDetails, style: StyledText().appBarText()),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Departure City"),
          inputTextFieldCustom(
              context: context, controller: departureCityController),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Arrival City"),
          inputTextFieldCustom(
              context: context, controller: arrivalCityController),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Start Time"),
          dateTimePicker(
            context: context,
            controller: startTimeController,
            onDateTimeSelected: (DateTime dateTime) {
              setState(() {
                selectedStartDateTime = dateTime;
              });
            },
          ),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Start Location"),
          inputTextFieldCustom(
              context: context,
              controller: startLocationController,
              focusNode: startLocationFocusNode,
              suffixIcon: Icon(Icons.map_outlined)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Max Capacity"),
          inputTextFieldCustom(
              context: context,
              keyboardType: TextInputType.numberWithOptions(),
              controller: maxCapacityController,
              suffixIcon: Icon(Icons.person_outline)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Price"),
          inputTextFieldCustom(
              context: context,
              keyboardType: TextInputType.numberWithOptions(),
              controller: priceController,
              suffixIcon: Icon(Icons.monetization_on_outlined)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Driver"),
          DropdownCustomButton(
            items: allDrivers,
            selectedValue: selectedDriver,
            hintText: "Select a driver",
            onChanged: (UserModel? newValue) {
              setState(() {
                selectedDriver = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget _text(String text) {
  return Text(text, style: StyledText().descriptionText());
}
