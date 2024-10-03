import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/models/warn_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:Ageo_solutions/lang/localization.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1IjoiZHVuZzEyMyIsImEiOiJjbHpxc252eWMwd2ZwMm1zM2p6a3MyaDI0In0.VVgBTGJ0X1qSPwZwZuxmZg';

enum MapSelected {
  D39H1,
  // ignore: constant_identifier_names
  D39H2,
  // ignore: constant_identifier_names
  D39H3,
  // ignore: constant_identifier_names
  D39Pz1,
  // ignore: constant_identifier_names
  D39Pz2,
  // ignore: constant_identifier_names
  D39Ds1,
  // ignore: constant_identifier_names
  D39Ds2,
  // ignore: constant_identifier_names
  D39Ds3,
  // ignore: constant_identifier_names
  D39Inc2,
  // ignore: constant_identifier_names
  D39Gw,
}

extension MapSelectedExtension on MapSelected {
  String label(BuildContext context) {
    switch (this) {
      case MapSelected.D39H1:
        return 'D39-H-1';
      case MapSelected.D39H2:
        return 'D39-H-2';
      case MapSelected.D39H3:
        return 'D39-H-3';
      case MapSelected.D39Pz1:
        return 'D39-PZ-1';
      case MapSelected.D39Pz2:
        return 'D39-PZ-2';
      case MapSelected.D39Ds1:
        return 'D39-DS-1';
      case MapSelected.D39Ds2:
        return 'D39-DS-2';
      case MapSelected.D39Ds3:
        return 'D39-DS-3';
      case MapSelected.D39Inc2:
        return 'D39-INC-2';
      case MapSelected.D39Gw:
        return 'D39-GW';
      default:
        return '';
    }
  }
}

class MapHyScreen extends StatefulWidget {
  const MapHyScreen({super.key});

  @override
  State<MapHyScreen> createState() => _MapHyScreenState();
}

class _MapHyScreenState extends State<MapHyScreen> {
  MapSelected? _selectedMap;

  MapSelected? _clickedMarker;
  final MapController _mapController = MapController();
  List<warnData> _items = [];
  final apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    fetchWarnData();
  }

  // fetch api
  Future<void> fetchWarnData() async {
    try {
      final response = await apiClient.getDeviceData();

      if (response['success']) {
        List<warnData> data = (response['data'] as List)
            .map((data) => warnData.fromJson(data))
            .toList();

        setState(() {
          _items = data;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  // Marker
  final Map<MapSelected, LatLng> _markerLocations = {
    // Water Level 01
    MapSelected.D39H1: const LatLng(
      20.742539824839,
      106.082213380823,
    ),
    // Water Level 02
    MapSelected.D39H2: const LatLng(
      20.742534011129,
      106.082175605717,
    ),
    // GNSS 01
    MapSelected.D39H3: const LatLng(
      20.742526614937,
      106.082116600124,
    ),
    // GNSS 02
    MapSelected.D39Pz1: const LatLng(
      20.742519653858,
      106.082175023530,
    ),
    // GNSS 03
    MapSelected.D39Pz2: const LatLng(
      20.742519653858,
      106.082175023530,
    ),
    // Camera 01
    MapSelected.D39Ds1: const LatLng(
      20.742521142102,
      106.082182523256,
    ),
    // Camera 02
    MapSelected.D39Ds2: const LatLng(
      20.742521142102,
      106.082182523256,
    ),
    // Camera 03
    MapSelected.D39Ds3: const LatLng(
      20.742521142102,
      106.082182523256,
    ),
    // Camera 04
    MapSelected.D39Inc2: const LatLng(
      20.742513054516,
      106.082104213810,
    ),
    // Camera 05
    MapSelected.D39Gw: const LatLng(
      20.742509529159,
      106.082104668811,
    ),
  };

  void _showMarkerDetails(String name, LatLng value) {
    final matchingItem = _items.firstWhere(
      (item) => item.lat == value.latitude && item.lng == value.longitude,
      orElse: () => warnData(
        status: -1,
        code: 'N/A',
        title: 'No data available',
        lat: value.latitude,
        lng: value.longitude,
        v1: 0.0,
        v2: 0.0,
        v3: 0.0,
        time: DateTime.now().toLocal(),
      ),
    );

    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.25,
          width: MediaQuery.sizeOf(context).width * 0.8,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 15,
            right: 15,
          ),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matchingItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
              Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalData.lastConnect.getString(context),
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'V1',
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'V2',
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'V3',
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ]),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(matchingItem.time),
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${matchingItem.v1}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${matchingItem.v2}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${matchingItem.v3}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                ),
              ]),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _clickedMarker = null;
        _selectedMap = null;
      });
    });
  }

  void _updateMarkerDetails(MapSelected selected) {
    final location = _markerLocations[selected];
    if (location != null) {
      // Reset the clicked marker state
      setState(() {
        _clickedMarker = selected;
      });

      // Move the map to the new location
      _mapController.move(location, 18);

      // Show the marker details
      _showMarkerDetails(
        selected.label(context),
        location,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: Text(
          LocalData.title2.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Expanded(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(20.742519653858, 106.082175023530),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/satellite-streets-v12',
                  },
                ),
                // CircleLayer(
                //   circles: [
                //     CircleMarker(
                //       point: const LatLng(11.939445, 108.458775),
                //       radius: 70,
                //       useRadiusInMeter: true,
                //       color: Colors.blue.withOpacity(0.3),
                //       borderColor: Colors.blue,
                //       borderStrokeWidth: 2,
                //     ),
                //   ],
                // ),
                MarkerLayer(
                  markers: _markerLocations.entries.map((entry) {
                    Widget iconWidget;

                    if (_clickedMarker == entry.key ||
                        (_selectedMap == entry.key && _clickedMarker == null)) {
                      // When the marker is selected or matches the selected map
                      iconWidget = SvgPicture.asset('assets/icons/map_pin.svg');
                    } else {
                      switch (entry.key) {
                        case MapSelected.D39Ds1:
                        case MapSelected.D39Ds2:
                        case MapSelected.D39Ds3:
                          iconWidget = SvgPicture.asset(
                              'assets/icons/map_cam.svg',
                              width: 15,
                              height: 15);
                          break;

                        case MapSelected.D39Gw:
                          iconWidget = SvgPicture.asset(
                              'assets/icons/map_water.svg',
                              width: 15,
                              height: 15);
                          break;
                        case MapSelected.D39H1:
                        case MapSelected.D39H2:
                        case MapSelected.D39H3:
                          iconWidget = SvgPicture.asset(
                              'assets/icons/map_rain.svg',
                              width: 15,
                              height: 15);
                          break;
                        case MapSelected.D39Inc2:
                          iconWidget = SvgPicture.asset(
                              'assets/icons/map_inclino.svg',
                              width: 15,
                              height: 15);
                          break;
                        case MapSelected.D39Pz1:
                        case MapSelected.D39Pz2:
                          iconWidget = SvgPicture.asset(
                              'assets/icons/map_piez.svg',
                              width: 15,
                              height: 15);
                          break;
                      }
                    }

                    return Marker(
                      point: entry.value,
                      width: 40,
                      height: 40,
                      rotate: true,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _clickedMarker = entry.key;
                            print("Clicked Marker: $_clickedMarker");
                            _selectedMap = entry.key;
                          });
                          _mapController.move(entry.value, 18);
                          _showMarkerDetails(
                              entry.key.label(context), entry.value);
                        },
                        child: iconWidget,
                      ),
                    );
                  }).toList()
                    // Sort so the clicked marker is always on top
                    ..sort((a, b) {
                      if (a.point == _markerLocations[_clickedMarker]) return 1;
                      if (b.point == _markerLocations[_clickedMarker])
                        return -1;
                      if (a.point == _markerLocations[_selectedMap]) return 1;
                      if (b.point == _markerLocations[_selectedMap]) return -1;
                      return 0;
                    }),
                )
              ],
            ),

            // Drop down
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: DropdownMenu(
                    key: ValueKey(_selectedMap?.name),
                    hintText: LocalData.chooseSensor.getString(context),
                    textStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                        Color.fromARGB(255, 255, 255, 255),
                      ),
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
                    // If _selectedMap is null, show hint text
                    initialSelection: _selectedMap?.name,
                    onSelected: (value) {
                      setState(() {
                        _selectedMap = MapSelected.values
                            .firstWhere((e) => e.name == value);
                        _clickedMarker = _selectedMap;
                        _updateMarkerDetails(_selectedMap!);
                      });
                    },
                    dropdownMenuEntries: MapSelected.values
                        .map((e) => DropdownMenuEntry(
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
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
