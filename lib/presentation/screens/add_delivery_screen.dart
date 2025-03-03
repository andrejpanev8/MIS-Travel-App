import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart';
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
import 'package:travel_app/utils/text_styles.dart';

// import '../../data/services/map_service.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import '../../utils/functions.dart';
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
  final TextEditingController pickupPhoneController = TextEditingController();
  final TextEditingController dropOffPhoneController = TextEditingController();
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();

  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  List<UserModel> clients = [];
  UserModel? selectedClient;
  List<Trip> trips = [];
  Trip? selectedTrip;
  Location? startLocation;
  Location? endLocation;

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
    pickupPhoneController.dispose();
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
                  startLocation = Location.fromLatLng(state.location);
                })
              }
            else if (state.uniqueKey == END_LOCATION_ADD_DELIVERY_SCREEN)
              {
                setState(() {
                  endLocationController.text = state.address;
                  endLocation = Location.fromLatLng(state.location);
                })
              }
          }
      },
      child: Scaffold(
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
                            onPressed: () {})),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
              controller: pickupPhoneController,
              suffixIcon: Icon(Icons.phone_callback_outlined)),
          SizedBox(height: 16.0),
          _text("Start location, choose on map"),
          inputTextFieldCustom(
              context: context,
              controller: startLocationController,
              focusNode: startLocationFocusNode,
              suffixIcon: Icon(Icons.location_on_outlined)),
          SizedBox(height: 8),
          MapStatic(uniqueKey: START_LOCATION_ADD_DELIVERY_SCREEN),

          SizedBox(height: 16.0),
          _text("Drop off phone number"),
          inputTextFieldCustom(
              context: context,
              controller: dropOffPhoneController,
              focusNode: endLocationFocusNode,
              suffixIcon: Icon(Icons.phone_forwarded_outlined)),
          SizedBox(height: 16.0),
          _text("End location, choose on map"),
          inputTextFieldCustom(
              context: context,
              controller: endLocationController,
              suffixIcon: Icon(Icons.location_on_outlined)),
          SizedBox(height: 8),
          MapStatic(uniqueKey: END_LOCATION_ADD_DELIVERY_SCREEN),
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
