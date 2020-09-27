// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:options_dashboard/functions/distribution.dart';
// import 'package:options_dashboard/services/optimize_trade.dart';

// buildTradeRangeChart(
//   context, {
//   @required double stockPrice,
//   @required double volatility,
//   @required List<double> range,
//   @required StrategyType outlook,
//   @required int expiryDate,
// }) {
//   print(range);
//   double _xValue;
//   List<FlSpot> tradeRange = [];
//   for (int i = 0; i < 100; i++) {
//     _xValue = range[0] + i * (range[1] - range[0]) / 100;
//     tradeRange.add(FlSpot(
//         _xValue,
//         normalDist(
//           distribution: 'lognorm',
//           stockPrice: stockPrice,
//           position: _xValue,
//           volatility: volatility,
//           outlook: outlook,
//           expiryDate: expiryDate,
//         )));
//   }

//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: MediaQuery.of(context).size.width / 2,
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: LineChart(
//       LineChartData(
//         minY: 0,
//         titlesData: FlTitlesData(
//           leftTitles: SideTitles(showTitles: false),
//           bottomTitles: SideTitles(
//             showTitles: true,
//             interval: (range[1] - range[0]) / 4.1,
//           ),
//         ),
//         lineBarsData: [
//           LineChartBarData(
//             colors: [Colors.indigo],
//             spots: tradeRange,
//             dotData: FlDotData(
//               show: false,
//             ),
//           ),
//         ],
//         extraLinesData: ExtraLinesData(verticalLines: [
//           VerticalLine(x: stockPrice, color: Colors.black26),
//         ], horizontalLines: [
//           HorizontalLine(y: 0, color: Colors.black26)
//         ]),
//         axisTitleData: FlAxisTitleData(
//           bottomTitle: AxisTitle(
//             titleText: 'Market Price',
//             textStyle: TextStyle(
//                 fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
//             showTitle: false,
//           ),
//           leftTitle: AxisTitle(
//             titleText: 'Pobability',
//             showTitle: false,
//           ),
//         ),
//       ),
//     ),
//   );
// }
