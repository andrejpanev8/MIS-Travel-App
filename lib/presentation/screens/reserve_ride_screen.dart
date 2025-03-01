import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/presentation/widgets/map_static.dart';
import 'package:travel_app/presentation/widgets/ride_general_info_widget.dart';
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
          event:
              AddressEntryEvent(fromAddressController.text, uniqeKey: "from"),
        );
      }
    }

    if (!toAddressFocusNode.hasFocus) {
      if (toAddressController.text.isNotEmpty) {
        Functions.emitMapEvent(
          context: context,
          event: AddressEntryEvent(toAddressController.text, uniqeKey: "to"),
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
    return SafeArea(
        child: Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BlocListener<MapBloc, MapState>(
          listener: (context, state) => {
            if (state is MapSingleSelectionLoaded)
              {
                if (state.uniqueKey != null)
                  {
                    setState(() {
                      state.uniqueKey == "from"
                          ? fromAddressController.text = state.address
                          : toAddressController.text = state.address;
                    })
                  }
              },
            if (state is MapDoubleSelectionLoaded)
              {
                fromAddressController.text = state.fromAddress,
                toAddressController.text = state.toAddress
              }
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _generalInfo(),
            _buildForm(),
            SizedBox(height: 32.0),
            Text(AppStrings.selectALocation,
                style: StyledText().descriptionText()),
            MapStatic(multipleSelection: true),
            Row(
              children: [
                Expanded(
                    child:
                        customArrowButton(text: AppStrings.confirmReservation)),
              ],
            )
          ]),
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
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is TripInfoLoaded) {
        trip = state.trip;
        driver = state.driver;
      }
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: rideGeneralInfo(trip, driver));
    });
  }
}
