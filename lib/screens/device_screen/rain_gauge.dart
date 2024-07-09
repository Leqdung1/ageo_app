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

class RaingaugeScreen extends StatefulWidget {
  const RaingaugeScreen({super.key});

  @override
  State<RaingaugeScreen> createState() => _RaingaugeScreenState();
}

class _RaingaugeScreenState extends State<RaingaugeScreen> {
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
            ],
          ),
        ],
      ),
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
      ColumnSeries<Data, String>(
        dataSource: [
          Data('00:00', 2),
          Data('01:00', 10),
          Data('02:00', 8),
          Data('03:00', 18),
          Data('04:00', 25),
          Data('05:00', 25),
          Data('06:00', 35),
          Data('07:00', 38),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        color: Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getMonthSeries() {
    return [
      ColumnSeries<Data, String>(
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
        color: Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }

  List<CartesianSeries<Data, String>> _getYearSeries() {
    return [
      ColumnSeries<Data, String>(
        dataSource: [
          Data('2020', 300),
          Data('2021', 400),
          Data('2022', 350),
          Data('2023', 450),
          Data('2024', 500),
        ],
        xValueMapper: (Data data, _) => data.day,
        yValueMapper: (Data data, _) => data.amount,
        color: Color.fromRGBO(21, 101, 192, 1),
      ),
    ];
  }
}

class Data {
  Data(this.day, this.amount);
  final String day;
  final int amount;
}
