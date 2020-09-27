// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:options_dashboard/data/stock_history.dart';

// Container buildStockHistoryChart(
//   context, {
//   @required StockHistory stockHistory,
//   @required historyLength,
//   @required bool lookUp,
// }) {
//   List<FlSpot> historicalData = [];
//   List<FlSpot> volumeData = [];
//   for (int i = 0; i < stockHistory.close.length; i++) {
//     historicalData
//         .add(FlSpot(stockHistory.date[i].toDouble(), stockHistory.close[i]));
//     volumeData.add(FlSpot(stockHistory.date[i].toDouble(),
//         (stockHistory.volume[i] ?? 0).toDouble()));
//   }
//   double width = MediaQuery.of(context).size.width;

//   return lookUp
//       ? Container(
//           width: width,
//           height: width / 2,
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Container(
//               width: MediaQuery.of(context).size.width / 2,
//               child: CircularProgressIndicator()))
//       : stockHistory.error == true
//           ? Center(
//               child: Text('There was an error getting this data'),
//             )
//           : Container(
//               width: width,
//               height: width / 2,
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 children: [
//                   Container(
//                     height: width / 3,
//                     width: width,
//                     child: LineChart(
//                       LineChartData(
//                         gridData: FlGridData(show: false),
//                         clipData: FlClipData.all(),
//                         titlesData: FlTitlesData(
//                           leftTitles: SideTitles(showTitles: true),
//                           bottomTitles: SideTitles(
//                             showTitles: false,
//                           ),
//                         ),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: historicalData,
//                             dotData: FlDotData(
//                               show: false,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: width / 6,
//                     width: width,
//                     child: LineChart(LineChartData(lineBarsData: [
//                       LineChartBarData(
//                           spots: volumeData, dotData: FlDotData(show: false))
//                     ])),
//                   )
//                 ],
//               ),
//             );
// }
