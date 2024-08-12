import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapBoxWidget extends StatefulWidget {
  @override
  State<MapBoxWidget> createState() => _MapBoxWidgetState();
}

class _MapBoxWidgetState extends State<MapBoxWidget> {
  late MapboxMapController mapController;
  String selectedStyle = MapboxStyles.SATELLITE;
  final LatLng _initialCameraPosition = LatLng(11.939545, 108.458877);

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.center_focus_strong),
            onPressed: () {
              setState(() {
                if (selectedStyle == MapboxStyles.SATELLITE) {
                  selectedStyle = MapboxStyles.MAPBOX_STREETS;
                } else {
                  selectedStyle = MapboxStyles.SATELLITE;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: selectedStyle, 
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _initialCameraPosition,
        zoom: 15,
      ),
    );
  }
}
