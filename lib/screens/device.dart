import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/screens/da_lat/device_screen/ap_lu_lo_rong.dart';
import 'package:Ageo_solutions/screens/da_lat/device_screen/gnss.dart';
import 'package:Ageo_solutions/screens/da_lat/device_screen/rain_gauge.dart';
import 'package:Ageo_solutions/screens/da_lat/device_screen/water_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceScreenState createState() => _DeviceScreenState();
}

final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

class _DeviceScreenState extends State<DeviceScreen> {
  int? _itemsSelected = 0;
  final List<String> items = [
    'GNSS',
    'Đo áp lực nước lỗ rỗng',
    'Thiết bị đo nghiêng sâu',
    'Rain gauge',
    'Water level',
  ];

  @override
  void initState() {
    super.initState();
  }

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
          // Choose devices screen
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = _itemsSelected == index;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color.fromRGBO(0, 65, 130, 1)
                          : Colors.grey.shade400,
                    ),
                    color: isSelected
                        ? const Color.fromRGBO(42, 98, 154, 1)
                        : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _itemsSelected = isSelected ? null : index;
                          },
                        );
                        debugPrint('Selected index: $_itemsSelected');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              ),
              // index screen
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.75,
                child: IndexedStack(
                  index: _itemsSelected,
                  children: [
                    gnssScreen(),
                    ApLucLoRongScreen(),
                    //nghiengSauScreen(),
                    RaingaugeScreen(),
                    WaterLevelScreen(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
