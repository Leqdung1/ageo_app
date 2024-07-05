import 'package:ageo_app/screens/device_items/ap_lu_lo_rong.dart';
import 'package:ageo_app/screens/device_items/gnss.dart';
import 'package:ageo_app/screens/device_items/nghieng_sau.dart';
import 'package:ageo_app/screens/device_items/rain_gauge.dart';
import 'package:ageo_app/screens/device_items/water_level.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

class _DeviceScreenState extends State<DeviceScreen> {
  final List<String> items = <String>[
    'GNSS',
    'Đo áp lực nước lỗ rỗng',
    'Thiết bị đo nghiêng sâu',
    'Rain gauge',
    'Water level',
  ];

  int? _itemsSelected = 0;

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      customModePickerIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(21, 101, 192, 1),
                        size: 25,
                      ),
                      dayTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      selectedDayHighlightColor:
                          Color.fromRGBO(21, 101, 192, 1),
                      lastMonthIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(21, 101, 192, 1),
                        size: 18,
                      ),
                      nextMonthIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(21, 101, 192, 1),
                        size: 18,
                      ),
                      disableMonthPicker: true,
                      controlsTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      weekdayLabelTextStyle: const TextStyle(
                        color: Color(0x4D3C3C43),
                        fontSize: 16,
                      ),
                    ),
                    value: [
                      isStart ? _startDate : _endDate,
                    ],
                    onValueChanged: (value) {
                      setState(() {
                        if (isStart) {
                          _startDate =
                              value[0]!.copyWith(hour: 0, minute: 0, second: 0);
                        } else {
                          _endDate = value[0]!.copyWith(hour: 0, minute: 0);
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.08,
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: _isSelected
                        ? Color.fromRGBO(42, 98, 154, 1)
                        : Color.fromRGBO(237, 235, 233, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _itemsSelected = _isSelected ? null : index;
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-1, 1),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Container(
                              height: size.height * 0.06,
                              width: size.width * 0.413,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color.fromRGBO(210, 221, 238, 1),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, bottom: 2),
                                        child: Text(
                                          'Từ ngày',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(21, 101, 192, 1),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_startDate),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 7.5),
                                    child: SvgPicture.asset(
                                        'assets/icons/calender.svg',
                                        height: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Container(
                              height: size.height * 0.06,
                              width: size.width * 0.413,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color.fromRGBO(210, 221, 238, 1),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, bottom: 2),
                                        child: Text(
                                          'Đến ngày',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(21, 101, 192, 1),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(_endDate),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 7.5),
                                    child: SvgPicture.asset(
                                      'assets/icons/calender.svg',
                                      height: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 2,
                      width: size.width * 1,
                      color: Color.fromRGBO(236, 236, 236, 1),
                    ),
                    IndexedStack(
                      index: _itemsSelected,
                      children: [
                        gnssScreen(),
                        ApLucLoRongScreen(),
                        nghiengSauScreen(),
                        raingaugeScreen(),
                        waterLevelScreen(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
