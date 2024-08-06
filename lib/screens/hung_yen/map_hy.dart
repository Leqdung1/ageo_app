import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

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

class MapHyScreen extends StatefulWidget {
  const MapHyScreen({super.key});

  @override
  State<MapHyScreen> createState() => _MapHyScreenState();
}

class _MapHyScreenState extends State<MapHyScreen> {
  MapSelected _selectedMap = MapSelected.WaterLevel1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Hy",
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
