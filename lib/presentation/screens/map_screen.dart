import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';

import '../../data/services/map_service.dart';
import '../../utils/connections.dart';

class MapScreen extends StatefulWidget {
  final bool isSelectingRoute; // Selecting one location or a route

  const MapScreen({super.key, this.isSelectingRoute = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapService _mapService = MapService();

  LatLng? _selectedLocation;
  LatLng? _fromLocation;
  LatLng? _toLocation;

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  List<LatLng> _routePoints = [];

  void _updateRoute() async {
    if (_fromLocation == null || _toLocation == null) return;

    List<LatLng> route =
        await _mapService.getRoute(_fromLocation!, _toLocation!);

    setState(() {
      _routePoints = route;
    });
  }

  Future<void> _setLocationFromAddress(String address, bool isFromField) async {
    final coordinates = await _mapService.getCoordinatesFromAddress(address);
    if (coordinates != null) {
      setState(() {
        if (isFromField) {
          _fromLocation =
              LatLng(coordinates['latitude'], coordinates['longitude']);
        } else {
          _toLocation =
              LatLng(coordinates['latitude'], coordinates['longitude']);
        }

        if (_fromLocation != null && _toLocation != null) {
          _updateRoute();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter:
                  _selectedLocation ?? LatLng(41.99812940, 21.42543550),
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                if (!widget.isSelectingRoute) {
                  setState(() {
                    _selectedLocation = point;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: urlTemplate,
                subdomains: subdomains,
              ),
              if (_selectedLocation != null)
                _markerLayer(_selectedLocation!, Colors.red),
              if (_fromLocation != null)
                _markerLayer(_fromLocation!, Colors.blue),
              if (_toLocation != null) _markerLayer(_toLocation!, Colors.green),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.lightBlue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
            ],
          ),
          if (widget.isSelectingRoute)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  _buildAddressField(_fromController, "From Address", true),
                  const SizedBox(height: 10),
                  _buildAddressField(_toController, "To Address", false),
                ],
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (widget.isSelectingRoute) {
                  Navigator.pop(context, {
                    "from": _fromLocation,
                    "to": _toLocation,
                  });
                } else {
                  Navigator.pop(context, _selectedLocation);
                }
              },
              child:
                  Text(widget.isSelectingRoute ? 'Set Route' : 'Set Location'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _markerLayer(LatLng location, Color color) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location,
          width: 40,
          height: 40,
          child: Icon(Icons.location_pin, size: 40, color: color),
        ),
      ],
    );
  }

  Widget _buildAddressField(
      TextEditingController controller, String hint, bool isFromField) {
    return inputTextFieldCustom(
        context: context,
        controller: controller,
        hintText: hint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _setLocationFromAddress(controller.text, isFromField);
          },
        ));
  }
}
