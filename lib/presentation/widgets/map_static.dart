import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../bloc/map_bloc/map_bloc.dart';
import '../../service/map_service.dart';
import '../../utils/color_constants.dart';
import '../../utils/string_constants.dart';
import '../screens/map_screen.dart';

class MapStatic extends StatefulWidget {
  final bool multipleSelection;
  final String? uniqueKey;

  const MapStatic({super.key, this.uniqueKey, this.multipleSelection = false});

  @override
  State<MapStatic> createState() => _MapStaticState();
}

class _MapStaticState extends State<MapStatic> {
  String? currentMapLink;
  List<LatLng>? route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MapService().openMap(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MapScreen(isSelectingRoute: widget.multipleSelection)),
            widget.uniqueKey);
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapSingleSelectionLoaded) {
            if (widget.uniqueKey != null) {
              if (widget.uniqueKey == state.uniqueKey) {
                currentMapLink = state.mapStaticLink;
              }
            } else {
              currentMapLink = state.mapStaticLink;
            }
          }
          if (state is MapDoubleSelectionLoaded) {
            if (!widget.multipleSelection && state.mapLinks != null) {
              currentMapLink = widget.uniqueKey == FROM
                  ? state.mapLinks!["from"]
                  : state.mapLinks!["to"];
            } else {
              currentMapLink = state.mapStaticLink;
            }
          }
          if (state is MapMultiStopRouteLoaded) {
            currentMapLink = state.mapStaticLink;
            route = state.route;
          }
          if (state is MapInitial) {
            currentMapLink = null;
          }
          return currentMapLink != null
              ? CachedNetworkImage(
                  imageUrl: currentMapLink!,
                  placeholder: (context, url) => SizedBox(
                      width: 50,
                      height: 50,
                      child: const CircularProgressIndicator()),
                  errorWidget: (context, url, error) => _errorWidget(),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.contain,
                )
              : Padding(
                  padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(color: silverColor),
                    child: Center(
                      child: Text("Tap to select a location"),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return GestureDetector(
      onTap: () => MapService().openMap(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MapScreen(isSelectingRoute: widget.multipleSelection)),
          widget.uniqueKey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 40),
          SizedBox(height: 8),
          Text(
            'Failed to load map',
            style: TextStyle(color: Colors.red, fontSize: 14),
          )
        ],
      ),
    );
  }
}
