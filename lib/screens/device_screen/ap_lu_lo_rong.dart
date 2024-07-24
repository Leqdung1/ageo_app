import 'package:Ageo_solutions/core/api_client.dart';
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

class ApLucLoRongScreen extends StatefulWidget {
  const ApLucLoRongScreen({super.key});

  @override
  State<ApLucLoRongScreen> createState() => _ApLucLoRongScreenState();
}

class _ApLucLoRongScreenState extends State<ApLucLoRongScreen> {
  DataSelected _dataSelected = DataSelected.Hours;
  late List<PiezometerData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  Future<List<PiezometerData>>? _piezmometerBuilder;
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
    _piezmometerBuilder =
        fetchPiezometer(startDate: _startDate, endDate: _endDate);
    super.initState();
  }

  Future<List<PiezometerData>> fetchPiezometer(
      {required DateTime startDate, required DateTime endDate}) async {
    final apiClient = ApiClient();
    final Map<String, dynamic> response;

    switch (_dataSelected) {
      case DataSelected.Hours:
        response = await apiClient.getPiezometerbyHours('yy/MM/dd HH');
        break;
      case DataSelected.Day:
        response = await apiClient.getPiezometerbyDay('yy/MM/dd');
        break;
      case DataSelected.Month:
        response = await apiClient.getPiezometerbyMonth('yy/MM');
        break;
      case DataSelected.Year:
        response = await apiClient.getPiezometerbyYear('yyyy');
    }

    if (response['success']) {
      List<PiezometerData> data = (response['data'] as List)
          .map((data) => PiezometerData.fromJson(data))
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
        _piezmometerBuilder =
            fetchPiezometer(startDate: _startDate, endDate: _endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                          setState(() {
                            _dataSelected =
                                DataSelected.values.byName(value as String);
                            _piezmometerBuilder = fetchPiezometer(
                                startDate: _startDate, endDate: _endDate);
                          });
                        },
                        dropdownMenuEntries: DataSelected.values
                            .map(
                              (e) => DropdownMenuEntry(
                                  value: e.name, label: e.label),
                            )
                            .toList(),
                      ),
                    ),

                    // draw chart
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 30),
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
                                  majorGridLines: MajorGridLines(width: 0),
                                  majorTickLines: MajorTickLines(
                                    width: 1,
                                    color: Colors.black,
                                    size: 5,
                                  ),
                                  isVisible: true,
                                  axisLine: AxisLine(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                  primaryYAxis: const NumericAxis(
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
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          scrollDirection: Axis.horizontal,
                          child: _buildCustomLegend(),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.3,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
          ),
    );
  }

  Widget _buildCustomLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          'PZ 1-1',
          const Color.fromRGBO(84, 112, 198, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'PZ 1-2',
          const Color.fromRGBO(145, 204, 117, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'PZ 2-1',
          const Color.fromRGBO(250, 200, 88, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'PZ 2-2',
          const Color.fromRGBO(238, 102, 102, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'PZ 3-1',
          const Color.fromRGBO(115, 192, 222, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'PZ 3-2',
          const Color.fromRGBO(59, 162, 114, 1),
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
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  List<CartesianSeries<PiezometerData, String>> _getSeries(
      List<PiezometerData> data) {
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

  List<CartesianSeries<PiezometerData, String>> _getHoursSeries(
      List<PiezometerData> data) {
    return [
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz1,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz2,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz3,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-1',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz4,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-2',
        color: const Color.fromRGBO(238, 102, 102, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz5,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-1',
        color: const Color.fromRGBO(115, 192, 222, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz6,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-2',
        color: const Color.fromRGBO(59, 162, 114, 1),
      ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz7,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz8,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
    ];
  }

  List<CartesianSeries<PiezometerData, String>> _getDaySeries(
      List<PiezometerData> data) {
    return [
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz1,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz2,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz3,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-1',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz4,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-2',
        color: const Color.fromRGBO(238, 102, 102, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz5,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-1',
        color: const Color.fromRGBO(115, 192, 222, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz6,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-2',
        color: const Color.fromRGBO(59, 162, 114, 1),
      ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz7,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz8,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
    ];
  }

  List<CartesianSeries<PiezometerData, String>> _getMonthSeries(
      List<PiezometerData> data) {
    return [
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz1,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz2,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz3,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-1',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz4,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-2',
        color: const Color.fromRGBO(238, 102, 102, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz5,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-1',
        color: const Color.fromRGBO(115, 192, 222, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz6,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-2',
        color: const Color.fromRGBO(59, 162, 114, 1),
      ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz7,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz8,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
    ];
  }

  List<CartesianSeries<PiezometerData, String>> _getYearSeries(
      List<PiezometerData> data) {
    return [
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz1,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz2,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz3,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-1',
        color: const Color.fromRGBO(250, 200, 88, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz4,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 2-2',
        color: const Color.fromRGBO(238, 102, 102, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz5,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-1',
        color: const Color.fromRGBO(115, 192, 222, 1),
      ),
      LineSeries<PiezometerData, String>(
        dataSource: data,
        xValueMapper: (PiezometerData data, _) => data.logTime,
        yValueMapper: (PiezometerData data, _) => data.pz6,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 3-2',
        color: const Color.fromRGBO(59, 162, 114, 1),
      ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz7,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
      //  LineSeries<PiezometerData, String>(
      //   dataSource: data,
      //   xValueMapper: (PiezometerData data, _) => data.logTime,
      //   yValueMapper: (PiezometerData data, _) => data.pz8,
      //   markerSettings: const MarkerSettings(
      //     isVisible: true,
      //     shape: DataMarkerType.circle,
      //   ),
      // ),
    ];
  }
}

// Data class
class PiezometerData {
  PiezometerData(this.logTime, this.pz1, this.pz2, this.pz3, this.pz4, this.pz5,
      this.pz6, this.pz7, this.pz8);
  final String logTime;
  final double pz1;
  final double pz2;
  final double pz3;
  final double pz4;
  final double pz5;
  final double pz6;
  final double pz7;
  final double pz8;

  factory PiezometerData.fromJson(Map<String, dynamic> json) => PiezometerData(
        json["logTime"],
        json["pz1"],
        json["pz2"],
        json["pz3"],
        json["pz4"],
        json["pz5"],
        json["pz6"],
        json["pz7"],
        json["pz8"],
      );

  Map<String, dynamic> toJson() => {
        "logTime": logTime,
        "pz1": pz1,
        "pz2": pz2,
        "pz3": pz3,
        "pz4": pz4,
        "pz5": pz5,
        "pz6": pz6,
        "pz7": pz7,
        "pz8": pz8,
      };
}
