import 'dart:async';
import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/models/commonData_models.dart';
import 'package:Ageo_solutions/models/waterLevel_models.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

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
  String label(BuildContext context) {
    switch (this) {
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

class ApLucLoRongHyScreen extends StatefulWidget {
  const ApLucLoRongHyScreen({super.key});

  @override
  State<ApLucLoRongHyScreen> createState() => _ApLucLoRongHyScreenState();
}

class _ApLucLoRongHyScreenState extends State<ApLucLoRongHyScreen> {
  DataSelected _dataSelected = DataSelected.Hours;
  Future<List<CommonData>>? _commonBuilder;
  late List<CommonData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
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
    _tooltipBehavior = TooltipBehavior(enable: true, shouldAlwaysShow: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    _commonBuilder = fetchCommonData(startDate: _startDate, endDate: _endDate);
    super.initState();
  }

  Future<List<CommonData>> fetchCommonData(
      {required DateTime startDate, required DateTime endDate}) async {
    final apiClient = ApiClient();
    final Map<String, dynamic> response;

    switch (_dataSelected) {
      case DataSelected.Hours:
        response = await apiClient.getCommonDataByHours(startDate);
        break;
      case DataSelected.Day:
        response = await apiClient.getCommonDataByDay(startDate);
        break;
      case DataSelected.Month:
        response = await apiClient.getCommonDataByMonth(startDate);
        break;
      case DataSelected.Year:
        response = await apiClient.getCommonDataByYear(startDate);
        break;
      default:
        throw Exception('Invalid data selection');
    }

    if (response['success']) {
      List<CommonData> data = (response['data'] as List)
          .map((data) => CommonData.fromJson(data))
          .toList();

      // Filter data based on the date range
      return data.where((rainData) {
        switch (_dataSelected) {
          case DataSelected.Hours:
            DateTime logTime =
                DateFormat('yy/MM/dd HH').parse(rainData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Day:
            DateTime logTime = DateFormat('yy/MM/dd').parse(rainData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Month:
            DateTime logTime = DateFormat('yy/MM').parse(rainData.logTime);
            return logTime.isAtSameMomentAs(startDate) ||
                logTime.isAfter(startDate) &&
                    logTime.isAtSameMomentAs(endDate) ||
                logTime.isBefore(endDate);

          case DataSelected.Year:
            DateTime logTime = DateFormat('yyyy').parse(rainData.logTime);
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
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color.fromRGBO(237, 146, 39, 1),
          onPrimary: Colors.black,
          surface: Theme.of(context).colorScheme.primary,
          onSurface:
              Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ),
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
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
        // Fetch and filter data based on the new date range
        _commonBuilder =
            fetchCommonData(startDate: _startDate, endDate: _endDate);
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
              child: FutureBuilder<List<CommonData>>(
                future: _commonBuilder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    _chartData = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 15, bottom: 20),
                            child: Expanded(
                              // drop down menu
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
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                trailingIcon: Icon(
                                  Icons.expand_more,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                menuStyle: MenuStyle(
                                  maximumSize: const WidgetStatePropertyAll(
                                    Size.fromHeight(160),
                                  ),
                                  surfaceTintColor:
                                      const WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  fillColor:
                                      Theme.of(context).colorScheme.primary,
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
                                initialSelection: _dataSelected.label(context),
                                onSelected: (value) {
                                  setState(() {
                                    _dataSelected = DataSelected.values
                                        .firstWhere((e) =>
                                            e.label(context) ==
                                            value as String);

                                    _commonBuilder = fetchCommonData(
                                      startDate: _startDate,
                                      endDate: _endDate,
                                    );
                                  });
                                },
                                dropdownMenuEntries: DataSelected.values
                                    .map(
                                      (e) => DropdownMenuEntry(
                                        value: e.label(context),
                                        labelWidget: Padding(
                                          padding: const EdgeInsets.all(0),
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

                          // draw chart
                          Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 15, top: 30),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 1000,
                                    child: SfCartesianChart(
                                      plotAreaBorderWidth: 0,
                                      margin: const EdgeInsets.all(15),
                                      enableAxisAnimation: true,
                                      primaryXAxis: CategoryAxis(
                                        labelStyle: const TextStyle(
                                          color: Color(0xFFA7ABC3),
                                        ),
                                        majorGridLines:
                                            const MajorGridLines(width: 0),
                                        majorTickLines: const MajorTickLines(
                                            width: 1,
                                            color: Color(0xFFA7ABC3),
                                            size: 5),
                                        isVisible: true,
                                        axisLine: const AxisLine(
                                          color: Color(0xFFA7ABC3),
                                          width: 1,
                                        ),
                                        title: AxisTitle(
                                          text:
                                              LocalData.time.getString(context),
                                          textStyle: const TextStyle(
                                            color: Color(0xFFA7ABC3),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      primaryYAxis: const NumericAxis(
                                          majorGridLines: MajorGridLines(
                                            width: 1,
                                            dashArray: [8, 8],
                                            color: Color(0xFFA7ABC3),
                                          ),
                                          majorTickLines: MajorTickLines(
                                            width: 0,
                                          ),
                                          axisLine: AxisLine(
                                            color: Colors.transparent,
                                          ),
                                          title: AxisTitle(
                                            text: "P (kg/cm²)",
                                            textStyle: TextStyle(
                                              color: Color(0xFFA7ABC3),
                                              fontSize: 12,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Color(0xFFA7ABC3),
                                          ),
                                          rangePadding:
                                              ChartRangePadding.additional),
                                      series: _getSeries(_chartData),
                                      tooltipBehavior: TooltipBehavior(
                                        enable: true,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderColor: Color(0xFFA7ABC3),
                                        textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                      zoomPanBehavior: _zoomPanBehavior,
                                    ),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20),
                                scrollDirection: Axis.horizontal,
                                child: _buildCustomLegend(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
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

  Widget _buildCustomLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          'D39-PZ-1',
          const Color.fromRGBO(84, 112, 198, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'D39-PZ-2',
          const Color.fromRGBO(145, 204, 117, 1),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  List<CartesianSeries<CommonData, String>> _getSeries(List<CommonData> data) {
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

  List<CartesianSeries<CommonData, String>> _getHoursSeries(
      List<CommonData> data) {
    return [
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v2,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(84, 112, 198, 1),
          name: 'D39-PZ-1'),
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v3,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(145, 204, 117, 1),
          name: 'D39-PZ-2'),
    ];
  }

  List<CartesianSeries<CommonData, String>> _getDaySeries(
      List<CommonData> data) {
    return [
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v2,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(84, 112, 198, 1),
          name: 'D39-PZ-1'),
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v3,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(145, 204, 117, 1),
          name: 'D39-PZ-2'),
    ];
  }

  List<CartesianSeries<CommonData, String>> _getMonthSeries(
      List<CommonData> data) {
    return [
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v2,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(84, 112, 198, 1),
          name: 'D39-PZ-1'),
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v3,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(145, 204, 117, 1),
          name: 'D39-PZ-2'),
    ];
  }

  List<CartesianSeries<CommonData, String>> _getYearSeries(
      List<CommonData> data) {
    return [
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v2,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(84, 112, 198, 1),
          name: 'D39-PZ-1'),
      LineSeries<CommonData, String>(
          dataSource: data,
          xValueMapper: (CommonData data, _) => data.logTime,
          yValueMapper: (CommonData data, _) => data.v3,
          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.circle,
          //   height: 5,
          //   width: 5,
          // ),
          color: const Color.fromRGBO(145, 204, 117, 1),
          name: 'D39-PZ-2'),
    ];
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
}
