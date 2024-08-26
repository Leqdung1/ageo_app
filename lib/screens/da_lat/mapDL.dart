import 'dart:async';
import 'dart:typed_data';

import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/screens/da_lat/control_panel.dart';
import 'package:Ageo_solutions/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

enum MapSelected {
  // ignore: constant_identifier_names
  WaterLevel1,
  // ignore: constant_identifier_names
  WaterLevel2,
  // ignore: constant_identifier_names
  Gnss1,
  // ignore: constant_identifier_names
  Gnss2,
  // ignore: constant_identifier_names
  Gnss3,
  // ignore: constant_identifier_names
  Camera1,
  // ignore: constant_identifier_names
  Camera2,
  // ignore: constant_identifier_names
  Camera3,
  // ignore: constant_identifier_names
  Camera4,
  // ignore: constant_identifier_names
  Camera5,
  // ignore: constant_identifier_names
  WarningSensor1,
  // ignore: constant_identifier_names
  WarningSensor2,
  // ignore: constant_identifier_names
  Raingauge,
  // ignore: constant_identifier_names
  Piezometer1,
  // ignore: constant_identifier_names
  Piezometer2,
  // ignore: constant_identifier_names
  Piezometer3,
  // ignore: constant_identifier_names
  Inclinometer1,
  // ignore: constant_identifier_names
  Inclinometer2,
  // ignore: constant_identifier_names
  Inclinometer3,
}

extension MapSelectedExtension on MapSelected {
  String label(BuildContext context) {
    switch (this) {
      case MapSelected.WaterLevel1:
        return LocalData.waterLevel1.getString(context);
      case MapSelected.WaterLevel2:
        return LocalData.waterLevel2.getString(context);
      case MapSelected.Gnss1:
        return LocalData.gnss1.getString(context);
      case MapSelected.Gnss2:
        return LocalData.gnss2.getString(context);
      case MapSelected.Gnss3:
        return LocalData.gnss3.getString(context);
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
        return LocalData.warn1.getString(context);
      case MapSelected.WarningSensor2:
        return LocalData.warn2.getString(context);
      case MapSelected.Raingauge:
        return LocalData.mua.getString(context);
      case MapSelected.Piezometer1:
        return LocalData.piez1.getString(context);
      case MapSelected.Piezometer2:
        return LocalData.piez2.getString(context);
      case MapSelected.Piezometer3:
        return LocalData.piez3.getString(context);
      case MapSelected.Inclinometer1:
        return LocalData.inclino1.getString(context);
      case MapSelected.Inclinometer2:
        return LocalData.inclino2.getString(context);
      case MapSelected.Inclinometer3:
        return LocalData.inclino3.getString(context);
      default:
        return '';
    }
  }
}

class MapDaLatScreen extends StatefulWidget {
  const MapDaLatScreen({super.key});

  @override
  State<MapDaLatScreen> createState() => _MapDaLatScreenState();
}

class _MapDaLatScreenState extends State<MapDaLatScreen> {
  MapSelected _selectedMap = MapSelected.WaterLevel1;
  late MapboxMapController mapController;
  String selectedStyle = MapboxStyles.SATELLITE;
  final LatLng _initialCameraPosition = const LatLng(11.939545, 108.458877);
  final List<Symbol> _symbols = [];
  final LatLngBounds _cameraBounds = LatLngBounds(
    southwest: const LatLng(11.929545, 108.448877), // Southwest boundary
    northeast: const LatLng(11.949545, 108.468877), // Northeast boundary
  );
  bool isWithinBounds(LatLng position, LatLngBounds bounds) {
    return position.latitude >= bounds.southwest.latitude &&
        position.latitude <= bounds.northeast.latitude &&
        position.longitude >= bounds.southwest.longitude &&
        position.longitude <= bounds.northeast.longitude;
  }

  LatLng nearestPointWithinBounds(LatLng position, LatLngBounds bounds) {
    double lat = position.latitude
        .clamp(bounds.southwest.latitude, bounds.northeast.latitude);
    double lng = position.longitude
        .clamp(bounds.southwest.longitude, bounds.northeast.longitude);
    return LatLng(lat, lng);
  }

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
    _addCircles(); // Add circles first
    await _addMarkers(); // add markers
    _highlightSelectedMarker();

    mapController.onSymbolTapped.add(_onMarkerTapped);

    mapController.onSymbolTapped.add(_onMarkerTapped);
  }

  Future<void> _addMarkers() async {
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
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker1',
          geometry: LatLng(9.939545, 108.458877),
          iconAnchor: 'bottom',
        ),
      ),
    );

    // Add the second marker
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker2',
          geometry: LatLng(2.939555, 108.458887),
          iconAnchor: 'bottom',
        ),
      ),
    );

    // Add the third marker
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.03,
          iconImage: 'marker3',
          geometry: LatLng(11.939525, 108.458887),
          iconAnchor: 'bottom',
        ),
      ),
    );
  }

  void _addCircles() {
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

  void _onStyleLoadedCallback() async {
    _addCircles();
    await _addMarkers();
  }

  void _highlightSelectedMarker() {
    // Reset all markers to their default state
    for (int i = 0; i < _symbols.length; i++) {
      mapController.updateSymbol(
        _symbols[i],
        SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker${i + 1}',
        ),
      );
    }

    // Highlight the marker based on the selected map item
    switch (_selectedMap) {
      case MapSelected.WaterLevel1:
        mapController.updateSymbol(
          _symbols[0],
          const SymbolOptions(
            iconSize: 0.5,
          ),
        );
        break;
      case MapSelected.WaterLevel2:
        mapController.updateSymbol(
          _symbols[1],
          const SymbolOptions(
            iconSize: 0.5,
          ),
        );
        break;
      case MapSelected.Gnss1:
        mapController.updateSymbol(
          _symbols[2],
          const SymbolOptions(
            iconSize: 0.5,
          ),
        );
        break;
      default:
        break;
    }
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
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Marker Name: $name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Location: ${symbol.options.geometry?.latitude}, ${symbol.options.geometry?.longitude}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  // idle camera
  void _onCameraIdle() {
    final LatLng currentPosition = mapController.cameraPosition!.target;
    if (!isWithinBounds(currentPosition, _cameraBounds)) {
      final LatLng nearestPoint =
          nearestPointWithinBounds(currentPosition, _cameraBounds);
      mapController.animateCamera(CameraUpdate.newLatLng(nearestPoint));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            styleString: selectedStyle,
            rotateGesturesEnabled: true,
            trackCameraPosition: true,
            onMapCreated: _onMapCreated,
            onCameraIdle: _onCameraIdle,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 16,
              bearing: 16,
              tilt: 90,
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                const SizedBox(
                  width: 25,
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
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
                        _highlightSelectedMarker();
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.layers_outlined,
                      size: 25,
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
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.zoom_in,
                      size: 25,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      mapController.animateCamera(CameraUpdate.zoomIn());
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.zoom_out,
                      size: 25,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      mapController.animateCamera(CameraUpdate.zoomOut());
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
