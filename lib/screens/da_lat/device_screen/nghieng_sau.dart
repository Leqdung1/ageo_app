// import 'package:Ageo_solutions/core/api_client.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// enum DataSelected {
//   Hours,
//   Day,
//   Month,
//   Year,
// }

// enum IcSelected {
//   IC1,
//   IC2,
//   IC3,
// }

// extension DataSelectedExtension on DataSelected {
//   String get label {
//     switch (this) {
//       case DataSelected.Hours:
//         return 'Hours';
//       case DataSelected.Day:
//         return 'Day';
//       case DataSelected.Month:
//         return 'Month';
//       case DataSelected.Year:
//         return 'Year';
//       default:
//         return '';
//     }
//   }
// }

// extension IcSelectedExtension on IcSelected {
//   String get label {
//     switch (this) {
//       case IcSelected.IC1:
//         return 'IC1';
//       case IcSelected.IC2:
//         return 'IC2';
//       case IcSelected.IC3:
//         return 'IC3';
//     }
//   }
// }

// class nghiengSauScreen extends StatefulWidget {
//   const nghiengSauScreen({super.key});

//   @override
//   State<nghiengSauScreen> createState() => _nghiengSauScreenState();
// }

// // ignore: camel_case_types
// class _nghiengSauScreenState extends State<nghiengSauScreen> {
//   DataSelected _dataSelected = DataSelected.Day;
//   IcSelected _icSelected = IcSelected.IC1;
//   late TooltipBehavior _tooltipBehavior;
//   late ZoomPanBehavior _zoomPanBehavior;
//   Future<Map<String, dynamic>>? _piezometerData;

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
//    // _piezometerData = ApiClient().getPiezometerData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // data selected
//               Expanded(
//                 child: Container(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                   child: DropdownMenu(
//                     textStyle: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.normal,
//                     ),
//                     selectedTrailingIcon: const Icon(Icons.expand_less),
//                     trailingIcon: const Icon(Icons.expand_more),
//                     menuStyle: MenuStyle(
//                       maximumSize: const WidgetStatePropertyAll(
//                         Size.fromHeight(150),
//                       ),
//                       surfaceTintColor: const WidgetStatePropertyAll(
//                         Color.fromARGB(255, 255, 255, 255),
//                       ),
//                       shape: WidgetStatePropertyAll(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     inputDecorationTheme: InputDecorationTheme(
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 0,
//                         horizontal: 10,
//                       ),
//                       fillColor: const Color.fromARGB(255, 255, 255, 255),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(
//                           color: Colors.lightBlueAccent,
//                         ),
//                       ),
//                     ),
//                     initialSelection: _dataSelected.name,
//                     onSelected: (value) {
//                       setState(() {
//                         _dataSelected =
//                             DataSelected.values.byName(value as String);
//                       });
//                     },
//                     dropdownMenuEntries: DataSelected.values
//                         .map(
//                           (e) =>
//                               DropdownMenuEntry(value: e.name, label: e.label),
//                         )
//                         .toList(),
//                   ),
//                 ),
//               ),

//               // IC selected

//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                 child: DropdownMenu(
//                   textStyle: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   selectedTrailingIcon: const Icon(Icons.expand_less),
//                   trailingIcon: const Icon(Icons.expand_more),
//                   menuStyle: MenuStyle(
//                     surfaceTintColor: const WidgetStatePropertyAll(
//                       Color.fromARGB(255, 255, 255, 255),
//                     ),
//                     shape: WidgetStatePropertyAll(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   inputDecorationTheme: InputDecorationTheme(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 0,
//                       horizontal: 10,
//                     ),
//                     fillColor: const Color.fromARGB(255, 255, 255, 255),
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                         color: Colors.lightBlueAccent,
//                       ),
//                     ),
//                   ),
//                   initialSelection: _icSelected.name,
//                   onSelected: (value) {
//                     setState(() {
//                       _icSelected = IcSelected.values.byName(value as String);
//                     });
//                   },
//                   dropdownMenuEntries: IcSelected.values
//                       .map(
//                         (e) => DropdownMenuEntry(value: e.name, label: e.label),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),

//           // draw chart
//           Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 15, top: 30),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     width: 1000,
//                     child: FutureBuilder<Map<String, dynamic>>(
//                       future: _piezometerData,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return const Center(
//                               child: Text('Error fetching data'));
//                         } else if (!snapshot.hasData ||
//                             snapshot.data!.isEmpty) {
//                           return const Center(child: Text('No data available'));
//                         } else {
//                           final data = (snapshot.data!['data'] as List)
//                               .map((e) => PiezometerData.fromJson(e))
//                               .toList();
//                           return SfCartesianChart(
//                             zoomPanBehavior: _zoomPanBehavior,
//                             primaryXAxis: const CategoryAxis(
//                               majorGridLines: MajorGridLines(width: 0),
//                               isVisible: true,
//                               axisLine: AxisLine(
//                                 color: Colors.black,
//                                 width: 1,
//                               ),
//                             ),
//                             series: _getSeries(data),
//                             tooltipBehavior: _tooltipBehavior,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SingleChildScrollView(
//                 padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
//                 scrollDirection: Axis.horizontal,
//                 child: _buildCustomLegend(),
//               ),
//               SizedBox(
//                 height: MediaQuery.sizeOf(context).height * 0.3,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildLegendItem(
//           'PZ 1-1',
//           const Color.fromRGBO(84, 112, 198, 1),
//         ),
//         const SizedBox(width: 20),
//         _buildLegendItem(
//           'PZ 1-2',
//           const Color.fromRGBO(145, 204, 117, 1),
//         ),
//         const SizedBox(width: 20),
//         _buildLegendItem(
//           'PZ 2-1',
//           const Color.fromRGBO(250, 200, 88, 1),
//         ),
//         const SizedBox(width: 20),
//         _buildLegendItem(
//           'PZ 2-2',
//           const Color.fromRGBO(238, 102, 102, 1),
//         ),
//         const SizedBox(width: 20),
//         _buildLegendItem(
//           'PZ 3-1',
//           const Color.fromRGBO(115, 192, 222, 1),
//         ),
//         const SizedBox(width: 20),
//         _buildLegendItem(
//           'PZ 3-2',
//           const Color.fromRGBO(59, 162, 114, 1),
//         ),
//       ],
//     );
//   }

//   Widget _buildLegendItem(String text, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 5),
//         Text(
//           text,
//           style: const TextStyle(color: Colors.black),
//         ),
//       ],
//     );
//   }

//   List<CartesianSeries<Data, String>> _getSeries(List<PiezometerData> data) {
//     switch (_dataSelected) {
//       case DataSelected.Hours:
//         return _getHoursSeries(data);
//       case DataSelected.Month:
//         return _getMonthSeries();
//       case DataSelected.Year:
//         return _getYearSeries();
//       default:
//         return [];
//     }
//   }

//   List<CartesianSeries<Data, String>> _getHoursSeries(
//       List<PiezometerData> data) {
//     return [
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC1', 0),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 1-1',
//         color: const Color.fromRGBO(84, 112, 198, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC1', 1),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 1-2',
//         color: const Color.fromRGBO(145, 204, 117, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC2', 0),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 2-1',
//         color: const Color.fromRGBO(250, 200, 88, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC2', 1),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 2-2',
//         color: const Color.fromRGBO(238, 102, 102, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC3', 0),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 3-1',
//         color: const Color.fromRGBO(115, 192, 222, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForHour(data, _icSelected.label, 'IC3', 1),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 3-2',
//         color: const Color.fromRGBO(59, 162, 114, 1),
//       ),
//     ];
//   }

//   List<Data> _getDataSourceForHour(List<PiezometerData> data, String selectedIC,
//       String compareIC, int hourIndex) {
//     final filteredData = data.where((e) => e.id == selectedIC).toList();
//     if (filteredData.isEmpty) {
//       return [];
//     }
//     return [
//       Data(time: '7:00', amount: filteredData[0].ic1Data[hourIndex].value),
//       Data(time: '8:00', amount: filteredData[0].ic2Data[hourIndex].value),
//       Data(time: '9:00', amount: filteredData[0].ic3Data[hourIndex].value),
//       Data(time: '10:00', amount: filteredData[0].ic4Data[hourIndex].value),
//     ];
//   }

//   List<CartesianSeries<Data, String>> _getMonthSeries() {
//     return [
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForMonth(_icSelected.label, 'IC1'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 1-1',
//         color: const Color.fromRGBO(84, 112, 198, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForMonth(_icSelected.label, 'IC2'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 2-1',
//         color: const Color.fromRGBO(145, 204, 117, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForMonth(_icSelected.label, 'IC3'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 3-1',
//         color: const Color.fromRGBO(250, 200, 88, 1),
//       ),
//     ];
//   }

//   List<Data> _getDataSourceForMonth(String selectedIC, String compareIC) {
//     // Adjust the implementation based on your data structure and requirements
//     return [
//       Data(time: 'Week 1', amount: 10),
//       Data(time: 'Week 2', amount: 15),
//       Data(time: 'Week 3', amount: 25),
//       Data(time: 'Week 4', amount: 20),
//     ];
//   }

//   List<CartesianSeries<Data, String>> _getYearSeries() {
//     return [
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForYear(_icSelected.label, 'IC1'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 1-1',
//         color: const Color.fromRGBO(84, 112, 198, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForYear(_icSelected.label, 'IC2'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 2-1',
//         color: const Color.fromRGBO(145, 204, 117, 1),
//       ),
//       LineSeries<Data, String>(
//         dataSource: _getDataSourceForYear(_icSelected.label, 'IC3'),
//         xValueMapper: (Data data, _) => data.time,
//         yValueMapper: (Data data, _) => data.amount,
//         name: 'PZ 3-1',
//         color: const Color.fromRGBO(250, 200, 88, 1),
//       ),
//     ];
//   }

//   List<Data> _getDataSourceForYear(String selectedIC, String compareIC) {
//     // Adjust the implementation based on your data structure and requirements
//     return [
//       Data(time: 'Jan', amount: 10),
//       Data(time: 'Feb', amount: 15),
//       Data(time: 'Mar', amount: 25),
//       Data(time: 'Apr', amount: 20),
//       Data(time: 'May', amount: 10),
//       Data(time: 'Jun', amount: 15),
//       Data(time: 'Jul', amount: 25),
//       Data(time: 'Aug', amount: 20),
//       Data(time: 'Sep', amount: 10),
//       Data(time: 'Oct', amount: 15),
//       Data(time: 'Nov', amount: 25),
//       Data(time: 'Dec', amount: 20),
//     ];
//   }
// }

// class InclinometerData {
//   final String logTime;
//   final List<ICData> ic1Data;
//   final List<ICData> ic2Data;
//   final List<ICData> ic3Data;
//   final List<ICData> ic4Data;

//  InclinometerData({
//     required this.,
//     required this.ic1Data,
//     required this.ic2Data,
//     required this.ic3Data,
//     required this.ic4Data,
//   });

//   factory InclinometerData.fromJson(Map<String, dynamic> json) {
//     return InclinometerData(
//       id: json['id'],
//       ic1Data:
//           (json['ic1Data'] as List).map((e) => ICData.fromJson(e)).toList(),
//       ic2Data:
//           (json['ic2Data'] as List).map((e) => ICData.fromJson(e)).toList(),
//       ic3Data:
//           (json['ic3Data'] as List).map((e) => ICData.fromJson(e)).toList(),
//       ic4Data:
//           (json['ic4Data'] as List).map((e) => ICData.fromJson(e)).toList(),
//     );
//   }
// }

// class ICData {
//   final String time;
//   final double value;

//   ICData({required this.time, required this.value});

//   factory ICData.fromJson(Map<String, dynamic> json) {
//     return ICData(
//       time: json['time'],
//       value: json['value'],
//     );
  
// }}
