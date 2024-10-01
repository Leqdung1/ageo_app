import 'dart:async';

import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/models/gnss_models.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

enum DataSelected {
  RealTime,
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
  String label(BuildContext context) {
    switch (this) {
      case DataSelected.RealTime:
        return LocalData.realtime.getString(context);
      case DataSelected.Hours:
        return LocalData.hours.getString(context);
      case DataSelected.Day:
        return LocalData.day.getString(context);
      case DataSelected.Month:
        return LocalData.month.getString(context);
      case DataSelected.Year:
        return LocalData.year.getString(context);
      default:
        return '';
    }
  }
}

class GnssScreen extends StatefulWidget {
  const GnssScreen({super.key});

  @override
  State<GnssScreen> createState() => _GnssScreenState();
}

class _GnssScreenState extends State<GnssScreen> {
  DataSelected _dataSelected = DataSelected.Hours;
  late List<GnssData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  Future<List<GnssData>>? _piezmometerBuilder;
  int? selectedSegment = 1;
  DateTime _startDate = DateTime.now().subtract(
    const Duration(days: 7),
  );
  DateTime _endDate = DateTime.now();
  final DateTime _startTime = DateTime.now().subtract(
    const Duration(days: 7),
  );
  final DateTime _endTime = DateTime.now();
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    _piezmometerBuilder = fetchGnss(
      startDate: _startDate,
      endDate: _endDate,
      selectedSegment: selectedSegment!,
    );
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  // int? time;
  // void updateDataSource(Timer timer) {
  //   _chartData.add(
  //     GnssData(
  //       time++ as String,
  //     ),
  //   );
  //   _chartData.removeAt(0);
  //   _chartSeriesController.updateDataSource(
  //     addedDataIndex: _chartData.length -1,
  //     removedDataIndex: 0,
  //   );
  // }

  Future<List<GnssData>> fetchGnss({
    required DateTime startDate,
    required DateTime endDate,
    required int selectedSegment,
  }) async {
    final apiClient = ApiClient();
    final Map<String, dynamic> response;

    switch (_dataSelected) {
      case DataSelected.RealTime:
        if (selectedSegment == 1) {
          response = await apiClient.getGnssbyRealTime(startDate, "M1");
        } else if (selectedSegment == 2) {
          response = await apiClient.getGnssbyRealTime(startDate, "M2");
        } else if (selectedSegment == 3) {
          response = await apiClient.getGnssbyRealTime(startDate, "M3");
        } else {
          throw Exception('Invalid selectedSegment');
        }
        break;

      case DataSelected.Hours:
        if (selectedSegment == 1) {
          response = await apiClient.getGnssByHours(startDate, "M1");
        } else if (selectedSegment == 2) {
          response = await apiClient.getGnssByHours(startDate, "M2");
        } else if (selectedSegment == 3) {
          response = await apiClient.getGnssByHours(startDate, "M3");
        } else {
          throw Exception('Invalid selectedSegment');
        }
        break;

      case DataSelected.Day:
        if (selectedSegment == 1) {
          response = await apiClient.getGnssByDay(startDate, "M1");
        } else if (selectedSegment == 2) {
          response = await apiClient.getGnssByDay(startDate, "M2");
        } else if (selectedSegment == 3) {
          response = await apiClient.getGnssByDay(startDate, "M3");
        } else {
          throw Exception('Invalid selectedSegment');
        }
        break;

      case DataSelected.Month:
        if (selectedSegment == 1) {
          response = await apiClient.getGnssByMonth(startDate, "M1");
        } else if (selectedSegment == 2) {
          response = await apiClient.getGnssByMonth(startDate, "M2");
        } else if (selectedSegment == 3) {
          response = await apiClient.getGnssByMonth(startDate, "M3");
        } else {
          throw Exception('Invalid selectedSegment');
        }
        break;
      case DataSelected.Year:
        if (selectedSegment == 1) {
          response = await apiClient.getGnssByYear(startDate, "M1");
        } else if (selectedSegment == 2) {
          response = await apiClient.getGnssByYear(startDate, "M2");
        } else if (selectedSegment == 3) {
          response = await apiClient.getGnssByYear(startDate, "M3");
        } else {
          throw Exception('Invalid selectedSegment');
        }
        break;

      default:
        throw Exception('Invalid DataSelected');
    }

    if (response['success']) {
      List<GnssData> data = (response['data'] as List)
          .map((data) => GnssData.fromJson(data))
          .toList();

      // Filter data based on the date range
      return data.where((gnssData) {
        switch (_dataSelected) {
          case DataSelected.RealTime:
            DateTime logTime = DateFormat('HH:mm:ss').parse(gnssData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Hours:
            DateTime logTime =
                DateFormat('yy/MM/dd HH').parse(gnssData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Day:
            DateTime logTime = DateFormat('yy/MM/dd').parse(gnssData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Month:
            DateTime logTime = DateFormat('yy/MM').parse(gnssData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Year:
            DateTime logTime = DateFormat('yyyy').parse(gnssData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);
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
      initialDate: isStart ? _startDate : _endDate,
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
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color.fromRGBO(237, 146, 39, 1),
          onPrimary: Colors.black,
          surface: Theme.of(context).colorScheme.primary,
          onSurface:
              Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
        // Fetch and filter data based on the new date range
        _piezmometerBuilder = fetchGnss(
          startDate: _startDate,
          endDate: _endDate,
          selectedSegment: selectedSegment!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // pick date
            selectedDate(),

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     offset: const Offset(0, 1),
                //     blurRadius: 8,
                //   ),
                // ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Segment slide
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        child: CustomSlidingSegmentedControl<int>(
                          initialValue: selectedSegment,
                          children: {
                            1: Text(
                              'GNSS 01',
                              style: TextStyle(
                                fontWeight: selectedSegment == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selectedSegment == 1
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                              ),
                            ),
                            2: Text(
                              'GNSS 02',
                              style: TextStyle(
                                fontWeight: selectedSegment == 2
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selectedSegment == 2
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                              ),
                            ),
                            3: Text(
                              'GNSS 03',
                              style: TextStyle(
                                fontWeight: selectedSegment == 3
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selectedSegment == 3
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                              ),
                            ),
                          },
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          thumbDecoration: BoxDecoration(
                            color: Color.fromRGBO(237, 146, 39, 1),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                blurRadius: 4.0,
                                offset: const Offset(
                                  0.0,
                                  1.0,
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.linear,
                          onValueChanged: (v) {
                            setState(() {
                              selectedSegment = v;
                              _piezmometerBuilder = fetchGnss(
                                startDate: _startDate,
                                endDate: _endDate,
                                selectedSegment: selectedSegment!,
                              );
                              getGnssChart();
                            });
                          },
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: _piezmometerBuilder,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            _chartData = snapshot.data!;
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // drop down menu
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                      right: 15,
                                      bottom: 20,
                                    ),
                                    child: Expanded(
                                      child: DropdownMenu(
                                        textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        selectedTrailingIcon: Icon(
                                          Icons.expand_less,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        trailingIcon: Icon(
                                          Icons.expand_more,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        menuStyle: MenuStyle(
                                          maximumSize:
                                              const WidgetStatePropertyAll(
                                            Size.fromHeight(160),
                                          ),
                                          surfaceTintColor:
                                              const WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                          shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          filled: true,
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 0,
                                            ),
                                          ),
                                        ),
                                        initialSelection:
                                            _dataSelected.label(context),
                                        onSelected: (value) {
                                          setState(() {
                                            _dataSelected = DataSelected.values
                                                .firstWhere((e) =>
                                                    e.label(context) ==
                                                    value as String);

                                            _piezmometerBuilder = fetchGnss(
                                              startDate: _startDate,
                                              endDate: _endDate,
                                              selectedSegment: selectedSegment!,
                                            );
                                          });
                                        },
                                        dropdownMenuEntries: DataSelected.values
                                            .map(
                                              (e) => DropdownMenuEntry(
                                                value: e.label(context),
                                                labelWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
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
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),

                                  // Draw chart
                                  getGnssChart(),
                                ]);
                          }
                        })
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
            ),
          ],
        ),
      ),
    );
  }

  List<CartesianSeries<GnssData, String>> _getXSeries(List<GnssData> data) {
    debugPrint("Data for X: ${data.map((d) => d.dX).toList()}");

    return [
      _getLineSeries('X', data, (gnssData) => gnssData.dX * 1000),
    ];
  }

  List<CartesianSeries<GnssData, String>> _getYSeries(List<GnssData> data) {
    debugPrint("Data for Y: ${data.map((d) => d.dY).toList()}");
    return [
      _getLineSeries('Y', data, (gnssData) => gnssData.dY * 1000),
    ];
  }

  List<CartesianSeries<GnssData, String>> _getZSeries(List<GnssData> data) {
    debugPrint("Data for H: ${data.map((d) => d.dH).toList()}");
    return [
      _getLineSeries('H', data, (gnssData) => gnssData.dH * 1000),
    ];
  }

  LineSeries<GnssData, String> _getLineSeries(
    String name,
    List<GnssData> data,
    double Function(GnssData) yValueMapper,
  ) {
    return LineSeries<GnssData, String>(
      onRendererCreated: (ChartSeriesController controller) {
        _chartSeriesController = controller;
      },
      dataSource: data,
      xValueMapper: (GnssData data, _) => data.logTime,
      yValueMapper: (GnssData data, _) => yValueMapper(data),
      // markerSettings: const MarkerSettings(
      //   isVisible: true,
      //   shape: DataMarkerType.circle,
      //   height: 5,
      //   width: 5,
      // ),
      name: name,
      color: _getColorForName(name),
    );
  }

  Color _getColorForName(String name) {
    switch (name) {
      case 'X':
        return const Color.fromRGBO(84, 112, 198, 1);
      case 'Y':
        return const Color.fromRGBO(145, 204, 117, 1);
      case 'H':
        return const Color.fromRGBO(237, 146, 39, 1);
      default:
        return Colors.blue;
    }
  }

  Widget getGnssChart() {
    switch (selectedSegment) {
      case 1:
        return gnss01();
      case 2:
        return gnss02();
      case 3:
        return gnss03();
      default:
        return Container();
    }
  }

  // gnss 01
  Widget gnss01() {
    return Column(
      children: [
        // dX chart
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 30,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getXSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dY chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getYSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dH chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getZSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // gnss 02
  Widget gnss02() {
    return Column(
      children: [
        // dX chart
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 30,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getXSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dY chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getYSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dH chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getZSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // gnss03
  Widget gnss03() {
    return Column(
      children: [
        // dX chart
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 30,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getXSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dY chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getYSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dH chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getZSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectedDate() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text(
                    LocalData.fromDate.getString(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => showDateTime(context, true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromRGBO(225, 225, 225, 1),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: DateFormat('dd/MM/yyyy')
                                      .format(_startDate),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                TextSpan(
                                  text: " - ",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                TextSpan(
                                  text: DateFormat('hh:mm').format(_startTime),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      LocalData.toDate.getString(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => showDateTime(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromRGBO(225, 225, 225, 1),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: DateFormat('dd/MM/yyyy')
                                        .format(_endDate),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                  TextSpan(
                                    text: DateFormat('hh:mm').format(_endTime),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // RealTime
  Widget realtimeChart() {
    return Column(
      children: [
        // dX chart
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 30,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getXSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dY chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getYSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),

        // dH chart
        Container(
          margin: const EdgeInsets.only(left: 15, top: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(
                    width: 1,
                    color: Color(0xFFA7ABC3),
                    size: 5,
                  ),
                  isVisible: true,
                  axisLine: const AxisLine(
                    color: Color(0xFFA7ABC3),
                    width: 1,
                  ),
                  title: AxisTitle(
                    text: LocalData.time.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    width: 1,
                    dashArray: [8, 8],
                    color: Color(0xFFA7ABC3),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xFFA7ABC3),
                  ),
                  majorTickLines: const MajorTickLines(
                    width: 0,
                  ),
                  axisLine: const AxisLine(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  title: AxisTitle(
                    text: LocalData.displacment.getString(context),
                    textStyle: const TextStyle(
                      color: Color(0xFFA7ABC3),
                      fontSize: 12,
                    ),
                  ),
                ),
                series: _getZSeries(_chartData),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Theme.of(context).colorScheme.surface,
                  borderColor: Color(0xFFA7ABC3),
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                zoomPanBehavior: _zoomPanBehavior,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
