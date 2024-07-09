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

class WaterLevelScreen extends StatefulWidget {
  const WaterLevelScreen({super.key});

  @override
  State<WaterLevelScreen> createState() => _WaterLevelScreenState();
}

class _WaterLevelScreenState extends State<WaterLevelScreen> {
  DataSelected _dataSelected = DataSelected.Day;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, shouldAlwaysShow: true);
    _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  _dataSelected = DataSelected.values.byName(value as String);
                });
              },
              dropdownMenuEntries: DataSelected.values
                  .map(
                    (e) => DropdownMenuEntry(value: e.name, label: e.label),
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
                      zoomPanBehavior: _zoomPanBehavior,
                      primaryXAxis: const CategoryAxis(
                        majorGridLines: MajorGridLines(width: 0),
                        isVisible: true,
                        axisLine: AxisLine(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 1.484,
                        maximum: 1.48723,
                        interval: 0.001,
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      series: _getSeries(),
                      tooltipBehavior: _tooltipBehavior,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                scrollDirection: Axis.horizontal,
                child: _buildCustomLegend(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomLegend() {
    // Add actual values to the legend
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          'W2 (Cao độ miệng 1484.24mm)',
          const Color.fromRGBO(84, 112, 198, 1),
        ),
        const SizedBox(width: 20),
        _buildLegendItem(
          'W2 (Cao độ miệng 1487.23mm)',
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
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  List<CartesianSeries<Data, String>> _getSeries() {
    switch (_dataSelected) {
      case DataSelected.Hours:
        return _getHoursSeries();
      case DataSelected.Month:
        return _getMonthSeries();
      case DataSelected.Year:
        return _getYearSeries();
      default:
        return [];
    }
  }

  List<CartesianSeries<Data, String>> _getHoursSeries() {
    return [
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('00:00', 1.48723),
          Data('01:00', 1.48690),
          Data('02:00', 1.48710),
          Data('03:00', 1.48730),
          Data('04:00', 1.48750),
          Data('05:00', 1.48770),
          Data('06:00', 1.48780),
          Data('07:00', 1.48800),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('00:00', 1.48723),
          Data('01:00', 1.48723),
          Data('02:00', 1.48723),
          Data('03:00', 1.48723),
          Data('04:00', 1.48723),
          Data('05:00', 1.48723),
          Data('06:00', 1.48723),
          Data('07:00', 1.48723),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getMonthSeries() {
    return [
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('Jan', 1.48723),
          Data('Feb', 1.48710),
          Data('Mar', 1.48700),
          Data('Apr', 1.48680),
          Data('May', 1.48690),
          Data('Jun', 1.48700),
          Data('Jul', 1.48720),
          Data('Aug', 1.48730),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('Jan', 1.48723),
          Data('Feb', 1.48723),
          Data('Mar', 1.48723),
          Data('Apr', 1.48723),
          Data('May', 1.48723),
          Data('Jun', 1.48723),
          Data('Jul', 1.48723),
          Data('Aug', 1.48723),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getYearSeries() {
    return [
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('2020', 1.4873),
          Data('2021', 1.48690),
          Data('2022', 1.48710),
          Data('2023', 1.48730),
          Data('2024', 1.48750),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(84, 112, 198, 1),
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('2020', 1.48723),
          Data('2021', 1.48723),
          Data('2022', 1.48723),
          Data('2023', 1.48723),
          Data('2024', 1.48723),
        ],
        xValueMapper: (Data data, _) => data.time,
        yValueMapper: (Data data, _) => data.level.toDouble(),
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        color: const Color.fromRGBO(145, 204, 117, 1),
      ),
    ];
  }
}

class Data {
  Data(this.time, this.level);
  final String time;
  final double level;
}
