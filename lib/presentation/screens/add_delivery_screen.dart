import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/data/DTO/ReserveAdhocDeliveryDTO.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/service/user_service.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/custom_drop_down_button.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/error_handler.dart';
import 'package:travel_app/utils/success_handler.dart';
import 'package:travel_app/utils/text_styles.dart';
import 'package:travel_app/utils/validation_utils.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import '../../utils/functions.dart';
import '../../utils/map_unique_keys.dart';
import '../../utils/string_constants.dart';
import '../widgets/input_field.dart';
import '../widgets/map_static.dart';

class AddDeliveryScreen extends StatefulWidget {
  const AddDeliveryScreen({super.key});

  @override
  State<AddDeliveryScreen> createState() => _AddDeliveryScreenState();
}

class _AddDeliveryScreenState extends State<AddDeliveryScreen> {
  List<bool> isClientSelected = [true, false];

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController pickUpPhoneController = TextEditingController();
  final TextEditingController dropOffPhoneController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  List<UserModel> clients = [];
  UserModel? selectedClient;
  List<Trip> trips = [];
  Trip? selectedTrip;
  Location? startLocation;
  Location? endLocation;

  String? _pickUpPhoneError;
  String? _startLocationError;
  String? _endLocationError;
  String? _dropOffPhoneError;
  String? _tripError;
  String? _clientError;

  @override
  void initState() {
    super.initState();

    startLocationFocusNode.addListener(() {
      if (!startLocationFocusNode.hasFocus) {
        if (startLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: AddressEntryEvent(startLocationController.text,
                uniqueKey: START_LOCATION_ADD_DELIVERY_SCREEN),
          );
        }
      }
    });

    endLocationFocusNode.addListener(() {
      if (!endLocationFocusNode.hasFocus) {
        if (endLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: AddressEntryEvent(endLocationController.text,
                uniqueKey: END_LOCATION_ADD_DELIVERY_SCREEN),
          );
        }
      }
    });

    _loadTrips();
    _loadClients();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    pickUpPhoneController.dispose();
    dropOffPhoneController.dispose();
    startLocationController.dispose();
    endLocationController.dispose();
    startLocationFocusNode.dispose();
    endLocationFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    try {
      List<UserModel> fetchedClients =
          await UserService().getAllUsersByRole(userRole: UserRole.CLIENT);
      setState(() {
        clients = fetchedClients;
      });
    } catch (error) {
      print("Error fetching clients: $error");
    }
  }

  Future<void> _loadTrips() async {
    try {
      List<Trip> fetchedTrips = await TripService().getAllUpcomingTrips();
      setState(() {
        trips = fetchedTrips;
      });
    } catch (error) {
      print("Error fetching trips: $error");
    }
  }

  Future<void> _saveDelivery() async {
    _resetErrors();
    setState(() {
      if (selectedTrip == null) {
        _tripError = "Please select a trip";
      }
      if (isClientSelected[0]) {
        if (selectedClient == null) {
          _clientError = "Please select a client";
        }
      }
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

    if (_tripError != null ||
        _clientError != null ||
        _pickUpPhoneError != null ||
        _dropOffPhoneError != null ||
        _startLocationError != null ||
        _endLocationError != null) {
      return;
    }

    Functions.emitUserEvent(
        context: context,
        event: CreateAdhocUserDelivery(ReserveAdhocDeliveryDTO(
            pickUpPhoneNumber: pickUpPhoneController.text,
            startLocation: startLocation!,
            dropOffPhoneNumber: dropOffPhoneController.text,
            endLocation: endLocation!,
            tripId: selectedTrip!.id,
            clientId: selectedClient?.id,
            firstName: firstNameController.text.isNotEmpty
                ? firstNameController.text
                : "Unknown",
            lastName: lastNameController.text.isNotEmpty
                ? lastNameController.text
                : "Unknown",
            description: descriptionController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
        listener: (context, state) => {
              if (state is MapSingleSelectionLoaded)
                {
                  if (state.uniqueKey == START_LOCATION_ADD_DELIVERY_SCREEN)
                    {
                      setState(() {
                        startLocationController.text = state.address;
                        startLocation = Location(
                            latitude: state.location.latitude,
                            longitude: state.location.longitude,
                            address: state.address);
                      })
                    }
                  else if (state.uniqueKey == END_LOCATION_ADD_DELIVERY_SCREEN)
                    {
                      setState(() {
                        endLocationController.text = state.address;
                        endLocation = Location.fromLatLng(state.location);
                      })
                    }
                  else if (state is DeliveryCreateSuccess)
                    {
                      Functions.emitUserEvent(
                        context: context,
                        event: GetUpcomingDeliveries(forceRefresh: true),
                      ),
                      showSuccessDialog(
                          context, "Success", "Delivery successfully created!",
                          () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (route) => false);
                      })
                    }
                  else if (state is DeliveryCreateError)
                    {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showErrorDialog(context, "Error",
                            "Error occurred while creating a delivery");
                      })
                    }
                }
            },
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is DeliveryCreateSuccess) {
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
          if (state is DeliveryInfoLoaded) {
            selectedTrip = state.trip;
            selectedClient = state.taskTrip.user;
            pickUpPhoneController.text = state.taskTrip.pickUpPhoneNumber;
            startLocationController.text =
                state.taskTrip.startLocation.address ?? "";
            startLocation = state.taskTrip.startLocation;
            dropOffPhoneController.text = state.taskTrip.dropOffPhoneNumber;
            endLocationController.text =
                state.taskTrip.endLocation.address ?? "";
            endLocation = state.taskTrip.endLocation;
            descriptionController.text = state.taskTrip.description;
          }
          return Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(),
                    SizedBox(height: 40.0),
                    Row(
                      children: [
                        Expanded(
                            child: customArrowButton(
                                text: "Save",
                                fontSize: 16,
                                iconSize: 16,
                                verticalPadding: 10,
                                onPressed: _saveDelivery)),
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
          Text(AppStrings.deliveryDetails, style: StyledText().appBarText()),
          //////////////////////////
          SizedBox(height: 20),
          Text("Ride information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          //////////////////////////
          SizedBox(height: 25.0),

          _text("Select a Trip"),
          DropdownCustomButton(
            items: trips,
            selectedValue: selectedTrip,
            hintText: "Select a Trip",
            onChanged: (Trip? newValue) {
              setState(() {
                selectedTrip = newValue;
              });
            },
          ),
          _buildErrorText(_tripError),

          //////////////////////////
          SizedBox(height: 16.0),
          _buildTripDetails(),
          //////////////////////////
          SizedBox(height: 20.0),
          Divider(
            color: blackColor,
            thickness: 1,
          ),
          SizedBox(height: 10.0),

          Text("Client information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

          SizedBox(height: 25.0),
          Center(
            child: ToggleButtons(
              isSelected: isClientSelected,
              onPressed: (index) {
                setState(() {
                  isClientSelected = [index == 0, index == 1];
                  _resetFields();
                });
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Existing User"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Fill User Information"),
                ),
              ],
            ),
          ),
          //////////////////////////

          SizedBox(height: 20.0),
          isClientSelected[0]
              ? _buildExistingUserForm()
              : _buildFillUserInformationForm(),

          //////////////////////////

          SizedBox(height: 20.0),
          Divider(color: blackColor, thickness: 1),
          SizedBox(height: 10.0),

          Text("Delivery information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

          SizedBox(height: 25.0),
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
          MapStatic(uniqueKey: START_LOCATION_ADD_DELIVERY_SCREEN),

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
          MapStatic(uniqueKey: END_LOCATION_ADD_DELIVERY_SCREEN),
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

  Widget _buildExistingUserForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text("Select a Client"),
        DropdownCustomButton(
          items: clients,
          selectedValue: selectedClient,
          hintText: "",
          onChanged: (UserModel? newValue) {
            setState(() {
              selectedClient = newValue;
            });
          },
        ),
        _buildErrorText(_clientError)
      ],
    );
  }

  Widget _buildFillUserInformationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text("First Name"),
        inputTextFieldCustom(context: context, controller: firstNameController),
        /////////////////////////
        SizedBox(height: 16.0),
        _text("Last Name"),
        inputTextFieldCustom(context: context, controller: lastNameController),
      ],
    );
  }

  Widget _buildTripDetails() {
    if (selectedTrip == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.location_on_outlined,
            "${selectedTrip!.startCity} - ${selectedTrip!.endCity}"),
        _buildInfoRow(Icons.access_time, selectedTrip!.formattedStartDateTime,
            iconSize: 16),
        _buildInfoRow(
            Icons.monetization_on_outlined, selectedTrip!.ridePrice.toString(),
            iconColor: greenColor, iconSize: 16),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text,
      {Color iconColor = blackColor, double iconSize = 24}) {
    return Row(
      children: [
        if (icon != Icons.location_on_outlined) SizedBox(width: 4),
        Icon(icon, color: iconColor, size: iconSize),
        SizedBox(width: 8),
        _text(text),
      ],
    );
  }

  void _resetErrors() {
    setState(() {
      _pickUpPhoneError = null;
      _startLocationError = null;
      _endLocationError = null;
      _dropOffPhoneError = null;
      _tripError = null;
      _clientError = null;
    });
  }

  void _resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    selectedClient = null;
    setState(() {});
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
