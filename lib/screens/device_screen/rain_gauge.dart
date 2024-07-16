import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:Ageo_solutions/core/api_client.dart';

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
  DataSelected _dataSelected = DataSelected.Hours;
  late List<RainData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  Future<List<RainData>>? _rainDataBuilder;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _rainDataBuilder = fetchRainData();
    super.initState();
  }

  Future<List<RainData>> fetchRainData() async {
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
      return (response['data'] as List)
          .map((data) => RainData.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
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
                        setState(
                          () {
                            _dataSelected =
                                DataSelected.values.byName(value as String);
                            _rainDataBuilder = fetchRainData();
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

                  // draw chart
                  SfCartesianChart(
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    tooltipBehavior: _tooltipBehavior,
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

  // chart corresponding data selected
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
