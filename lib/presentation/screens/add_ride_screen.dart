import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/services/map_service.dart';
import '../../utils/string_constants.dart';
import '../widgets/input_field.dart';
import 'map_screen.dart';

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

  LatLng? _startLocationLatLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(),
              SizedBox(height: 24.0),
              Text(AppStrings.selectALocation,
                  style: StyledText().descriptionText(
                      fontSize: 18, fontWeight: StyledText().regular)),
              _buildMap(),
              Row(
                children: [
                  Expanded(
                      child: customArrowButton(
                          text: "Save",
                          onPressed: () async {
                            //TO:DO implement save ride button
                            var res = await MapService()
                                .getCoordinatesFromAddress(
                                    startLocationController.text);
                            if (res != null) {
                              setState(() {
                                _startLocationLatLng =
                                    LatLng(res["latitude"], res["longitude"]);
                              });
                            }
                          })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: GestureDetector(
        onTap: _callMap,
        child: _startLocationLatLng != null
            ? CachedNetworkImage(
                imageUrl: MapService().generateMapUrl(
                    _startLocationLatLng!.latitude,
                    _startLocationLatLng!.longitude),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 250,
                fit: BoxFit.contain,
              )
            : Container(
                height: 250,
                decoration: BoxDecoration(color: silverColor),
                child: Center(
                  child: Text("Tap to select starting location"),
                ),
              ),
      ),
    );
  }

  Future<void> _callMap() async {
    final result = await MapService().openMap(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    String address = "";

    if (result != null) {
      address = await MapService()
              .getAddressFromCoordinates(result.latitude, result.longitude) ??
          "";
    }

    setState(() {
      _startLocationLatLng = result;
      startLocationController.text = address;
    });
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
          inputTextFieldCustom(
              context: context,
              controller: startTimeController,
              suffixIcon: Icon(Icons.access_time)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Start Location"),
          inputTextFieldCustom(
              context: context,
              controller: startLocationController,
              suffixIcon: Icon(Icons.map_outlined)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Max Capacity"),
          inputTextFieldCustom(
              context: context,
              controller: maxCapacityController,
              suffixIcon: Icon(Icons.person_outline)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Price"),
          inputTextFieldCustom(
              context: context,
              controller: priceController,
              suffixIcon: Icon(Icons.monetization_on_outlined)),
          //////////////////////////
          SizedBox(height: 16.0),
          _text("Driver"),
          inputTextFieldCustom(
              context: context,
              controller: driverController,
              suffixIcon: Icon(Icons.badge_outlined)),
        ],
      ),
    );
  }
}

Widget _text(String text) {
  return Text(text, style: StyledText().descriptionText());
}
