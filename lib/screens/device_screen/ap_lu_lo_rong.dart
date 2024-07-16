import 'package:Ageo_solutions/core/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum DataSelected {
  Hours,
  Day,
  Month,
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

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    _piezmometerBuilder = fetchPiezometer();
    super.initState();
  }

  Future<List<PiezometerData>> fetchPiezometer() async {
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
      return (response['data'] as List)
          .map((data) => PiezometerData.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            _piezmometerBuilder = fetchPiezometer();
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
                                primaryXAxis: const CategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  isVisible: true,
                                  axisLine: AxisLine(
                                    color: Colors.black,
                                    width: 1,
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
          }),
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
