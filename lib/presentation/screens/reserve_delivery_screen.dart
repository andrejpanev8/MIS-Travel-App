import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/mock/mock_trips.dart';
import 'package:travel_app/data/mock/mock_users.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/presentation/widgets/ride_general_info_widget.dart';
import 'package:travel_app/presentation/widgets/ride_general_short_info_widget.dart';
import 'package:travel_app/service/user_service.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../bloc/map_bloc/map_bloc.dart';
import '../../data/models/location.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
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

  final FocusNode startLocationFocusNode = FocusNode();
  final FocusNode endLocationFocusNode = FocusNode();

  Trip? trip;
  UserModel? driver;
  Location? startLocation;
  Location? endLocation;

  String? _startLocationError;
  String? _endLocationError;

  @override
  void initState() {
    super.initState();

    startLocationFocusNode.addListener(() {
      if (!startLocationFocusNode.hasFocus) {
        if (startLocationController.text.isNotEmpty) {
          Functions.emitMapEvent(
            context: context,
            event: AddressEntryEvent(startLocationController.text,
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
            event: AddressEntryEvent(endLocationController.text,
                uniqueKey: END_LOCATION_RESERVE_DELIVERY_SCREEN),
          );
        }
      }
    });

    trip = mockTrips[0];
    _loadDriver();
  }

  Future<void> _loadDriver() async {
    driver = mockUsers[0];
    // driver = await UserService().getUserById(widget.trip.driverId);
  }

  @override
  void dispose() {
    startLocationController.dispose();
    endLocationController.dispose();
    startLocationFocusNode.dispose();
    endLocationFocusNode.dispose();
    super.dispose();
  }

  void _reserveDelivery() {

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
        listener: (context, state) => {
              if (state is MapSingleSelectionLoaded)
                {
                  if (state.uniqueKey == START_LOCATION_RESERVE_DELIVERY_SCREEN)
                    {
                      setState(() {
                        startLocationController.text = state.address;
                        startLocation = Location.fromLatLng(state.location);
                      })
                    }
                  else if (state.uniqueKey ==
                      END_LOCATION_RESERVE_DELIVERY_SCREEN)
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
                  rideGeneralShortInfo(trip, driver),
                  SizedBox(height: 20.0),
                  _buildForm(),
                  SizedBox(height: 40.0),
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
        ));
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          _text("End location, choose on map"),
          inputTextFieldCustom(
              context: context,
              controller: endLocationController,
              suffixIcon: Icon(Icons.location_on_outlined)),
          _buildErrorText(_endLocationError),
          SizedBox(height: 8),
          MapStatic(uniqueKey: END_LOCATION_ADD_DELIVERY_SCREEN),
        ],
      ),
    );
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