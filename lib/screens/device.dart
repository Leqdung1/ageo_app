import 'package:ageo_app/components/menu_side_bar.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final List<String> items = <String>[
    'GNSS',
    'Đo áp lực nước lỗ rỗng',
    'Thiết bị đo nghiêng sâu',
    'Rain gauge',
    'Water level',
  ];

  int? _itemsSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.07,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                bool _isSelected = _itemsSelected == index;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: _isSelected
                        ? Color.fromRGBO(42, 98, 154, 1)
                        : Color.fromRGBO(237, 235, 233, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _itemsSelected = _isSelected 
                        ? null 
                        : index;
                      });
                    },
                    child: Text(
                      items[index],
                      style: TextStyle(
                          fontSize: 15,
                          color: _isSelected
                              ? Colors.white
                              : Color.fromRGBO(135, 133, 131, 1),
                          fontWeight:
                              _isSelected ? FontWeight.bold : FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
