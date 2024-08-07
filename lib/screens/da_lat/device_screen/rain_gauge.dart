import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:Ageo_solutions/core/api_client.dart';
// ignore: depend_on_referenced_packages
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
        _rainDataBuilder =
            fetchRainData(startDate: _startDate, endDate: _endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsetsDirectional.symmetric(
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 15, bottom: 20),
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
                                initialSelection: _dataSelected.label,
                                onSelected: (value) {
                                  setState(() {
                                    _dataSelected = DataSelected.values
                                        .byName(value as String);
                                    _rainDataBuilder = fetchRainData(
                                      startDate: _startDate,
                                      endDate: _endDate,
                                    );
                                  });
                                },
                                dropdownMenuEntries: DataSelected.values
                                    .map(
                                      (e) => DropdownMenuEntry(
                                        value: e.label,
                                        labelWidget: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                            e.label,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                            ),
                                          ),
                                        ),
                                        label: e.label,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),

                          // Draw chart
                          SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            primaryXAxis: const CategoryAxis(
                              majorGridLines: MajorGridLines(
                                width: 0,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              rangePadding: ChartRangePadding.auto,
                              majorTickLines: MajorTickLines(
                                width: 1,
                                color: Colors.grey,
                                size: 5,
                              ),
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
                            tooltipBehavior: _tooltipBehavior,
                            zoomPanBehavior: _zoomPanBehavior,
                            series: _getSeries(_chartData),
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
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
