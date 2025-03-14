import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/DTO/ReserveDeliveryDTO.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/presentation/widgets/ride_general_short_info_widget.dart';
import 'package:travel_app/utils/error_handler.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../bloc/map_bloc/map_bloc.dart' as map_bloc;
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/location.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/success_handler.dart';
import '../../utils/text_styles.dart';
import '../../utils/validation_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_arrow_button.dart';
import '../widgets/input_field.dart';
import '../widgets/map_static.dart';

class ReserveDeliveryScreen extends StatefulWidget {
  const ReserveDeliveryScreen({super.key});

  @override
  State<ReserveDeliveryScreen> createState() => _ReserveDeliveryScreenState();
}

class _ReserveDeliveryScreenState extends State<ReserveDeliveryScreen> {
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();
  final TextEditingController pickUpPhoneController = TextEditingController();
  final TextEditingController dropOffPhoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  Trip? trip;
  UserModel? driver;
  Location? startLocation;
  Location? endLocation;

  String? _pickUpPhoneError;
  String? _startLocationError;
  String? _endLocationError;
  String? _dropOffPhoneError;

  @override
  void initState() {
    super.initState();

    startLocationFocusNode.addListener(() {
      if (!startLocationFocusNode.hasFocus) {
        if (startLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: map_bloc.AddressEntryEvent(startLocationController.text,
                uniqueKey: START_LOCATION_RESERVE_DELIVERY_SCREEN),
          );
        }
      }
    });

    endLocationFocusNode.addListener(() {
      if (!endLocationFocusNode.hasFocus) {
        if (endLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: map_bloc.AddressEntryEvent(endLocationController.text,
                uniqueKey: END_LOCATION_RESERVE_DELIVERY_SCREEN),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    startLocationController.dispose();
    endLocationController.dispose();
    startLocationFocusNode.dispose();
    endLocationFocusNode.dispose();
    super.dispose();
  }

  Future<void> _reserveDelivery() async {
    _resetErrors();
    setState(() {
      _pickUpPhoneError =
          ValidationUtils.phoneValidator(pickUpPhoneController.text);
      _dropOffPhoneError =
          ValidationUtils.phoneValidator(dropOffPhoneController.text);
      if (startLocationController.text.isEmpty) {
        _startLocationError = "Please select a start location";
      }
      if (endLocationController.text.isEmpty) {
        _endLocationError = "Please select a end location";
      }
    });

    if (trip == null ||
        startLocation == null ||
        endLocation == null ||
        _pickUpPhoneError != null ||
        _dropOffPhoneError != null ||
        _startLocationError != null ||
        _endLocationError != null) {
      return;
    }

    Functions.emitUserEvent(
        context: context,
        event: CreateDelivery(ReserveDeliveryDTO(
            tripId: trip!.id,
            pickUpPhoneNumber: pickUpPhoneController.text,
            startLocation: startLocation!,
            dropOffPhoneNumber: dropOffPhoneController.text,
            endLocation: endLocation!,
            description: descriptionController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<map_bloc.MapBloc, map_bloc.MapState>(
        listener: (context, state) => {
              if (state is map_bloc.MapSingleSelectionLoaded)
                {
                  if (state.uniqueKey == START_LOCATION_RESERVE_DELIVERY_SCREEN)
                    {
                      setState(() {
                        startLocationController.text = state.address;
                        startLocation = Location(
                            latitude: state.location.latitude,
                            longitude: state.location.longitude,
                            address: state.address);
                      })
                    }
                  else if (state.uniqueKey ==
                      END_LOCATION_RESERVE_DELIVERY_SCREEN)
                    {
                      setState(() {
                        endLocationController.text = state.address;
                        endLocation = Location(
                            latitude: state.location.latitude,
                            longitude: state.location.longitude,
                            address: state.address);
                      })
                    }
                }
            },
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is DeliveryCreateSuccess) {
            Functions.emitUserEvent(
                context: context,
                event: GetClientUpcomingDeliveries(forceRefresh: true)
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSuccessDialog(
                  context, "Success", "Delivery successfully created!", () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (route) => false);
              });
            });
          } else if (state is DeliveryCreateError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(
                  context, "Error", "Error occurred while creating a delivery");
            });
          }
          return Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _generalInfo(),
                    SizedBox(height: 20.0),
                    _buildForm(),
                    SizedBox(height: 40.0),
                    if (state is ProcessStarted)
                      Center(child: CircularProgressIndicator())
                    else
                      Row(
                        children: [
                          Expanded(
                              child: customArrowButton(
                                  text: AppStrings.reserve,
                                  fontSize: 16,
                                  iconSize: 16,
                                  verticalPadding: 10,
                                  onPressed: _reserveDelivery)),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text("Pick up phone number"),
          inputTextFieldCustom(
              context: context,
              controller: pickUpPhoneController,
              suffixIcon: Icon(Icons.phone_callback_outlined)),
          _buildErrorText(_pickUpPhoneError),
          SizedBox(height: 16.0),
          _text("Start location, choose on map"),
          inputTextFieldCustom(
              context: context,
              controller: startLocationController,
              focusNode: startLocationFocusNode,
              suffixIcon: Icon(Icons.location_on_outlined)),
          _buildErrorText(_startLocationError),
          SizedBox(height: 8),
          MapStatic(uniqueKey: START_LOCATION_RESERVE_DELIVERY_SCREEN),
          SizedBox(height: 16.0),
          _text("Drop off phone number"),
          inputTextFieldCustom(
              context: context,
              controller: dropOffPhoneController,
              suffixIcon: Icon(Icons.phone_forwarded_outlined)),
          _buildErrorText(_dropOffPhoneError),
          SizedBox(height: 16.0),
          _text("End location, choose on map"),
          inputTextFieldCustom(
              context: context,
              controller: endLocationController,
              focusNode: endLocationFocusNode,
              suffixIcon: Icon(Icons.location_on_outlined)),
          _buildErrorText(_endLocationError),
          SizedBox(height: 8),
          MapStatic(uniqueKey: END_LOCATION_RESERVE_DELIVERY_SCREEN),
          SizedBox(height: 16.0),
          _text("Description"),
          inputTextFieldCustom(
              context: context,
              controller: descriptionController,
              maxLines: 4,
              hintText: "Enter description..."),
        ],
      ),
    );
  }

  Widget _generalInfo() {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is TripInfoLoaded) {
        trip = state.trip;
        driver = state.driver;
      }
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: rideGeneralShortInfo(trip, driver));
    });
  }

  void _resetErrors() {
    setState(() {
      _startLocationError = null;
      _endLocationError = null;
    });
  }
}

Widget _text(String text) {
  return Text(text, style: StyledText().descriptionText());
}

Widget _buildErrorText(String? error) {
  return error != null
      ? Padding(
          padding: const EdgeInsets.only(top: 4, left: 8),
          child: Text(
            error,
            style:
                StyledText().descriptionText(fontSize: 12, color: Colors.red),
          ),
        )
      : const SizedBox.shrink();
}
