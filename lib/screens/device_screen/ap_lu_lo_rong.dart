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
  DataSelected _dataSelected = DataSelected.Day;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                maximumSize: const WidgetStatePropertyAll(Size.fromHeight(150)),
                surfaceTintColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 255, 255, 255)),
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
                  // scrollDirection: Axis.horizontal,
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
                    series: _getSeries(),
                    tooltipBehavior: _tooltipBehavior,
                  ),
                ),
              ),
              _buildCustomLegend(),
            ],
          ),
        ],
      ),
    );
  }

  // style legend
  Widget _buildCustomLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('PZ 1-1', Colors.blue),
        const SizedBox(width: 20),
        _buildLegendItem('PZ 1-2', Colors.green),
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
          style: TextStyle(color: color),
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
          Data('00:00', 10),
          Data('01:00', 20),
          Data('02:00', 30),
          Data('03:00', 40),
          Data('04:00', 50),
          Data('05:00', 60),
          Data('06:00', 70),
          Data('07:00', 80),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: Colors.blue,
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('00:00', 5),
          Data('01:00', 10),
          Data('02:00', 15),
          Data('03:00', 20),
          Data('04:00', 25),
          Data('05:00', 30),
          Data('06:00', 35),
          Data('07:00', 40),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: Colors.green,
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getMonthSeries() {
    return [
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('Jan', 35),
          Data('Feb', 28),
          Data('Mar', 34),
          Data('Apr', 32),
          Data('May', 40),
          Data('Jun', 50),
          Data('Jul', 60),
          Data('Aug', 70),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: Colors.blue,
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('Jan', 20),
          Data('Feb', 24),
          Data('Mar', 27),
          Data('Apr', 30),
          Data('May', 35),
          Data('Jun', 40),
          Data('Jul', 45),
          Data('Aug', 50),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: Colors.green,
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getYearSeries() {
    return [
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('2020', 300),
          Data('2021', 400),
          Data('2022', 350),
          Data('2023', 450),
          Data('2024', 500),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-1',
        color: Colors.blue,
      ),
      StackedLineSeries<Data, String>(
        dataSource: [
          Data('2020', 250),
          Data('2021', 300),
          Data('2022', 320),
          Data('2023', 400),
          Data('2024', 450),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
        ),
        name: 'PZ 1-2',
        color: Colors.green,
      ),
    ];
  }
}

class Data {
  Data(this.day, this.amount);
  final String day;
  final int amount;
}
