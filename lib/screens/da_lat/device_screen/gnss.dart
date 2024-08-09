import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
    _piezmometerBuilder = fetchGnss(startDate: _startDate, endDate: _endDate);
    super.initState();
  }

  Future<List<GnssData>> fetchGnss(
      {required DateTime startDate, required DateTime endDate}) async {
    final apiClient = ApiClient();
    final Map<String, dynamic> response;

    switch (_dataSelected) {
      case DataSelected.Hours:
        response = await apiClient.getGnssByHours('yy/MM/dd HH');
        break;
      case DataSelected.Day:
        response = await apiClient.getGnssByDay('yy/MM/dd');
        break;
      case DataSelected.Month:
        response = await apiClient.getGnssByMonth('yy/MM');
        break;
      case DataSelected.Year:
        response = await apiClient.getGnssByYear('yyyy');
    }

    if (response['success']) {
      List<GnssData> data = (response['data'] as List)
          .map((data) => GnssData.fromJson(data))
          .toList();

      // Filter data based on the date range
      return data.where((gnssData) {
        switch (_dataSelected) {
          case DataSelected.Hours:
            DateTime logTime =
                DateFormat('yy/MM/dd HH').parse(gnssData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Day:
            DateTime logTime = DateFormat('yy/MM/dd').parse(gnssData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Month:
            DateTime logTime = DateFormat('yy/MM').parse(gnssData.logTime);
            return logTime.isAfter(startDate) && logTime.isBefore(endDate);

          case DataSelected.Year:
            DateTime logTime = DateFormat('yyyy').parse(gnssData.logTime);
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
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(21, 101, 192, 1),
          onPrimary: Colors.white,
          surface: Colors.white,
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
        _piezmometerBuilder =
            fetchGnss(startDate: _startDate, endDate: _endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _piezmometerBuilder,
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
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => showDateTime(context, true),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SvgPicture.asset(
                                      'assets/icons/calender.svg',
                                      height: 20),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.008),
                                        child: Text(
                                          LocalData.fromDate.getString(context),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  21, 101, 192, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(_startDate),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateFormat('hh:mm')
                                                  .format(_startTime),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 2,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => showDateTime(context, false),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SvgPicture.asset(
                                      'assets/icons/calender.svg',
                                      height: 20),
                                ),
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
                                        child: Text(
                                          LocalData.toDate.getString(context),
                                          style: const TextStyle(
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
                                            Expanded(
                                              child: Text(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(_endDate),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.color,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateFormat('hh:mm')
                                                  .format(_endTime),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // drop down menu
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 15, bottom: 20),
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

                                    _piezmometerBuilder = fetchGnss(
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
                                      primaryXAxis: const CategoryAxis(
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        majorGridLines:
                                            MajorGridLines(width: 0),
                                        majorTickLines: MajorTickLines(
                                          width: 1,
                                          color: Colors.grey,
                                          size: 5,
                                        ),
                                        isVisible: true,
                                        axisLine: AxisLine(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        majorGridLines: MajorGridLines(
                                          width: 1,
                                          dashArray: [8, 8],
                                          color: Colors.grey,
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        majorTickLines: MajorTickLines(
                                          width: 0,
                                        ),
                                        axisLine: AxisLine(
                                          color: Colors.transparent,
                                          width: 0,
                                        ),
                                      ),
                                      series: _getSeries(_chartData),
                                      tooltipBehavior: _tooltipBehavior,
                                      zoomPanBehavior: _zoomPanBehavior,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<CartesianSeries<GnssData, String>> _getSeries(List<GnssData> data) {
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

  List<CartesianSeries<GnssData, String>> _getHoursSeries(List<GnssData> data) {
    return [
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dX,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'X',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dY,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Y',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dZ,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Z',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
    ];
  }

  List<CartesianSeries<GnssData, String>> _getDaySeries(List<GnssData> data) {
    return [
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dX,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'X',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dY,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Y',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dZ,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Z',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
    ];
  }

  List<CartesianSeries<GnssData, String>> _getMonthSeries(List<GnssData> data) {
    return [
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dX,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'X',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dY,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Y',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dZ,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Z',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
    ];
  }

  List<CartesianSeries<GnssData, String>> _getYearSeries(List<GnssData> data) {
    return [
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dX,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'X',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dY,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Y',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<GnssData, String>(
        dataSource: data,
        xValueMapper: (GnssData data, _) => data.logTime,
        yValueMapper: (GnssData data, _) => data.dZ,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'Z',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
    ];
  }
}

// Data class
class GnssData {
  GnssData(this.logTime, this.dX, this.dY, this.dZ);
  final String logTime;
  final double dX;
  final double dY;
  final double dZ;

  factory GnssData.fromJson(Map<String, dynamic> json) => GnssData(
        json["logTime"],
        (json["dX"] ?? 0.0).toDouble(),
        (json["dY"] ?? 0.0).toDouble(),
        (json["dZ"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "logTime": logTime,
        "dX": dX,
        "dY": dY,
        "dZ": dZ,
      };
}
