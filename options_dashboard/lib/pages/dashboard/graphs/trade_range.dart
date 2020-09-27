import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/strategy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TradeRangeChart extends StatelessWidget {
  TradeRangeChart({
    @required this.stockPrice,
    @required this.strategy,
    @required this.range,
  });

  final Strategy strategy;
  final double stockPrice;
  final List<double> range;
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _screenWidth / 2,
      width: _screenWidth,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency(),
            maximum: range[1],
            minimum: range[0],
            plotBands: [
              PlotBand(
                  isVisible: true,
                  start: strategy.customStockPrice,
                  end: strategy.customStockPrice,
                  borderWidth: 2,
                  borderColor: Colors.indigo),
              PlotBand(
                  isVisible: true,
                  start: stockPrice,
                  end: stockPrice,
                  borderWidth: 2,
                  color: Colors.grey),
            ]),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        tooltipBehavior: TooltipBehavior(decimalPlaces: 2, enable: true),
        series: <AreaSeries<ReturnData, double>>[
          AreaSeries<ReturnData, double>(
              name: '',
              borderWidth: 2,
              borderColor: Colors.red,
              dataSource: strategy.pdfData,
              xValueMapper: (ReturnData returnData, _) =>
                  returnData.x < range[2] ? returnData.x : null,
              yValueMapper: (ReturnData returnData, _) =>
                  returnData.x < range[2] ? returnData.value : null,
              color: Colors.red.withOpacity(0.3)),
          AreaSeries<ReturnData, double>(
              name: '',
              borderWidth: 2,
              borderColor: Colors.indigo,
              dataSource: strategy.pdfData,
              xValueMapper: (ReturnData returnData, _) =>
                  returnData.x > range[2] && returnData.x < stockPrice
                      ? returnData.x
                      : null,
              yValueMapper: (ReturnData returnData, _) =>
                  returnData.x > range[2] && returnData.x < stockPrice
                      ? returnData.value
                      : null,
              color: Colors.indigo.withOpacity(0.3)),
          AreaSeries<ReturnData, double>(
              name: '',
              borderWidth: 2,
              borderColor: Colors.indigo,
              dataSource: strategy.pdfData,
              xValueMapper: (ReturnData returnData, _) =>
                  returnData.x < range[3] && returnData.x > stockPrice
                      ? returnData.x
                      : null,
              yValueMapper: (ReturnData returnData, _) =>
                  returnData.x < range[3] && returnData.x > stockPrice
                      ? returnData.value
                      : null,
              color: Colors.indigo.withOpacity(0.3)),
          AreaSeries<ReturnData, double>(
              name: '',
              borderWidth: 2,
              borderColor: Colors.red,
              dataSource: strategy.pdfData,
              xValueMapper: (ReturnData returnData, _) =>
                  returnData.x > range[3] ? returnData.x : null,
              yValueMapper: (ReturnData returnData, _) =>
                  returnData.x > range[3] ? returnData.value : null,
              color: Colors.red.withOpacity(0.3)),
        ],
      ),
    );
  }
}

class PdfChart extends StatelessWidget {
  final Strategy strategy;
  PdfChart(this.strategy);

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    List<FlSpot> pdfData = [];
    strategy.pdfData.forEach((dataPoint) {
      pdfData.add(FlSpot(dataPoint.x, dataPoint.value));
      if (dataPoint.value > maxY) {
        maxY = dataPoint.value;
      }
    });
    maxY *= 1.05;

    final intervalY = maxY / 6;
    final maxX = strategy.pdfData.last.x;
    final minX = strategy.pdfData.first.x;
    final intervalX = (maxX - minX) / 6;

    final screeWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screeWidth / 2,
      width: screeWidth,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: false,
              interval: intervalY,
            ),
            bottomTitles: SideTitles(showTitles: true, interval: intervalX),
          ),
          gridData: FlGridData(show: false),
          clipData: FlClipData.all(),
          minX: pdfData.first.x,
          maxX: pdfData.last.x,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Colors.red[100],
                  Colors.green[100],
                ],
                gradientFrom: const Offset(0, 0),
                gradientTo: const Offset(1, 1),
              ),
              aboveBarData: BarAreaData(
                show: true,
                colors: [Colors.red[100]],
                cutOffY: 0,
                applyCutOffY: true,
              ),
              spots: pdfData,
              colors: [Theme.of(context).primaryColor],
              dotData: FlDotData(
                show: false,
              ),
            ),
          ])),
    );
  }
}
