import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:intl/intl.dart';

enum DataSelected {
  // ignore: constant_identifier_names
  Hours,
  // ignore: constant_identifier_names
  Day,
  // ignore: constant_identifier_names
  Month,
  // ignore: constant_identifier_names
  Year,
}

extension DataSelectedExtension on DataSelected {
  String get label {
    switch (this) {
      case DataSelected.Hours:
        return 'Hours';
      case DataSelected.Day:
        return 'Day';
      case DataSelected.Month:
        return 'Month';
      case DataSelected.Year:
        return 'Year';
      default:
        return '';
    }
  }
}

class RaingaugeScreen extends StatefulWidget {
  const RaingaugeScreen({super.key});

  @override
  State<RaingaugeScreen> createState() => _RaingaugeScreenState();
}

class _RaingaugeScreenState extends State<RaingaugeScreen> {
  DataSelected _dataSelected = DataSelected.Hours;
  late List<RainData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  Future<List<RainData>>? _rainDataBuilder;
  DateTime _startDate = DateTime.now().subtract(
    const Duration(days: 7),
  );
  DateTime _endDate = DateTime.now();
  final DateTime _startTime = DateTime.now().subtract(
    const Duration(days: 7),
  );
  final DateTime _endTime = DateTime.now();

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    _rainDataBuilder = fetchRainData(startDate: _startDate, endDate: _endDate);
    super.initState();
  }

  Future<List<RainData>> fetchRainData(
      {required DateTime startDate, required DateTime endDate}) async {
    final apiClient = ApiClient();
    final Map<String, dynamic> response;

    switch (_dataSelected) {
      case DataSelected.Hours:
        response = await apiClient.getRainDataByHours('yy/MM/dd HH');
        break;
      case DataSelected.Day:
        response = await apiClient.getRainDataByDay('yy/MM/dd');
        break;
      case DataSelected.Month:
        response = await apiClient.getRainDataByMonth('yy/MM');
        break;
      case DataSelected.Year:
        response = await apiClient.getRainDataByYear('yyyy');
        break;
      default:
        throw Exception('Invalid data selection');
    }

    if (response['success']) {
      List<RainData> data = (response['data'] as List)
          .map((data) => RainData.fromJson(data))
          .toList();

      // Filter data based on the date range
      return data.where((rainData) {
        switch (_dataSelected) {
          case DataSelected.Hours:
            DateTime logTime =
                DateFormat('yy/MM/dd HH').parse(rainData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Day:
            DateTime logTime = DateFormat('yy/MM/dd').parse(rainData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Month:
            DateTime logTime = DateFormat('yy/MM').parse(rainData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Year:
            DateTime logTime = DateFormat('yyyy').parse(rainData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);
        }
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // show date picker
  Future<void> showDateTime(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showOmniDateTimePicker(
      context: context,
      theme: ThemeData(
        hoverColor: Colors.blue,
        primaryColor: Colors.blue,
      ),
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(Tween(begin: 0, end: 1)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
        // Fetch and filter data based on the new date range
        _rainDataBuilder =
            fetchRainData(startDate: _startDate, endDate: _endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<RainData>>(
        future: _rainDataBuilder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            _chartData = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pick date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () => showDateTime(context, true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(210, 221, 238, 1)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        child: const Text(
                                          'Từ ngày',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  21, 101, 192, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(_startDate),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              DateFormat('hh:mm')
                                                  .format(_startTime),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: SvgPicture.asset(
                                        'assets/icons/calender.svg',
                                        height: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () => showDateTime(context, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(210, 221, 238, 1)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005),
                                        child: const Text(
                                          'Đến ngày',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  21, 101, 192, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(_endDate),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              DateFormat('hh:mm')
                                                  .format(_endTime),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: SvgPicture.asset(
                                        'assets/icons/calender.svg',
                                        height: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // devider
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 2,
                    width: MediaQuery.sizeOf(context).width * 1,
                    color: const Color.fromRGBO(236, 236, 236, 1),
                  ),

                  // drop down menu
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownMenu(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            selectedTrailingIcon: const Icon(Icons.expand_less),
                            trailingIcon: const Icon(Icons.expand_more),
                            menuStyle: MenuStyle(
                              maximumSize: const WidgetStatePropertyAll(
                                Size.fromHeight(150),
                              ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ),
                            initialSelection: _dataSelected.name,
                            onSelected: (value) {
                              setState(
                                () {
                                  _dataSelected = DataSelected.values
                                      .byName(value as String);
                                  _rainDataBuilder = fetchRainData(
                                      startDate: _startDate, endDate: _endDate);
                                },
                              );
                            },
                            dropdownMenuEntries: DataSelected.values
                                .map(
                                  (e) => DropdownMenuEntry(
                                      value: e.name, label: e.label),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Draw chart
                  SfCartesianChart(
                    margin: const EdgeInsets.all(15),
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(
                        width: 1,
                        color: Colors.black,
                        size: 5,
                      ),
                      axisLine: AxisLine(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _zoomPanBehavior,
                    series: _getSeries(_chartData),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Chart corresponding data selected
  List<CartesianSeries<RainData, String>> _getSeries(List<RainData> data) {
    switch (_dataSelected) {
      case DataSelected.Hours:
        return _getHoursSeries(data);
      case DataSelected.Day:
        return _getDaySeries(data);
      case DataSelected.Month:
        return _getMonthSeries(data);
      case DataSelected.Year:
        return _getYearSeries(data);
      default:
        return [];
    }
  }

  List<CartesianSeries<RainData, String>> _getHoursSeries(List<RainData> data) {
    return [
      ColumnSeries<RainData, String>(
        dataSource: data,
        xValueMapper: (RainData rain, _) => rain.logTime,
        yValueMapper: (RainData rain, _) => rain.rainAmount,
        color: const Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }

  List<CartesianSeries<RainData, String>> _getDaySeries(List<RainData> data) {
    return [
      ColumnSeries<RainData, String>(
        dataSource: data,
        xValueMapper: (RainData rain, _) => rain.logTime,
        yValueMapper: (RainData rain, _) => rain.rainAmount,
        color: const Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }

  List<CartesianSeries<RainData, String>> _getMonthSeries(List<RainData> data) {
    return [
      ColumnSeries<RainData, String>(
        dataSource: data,
        xValueMapper: (RainData rain, _) => rain.logTime,
        yValueMapper: (RainData rain, _) => rain.rainAmount,
        color: const Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }

  List<CartesianSeries<RainData, String>> _getYearSeries(List<RainData> data) {
    return [
      ColumnSeries<RainData, String>(
        dataSource: data,
        xValueMapper: (RainData rain, _) => rain.logTime,
        yValueMapper: (RainData rain, _) => rain.rainAmount,
        color: const Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }
}

// Data class
class RainData {
  RainData(this.logTime, this.rainAmount);

  final String logTime;
  final double rainAmount;

  factory RainData.fromJson(Map<String, dynamic> json) => RainData(
        json["logTime"],
        (json["rain_mm_Tot"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'logTime': logTime,
        'rain_mm_Tot': rainAmount,
      };
}
