import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapSelected _selectedMap = MapSelected.WaterLevel1;
  final MapController _mapController = MapController();

  // Store the LatLng coordinates for each MapSelected value
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
            fontSize: 20,
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
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: const LatLng(11.939445, 108.458775),
                      radius: 70,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: _markerLocations.entries.map((entry) {
                    final selectedColor =
                        _selectedMap == entry.key ? Colors.green : Colors.red;
                    return Marker(
                      point: entry.value,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        color: selectedColor,
                      ),
                    );
                  }).toList(),
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
