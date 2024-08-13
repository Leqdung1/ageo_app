import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

enum MapSelected {
  WaterLevel1,
  WaterLevel2,
  Gnss1,
  Gnss2,
  Gnss3,
  Camera1,
  Camera2,
  Camera3,
  Camera4,
  Camera5,
  WarningSensor1,
  WarningSensor2,
  Raingauge,
  Piezometer1,
  Piezometer2,
  Piezometer3,
  Inclinometer1,
  Inclinometer2,
  Inclinometer3,
}

extension MapSelectedExtension on MapSelected {
  String label(BuildContext context) {
    switch (this) {
      case MapSelected.WaterLevel1:
        return 'Water Level 1';
      case MapSelected.WaterLevel2:
        return 'Water Level 2';
      case MapSelected.Gnss1:
        return 'GNSS 1';
      case MapSelected.Gnss2:
        return 'GNSS 2';
      case MapSelected.Gnss3:
        return 'GNSS 3';
      case MapSelected.Camera1:
        return 'Camera 01';
      case MapSelected.Camera2:
        return 'Camera 02';
      case MapSelected.Camera3:
        return 'Camera 03';
      case MapSelected.Camera4:
        return 'Camera 04';
      case MapSelected.Camera5:
        return 'Camera 05';
      case MapSelected.WarningSensor1:
        return 'Warning Sensor 1';
      case MapSelected.WarningSensor2:
        return 'Warning Sensor 2';
      case MapSelected.Raingauge:
        return 'Raingauge';
      case MapSelected.Piezometer1:
        return 'Piezometer 1';
      case MapSelected.Piezometer2:
        return 'Piezometer 2';
      case MapSelected.Piezometer3:
        return 'Piezometer 3';
      case MapSelected.Inclinometer1:
        return 'Inclinometer 1';
      case MapSelected.Inclinometer2:
        return 'Inclinometer 2';
      case MapSelected.Inclinometer3:
        return 'Inclinometer 3';
      default:
        return '';
    }
  }
}

class MapBoxWidget extends StatefulWidget {
  const MapBoxWidget({super.key});

  @override
  State<MapBoxWidget> createState() => _MapBoxWidgetState();
}

class _MapBoxWidgetState extends State<MapBoxWidget> {
  MapSelected _selectedMap = MapSelected.WaterLevel1;
  late MapboxMapController mapController;
  String selectedStyle = MapboxStyles.SATELLITE;
  final LatLng _initialCameraPosition = const LatLng(11.939545, 108.458877);
  final List<Symbol> _symbols = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> loadMarkerImage(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  void _onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    await _addMarkersAndCircles();

    mapController.onSymbolTapped.add(_onMarkerTapped);
  }

  Future<void> _addMarkersAndCircles() async {
    // Load marker images
    final Uint8List markerImage1 =
        await loadMarkerImage("assets/images/Avater.png");
    final Uint8List markerImage2 =
        await loadMarkerImage("assets/images/ava.jpg");
    final Uint8List markerImage3 =
        await loadMarkerImage("assets/images/ava.jpg");

    // Add the marker images to the map
    mapController.addImage('marker1', markerImage1);
    mapController.addImage('marker2', markerImage2);
    mapController.addImage('marker3', markerImage3);

    // Add the first marker
    _symbols.add(await mapController.addSymbol(
      SymbolOptions(
        iconSize: 0.3,
        iconImage: 'marker1',
        geometry: LatLng(9.939545, 108.458877), // First location
        iconAnchor: 'bottom',
      ),
    ));

    // Add the second marker
    _symbols.add(await mapController.addSymbol(
      SymbolOptions(
        iconSize: 0.3,
        iconImage: 'marker2',
        geometry: LatLng(2.939555, 108.458887), // Slightly different location
        iconAnchor: 'bottom',
      ),
    ));

    // Add the third marker
    _symbols.add(await mapController.addSymbol(
      SymbolOptions(
        iconSize: 0.3,
        iconImage: 'marker3',
        geometry: LatLng(11.939525, 108.458887), // Slightly different location
        iconAnchor: 'bottom',
      ),
    ));

    // Add a circle to the map
    _addCircle();
  }

  void _addCircle() {
    mapController.addCircle(
      CircleOptions(
        geometry: _initialCameraPosition, // Ensure this is a valid position
        circleRadius: 50,
        circleColor: "#4E31AA",
        circleOpacity: 0.2,
        circleStrokeColor: "#4E31AA",
        circleStrokeWidth: 2.0,
      ),
    );
  }

  void _onStyleLoadedCallback() async {
    await _addMarkersAndCircles();
  }

  void _onMarkerTapped(Symbol symbol) {
    int index = _symbols.indexOf(symbol);

    String name;
    switch (index) {
      case 0:
        name = "First Marker";
        break;
      case 1:
        name = "Second Marker";
        break;
      case 2:
        name = "Third Marker";
        break;
      default:
        name = "Unknown Marker";
        break;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Marker Name: $name\nLocation: ${symbol.options.geometry?.latitude}, ${symbol.options.geometry?.longitude}",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            styleString: selectedStyle,
            trackCameraPosition: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: DropdownMenu(
                    textStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    selectedTrailingIcon: Icon(
                      Icons.expand_less,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    trailingIcon: Icon(
                      Icons.expand_more,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    menuStyle: MenuStyle(
                      maximumSize:
                          const WidgetStatePropertyAll(Size.fromHeight(200)),
                      surfaceTintColor: const WidgetStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      fillColor: Theme.of(context).colorScheme.primary,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                    ),
                    initialSelection: _selectedMap.name,
                    onSelected: (value) {
                      setState(() {
                        _selectedMap = MapSelected.values
                            .firstWhere((e) => e.name == value);
                      });
                    },
                    dropdownMenuEntries: MapSelected.values
                        .map(
                          (e) => DropdownMenuEntry(
                            value: e.name,
                            labelWidget: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                e.label(context),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ),
                            label: e.label(context),
                          ),
                        )
                        .toList(),
                  ),
                ),
                FloatingActionButton(
                  child: Icon(
                    Icons.layers_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
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
          ),
        ],
      ),
    );
  }
}
