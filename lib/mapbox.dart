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

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  _loadImage("assets/images/Avater.png").then((image) {
    mapController.addImage("marker", image);
    _addCircle(); 
    _addMarker(); 
  });
  }

Future<Uint8List> _loadImage(String assetPath) async {
  final Completer<Uint8List> completer = Completer();
  final ByteData data = await rootBundle.load(assetPath);
  completer.complete(data.buffer.asUint8List());
  return completer.future;
}
  void _addMarker() {
    mapController.addSymbols([
      const SymbolOptions(
        iconSize: 0.3,
        iconImage: "marker",
        geometry: LatLng(11.939545, 108.458877),
        iconAnchor: "bottom",
      ),
      const SymbolOptions(
        iconSize: 0.3,
        iconImage: "marker",
        geometry: LatLng(11.939528977396272, 108.45900523689106),
        iconAnchor: "bottom",
      ),
    ]);
  }

  void _addCircle() {
    mapController.addCircle(
      CircleOptions(
        geometry: _initialCameraPosition,
        circleRadius: 50,
        circleColor: "#4E31AA",
        circleOpacity: 0.2,
        circleStrokeColor: "#4E31AA",
        circleStrokeWidth: 2.0,
      ),
    );
  }

  void _onStyleLoadedCallback() {
    _addCircle(); 
    _addMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            styleString: selectedStyle,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 16,
            ),
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
                  child: const Icon(
                    Icons.change_circle,
                    color: Colors.blue,
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
