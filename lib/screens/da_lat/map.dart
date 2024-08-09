import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter_localization/flutter_localization.dart';

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

  // Store the LatLng coordinates for each MapSelected value
  final Map<MapSelected, LatLng> _markerLocations = {
    MapSelected.WaterLevel1: LatLng(11.939528977396272, 108.45900523689106),
    MapSelected.WaterLevel2: LatLng(11.93946247331182, 108.45895587948053),
    MapSelected.Gnss1: LatLng(11.939580805012907, 108.45894555773921),
    MapSelected.Gnss2: LatLng(11.939466606143682, 108.45905641578773),
    MapSelected.Gnss3: LatLng(11.939597862202428, 108.4591085019392),
    MapSelected.Camera1: LatLng(11.939021913175509, 108.45918398707114),
    MapSelected.Camera2: LatLng(11.939083079165579, 108.45895756917062),
    MapSelected.Camera3: LatLng(11.93965953049003, 108.45907363322084),
    MapSelected.Camera4: LatLng(11.939086018567691, 108.45858028556479),
    MapSelected.Camera5: LatLng(11.939082252599732, 108.45858499344662),
    MapSelected.WarningSensor1: LatLng(11.939697581128717, 108.45902736511498),
    MapSelected.WarningSensor2: LatLng(11.93949305625895, 108.45916624536686),
    MapSelected.Raingauge: LatLng(11.939849127581523, 108.4590910675802),
    MapSelected.Piezometer1: LatLng(11.939616887526727, 108.45911654856624),
    MapSelected.Piezometer2: LatLng(11.93946247331182, 108.45895587948053),
    MapSelected.Piezometer3: LatLng(11.939333528955688, 108.45878099699925),
    MapSelected.Inclinometer1: LatLng(11.939556531320394, 108.45907095101221),
    MapSelected.Inclinometer2: LatLng(11.939515856479114, 108.45899786081614),
    MapSelected.Inclinometer3: LatLng(11.939414532468547, 108.45889167142003),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          LocalData.title1.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.45),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
                    print("Selected map item: $_selectedMap");
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
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-1, 1),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(11.939386, 108.458788),
                      initialZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.app',
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
                          final selectedColor = _selectedMap == entry.key
                              ? Colors.green
                              : Colors.red;
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
