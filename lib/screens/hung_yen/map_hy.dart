import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/models/warn_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter_localization/flutter_localization.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1IjoiZHVuZzEyMyIsImEiOiJjbHpxc252eWMwd2ZwMm1zM2p6a3MyaDI0In0.VVgBTGJ0X1qSPwZwZuxmZg';

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

class MapHyScreen extends StatefulWidget {
  const MapHyScreen({super.key});

  @override
  State<MapHyScreen> createState() => _MapHyScreenState();
}

class _MapHyScreenState extends State<MapHyScreen> {
  MapSelected _selectedMap = MapSelected.WaterLevel1;
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
    MapSelected.WaterLevel1: const LatLng(
      11.939511100000,
      108.458991666667,
    ),
    // Water Level 02
    MapSelected.WaterLevel2: const LatLng(
      11.939505600000,
      108.458986111111,
    ),
    // GNSS 01
    MapSelected.Gnss1: const LatLng(
      11.939577800000,
      108.458930555556,
    ),
    // GNSS 02
    MapSelected.Gnss2: const LatLng(
      11.939458300000,
      108.459038888889,
    ),
    // GNSS 03
    MapSelected.Gnss3: const LatLng(
      11.939580600000,
      108.459080555556,
    ),
    // Camera 01
    MapSelected.Camera1: const LatLng(
      11.938997200000,
      108.459172222222,
    ),
    // Camera 02
    MapSelected.Camera2: const LatLng(
      11.939072200000,
      108.458936111111,
    ),
    // Camera 03
    MapSelected.Camera3: const LatLng(
      11.939633300000,
      108.459041666667,
    ),
    // Camera 04
    MapSelected.Camera4: const LatLng(
      11.939058300000,
      108.458569444444,
    ),
    // Camera 05
    MapSelected.Camera5: const LatLng(
      11.939058300000,
      108.458569444444,
    ),
    // Warn 01
    MapSelected.WarningSensor1: const LatLng(
      11.939686110000,
      108.459011110000,
    ),
    // Warn 02
    MapSelected.WarningSensor2: const LatLng(
      11.939466670000,
      108.459155560000,
    ),
    // Raingauge
    MapSelected.Raingauge: const LatLng(
      11.939827800000,
      108.459050000000,
    ),
    // Piez 01
    MapSelected.Piezometer1: const LatLng(
      11.939605600000,
      108.459100000000,
    ),
    // Piez 02
    MapSelected.Piezometer2: const LatLng(
      11.939461100000,
      108.458933333333,
    ),
    // Piez 03
    MapSelected.Piezometer3: const LatLng(
      11.939277800000,
      108.458736111111,
    ),
    // Incli 01
    MapSelected.Inclinometer1: const LatLng(
      11.939552800000,
      108.459050000000,
    ),
    // Incli 02
    MapSelected.Inclinometer2: const LatLng(
      11.939494400000,
      108.458980555556,
    ),
    // Incli 03
    MapSelected.Inclinometer3: const LatLng(
      11.939402800000,
      108.458875000000,
    ),
  };

  void _showMarkerDetails(String name, LatLng value) {
    // Find the matching item based on latitude and longitude
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

    // Show the modal bottom sheet with info of sensor
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
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
              matchingItem.title == 'Water Level 01'
                  ? Text(
                      LocalData.waterLevel1.getString(context),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    )
                  : matchingItem.title == 'Water Level 02'
                      ? Text(
                          LocalData.waterLevel2.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        )
                      : matchingItem.title == 'GNSS 01'
                          ? Text(
                              LocalData.gnss1.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            )
                          : matchingItem.title == 'GNSS 02'
                              ? Text(
                                  LocalData.gnss2.getString(context),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                )
                              : matchingItem.title == 'GNSS 03'
                                  ? Text(
                                      LocalData.gnss3.getString(context),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    )
                                  : matchingItem.title == 'Camera 01'
                                      ? Text(
                                          'Camera 01',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                        )
                                      : matchingItem.title == 'Camera 02'
                                          ? Text(
                                              'Camera 02',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            )
                                          : matchingItem.title == 'Camera 03'
                                              ? Text(
                                                  'Camera 03',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                )
                                              : matchingItem.title ==
                                                      'Camera 04'
                                                  ? Text(
                                                      'Camera 04',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    )
                                                  : matchingItem.title ==
                                                          'Camera 05'
                                                      ? Text(
                                                          'Camera 05',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                          ),
                                                        )
                                                      : matchingItem.title ==
                                                              'Warning sensor 01'
                                                          ? Text(
                                                              LocalData.warn1
                                                                  .getString(
                                                                      context),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                              ),
                                                            )
                                                          : matchingItem
                                                                      .title ==
                                                                  'Warning sensor 02'
                                                              ? Text(
                                                                  LocalData
                                                                      .warn2
                                                                      .getString(
                                                                          context),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge
                                                                        ?.color,
                                                                  ),
                                                                )
                                                              : matchingItem
                                                                          .title ==
                                                                      'Rain gauge'
                                                                  ? Text(
                                                                      LocalData
                                                                          .mua
                                                                          .getString(
                                                                              context),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge
                                                                            ?.color,
                                                                      ),
                                                                    )
                                                                  : matchingItem
                                                                              .title ==
                                                                          'Piezometer 01'
                                                                      ? Text(
                                                                          LocalData
                                                                              .piez1
                                                                              .getString(context),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyLarge?.color,
                                                                          ),
                                                                        )
                                                                      : matchingItem.title ==
                                                                              'Piezometer 02'
                                                                          ? Text(
                                                                              LocalData.piez2.getString(context),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                              ),
                                                                            )
                                                                          : matchingItem.title == 'Piezometer 03'
                                                                              ? Text(
                                                                                  LocalData.piez3.getString(context),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 15,
                                                                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                  ),
                                                                                )
                                                                              : matchingItem.title == 'Inclinometer 01'
                                                                                  ? Text(
                                                                                      LocalData.inclino1.getString(context),
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                      ),
                                                                                    )
                                                                                  : matchingItem.title == 'Inclinometer 02'
                                                                                      ? Text(
                                                                                          LocalData.inclino2.getString(context),
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                          ),
                                                                                        )
                                                                                      : Text(
                                                                                          LocalData.inclino3.getString(context),
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                          ),
                                                                                        ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Last connect: ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: '${matchingItem.time}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'V1: ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: '${matchingItem.v1}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'V2: ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: '${matchingItem.v2}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'V3: ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: '${matchingItem.v3}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateMarkerDetails(MapSelected selected) {
    final location = _markerLocations[selected];
    if (location != null) {
      _mapController.move(location, 18);
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
          LocalData.title1.getString(context),
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
                initialCenter: LatLng(11.939386, 108.458788),
                initialZoom: 18,
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
                      iconWidget = SvgPicture.asset(
                        'assets/icons/map_pin.svg',
                      );
                    } else {
                      switch (entry.key) {
                        case MapSelected.Camera1:
                        case MapSelected.Camera2:
                        case MapSelected.Camera3:
                        case MapSelected.Camera4:
                        case MapSelected.Camera5:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_cam.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.WaterLevel1:
                        case MapSelected.WaterLevel2:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_water.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.Raingauge:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_rain.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.Inclinometer1:
                        case MapSelected.Inclinometer2:
                        case MapSelected.Inclinometer3:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_inclino.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.Piezometer1:
                        case MapSelected.Piezometer2:
                        case MapSelected.Piezometer3:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_piez.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.Gnss1:
                        case MapSelected.Gnss2:
                        case MapSelected.Gnss3:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_gnss.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                        case MapSelected.WarningSensor1:
                        case MapSelected.WarningSensor2:
                          iconWidget = SvgPicture.asset(
                            'assets/icons/map_warn.svg',
                            width: 15,
                            height: 15,
                          );
                          break;
                      }
                    }

                    return Marker(
                      point: entry.value,
                      width: 40,
                      height: 40,
                      rotate: false,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _clickedMarker = entry.key;
                          });
                          _mapController.move(
                            entry.value,
                            18,
                          );

                          _showMarkerDetails(
                            entry.key.label(context),
                            entry.value,
                          );
                        },
                        child: iconWidget,
                      ),
                    );
                  }).toList()

                    // marker is clicked on top
                    ..sort((a, b) {
                      if (a.point == _markerLocations[_clickedMarker]) return 1;
                      if (b.point == _markerLocations[_clickedMarker]) {
                        return -1;
                      }
                      if (a.point == _markerLocations[_selectedMap]) return 1;
                      if (b.point == _markerLocations[_selectedMap]) return -1;
                      return 0;
                    }),
                ),
              ],
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
                    _selectedMap =
                        MapSelected.values.firstWhere((e) => e.name == value);
                    _clickedMarker = null;
                    _updateMarkerDetails(_selectedMap);
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
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
    );
  }
}
