import 'package:flutter/material.dart';

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
  String get label {
    switch (this) {
      case MapSelected.WaterLevel1:
        return 'Water Level 01';
      case MapSelected.WaterLevel2:
        return 'Water Level 02';
      case MapSelected.Gnss1:
        return 'GNSS 01';
      case MapSelected.Gnss2:
        return 'GNSS 02';
      case MapSelected.Gnss3:
        return 'GNSS 03';
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
        return 'Warning Sensor 01';
      case MapSelected.WarningSensor2:
        return 'Warning Sensor 02';
      case MapSelected.Raingauge:
        return 'Raingauge';
      case MapSelected.Piezometer1:
        return 'Piezometer 01';
      case MapSelected.Piezometer2:
        return 'Piezometer 02';
      case MapSelected.Piezometer3:
        return 'Piezometer 03';
      case MapSelected.Inclinometer1:
        return 'Inclinometer 01';
      case MapSelected.Inclinometer2:
        return 'Inclinometer 02';
      case MapSelected.Inclinometer3:
        return 'Inclinometer 03';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.white,
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
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                selectedTrailingIcon: const Icon(Icons.expand_less),
                trailingIcon: const Icon(Icons.expand_more),
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
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                initialSelection: _selectedMap.name,
                onSelected: (value) {
                  setState(() {
                    _selectedMap = MapSelected.values.byName(value as String);
                  });
                },
                dropdownMenuEntries: MapSelected.values
                    .map(
                      (e) => DropdownMenuEntry(value: e.name, label: e.label),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [Container()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}