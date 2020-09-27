import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/quote.dart';
import 'package:options_dashboard/models/strategy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ReturnChart extends StatelessWidget {
  ReturnChart({
    @required this.stockPrice,
    @required this.strategy,
  });
  final Strategy strategy;
  final double stockPrice;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _screenWidth / 2,
      width: _screenWidth,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
            numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            minimum: strategy.returnData.first.x,
            maximum: strategy.returnData.last.x,
            plotBands: <PlotBand>[
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
              ),
            ]),
        primaryYAxis: NumericAxis(
          name: 'return',
          numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
          isVisible: true,
        ),
        crosshairBehavior: CrosshairBehavior(
          enable: true,
        ),
        series: <CartesianSeries>[
          LineSeries<ReturnData, double>(
              name: '',
              yAxisName: 'return',
              color: Colors.red[800],
              dataSource: strategy.currentValueData,
              xValueMapper: (ReturnData returnData, _) => returnData.x,
              yValueMapper: (ReturnData returnData, _) => returnData.value),
          AreaSeries<ReturnData, double>(
              name: '',
              yAxisName: 'return',
              borderWidth: 2,
              borderColor: Colors.indigo,
              dataSource: strategy.returnData,
              xValueMapper: (ReturnData returnData, _) => returnData.x,
              yValueMapper: (ReturnData returnData, _) => returnData.value,
              color: Colors.indigo.withOpacity(0.3)),
        ],
      ),
    );
  }
}

class PayoffChart extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;
  PayoffChart(this.strategy, this.quote);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> payoffData = [];
    List<FlSpot> currentValueData = [];
    double minY;
    double maxY;
    strategy.returnData.forEach((dataPoint) {
      if (inConfidenceInterval(dataPoint.x,
          lowerBound: quote.confidenceInterval[strategy.minExpiryDate][0],
          upperBound: quote.confidenceInterval[strategy.minExpiryDate][1])) {
        payoffData.add(FlSpot(
            dataPoint.x, double.parse(dataPoint.value.toStringAsFixed(2))));
        if (maxY == null) {
          maxY = dataPoint.value;
          minY = dataPoint.value;
        } else if (maxY > dataPoint.value) {
          maxY = dataPoint.value;
        } else if (minY < dataPoint.value) {
          minY = dataPoint.value;
        }
      }
    });
    strategy.currentValueData.forEach((dataPoint) {
      if (inConfidenceInterval(dataPoint.x,
          lowerBound: quote.confidenceInterval[strategy.minExpiryDate][0],
          upperBound: quote.confidenceInterval[strategy.minExpiryDate][1])) {
        currentValueData.add(FlSpot(dataPoint.x, dataPoint.value));
        if (maxY > dataPoint.value) {
          maxY = dataPoint.value;
        } else if (minY < dataPoint.value) {
          minY = dataPoint.value;
        }
      }
    });

    maxY > 0 ? maxY = 0.5 : maxY = maxY;
    minY < 0 ? minY = -0.5 : minY = minY;
    if (maxY == minY) {
      maxY = 0.5;
      minY = -0.5;
    }
    final range = (maxY - minY).abs();
    final interval = range / 6;
    minY += interval / 2;
    maxY -= interval / 2;
    final maxX = strategy.returnData.last.x;
    final minX = strategy.returnData.first.x;
    final intervalX = (maxX - minX) / 6;

    final screeWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(right: 8),
      height: screeWidth / 2,
      width: screeWidth,
      child: LineChart(
        LineChartData(
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                  showTitles: true, interval: interval, reservedSize: 40),
              bottomTitles: SideTitles(showTitles: true, interval: intervalX),
            ),
            gridData: FlGridData(show: false),
            clipData: FlClipData.all(),
            minX: payoffData.first.x,
            maxX: payoffData.last.x,
            maxY: minY,
            minY: maxY,
            extraLinesData: ExtraLinesData(verticalLines: [
              VerticalLine(x: strategy.customStockPrice),
              VerticalLine(
                  x: quote.stockPrice, color: Theme.of(context).primaryColor),
            ]),
            lineBarsData: [
              LineChartBarData(
                belowBarData: BarAreaData(
                  show: true,
                  colors: [
                    Colors.green[100],
                  ],
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  colors: [Colors.red[100]],
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
                spots: payoffData,
                colors: [Theme.of(context).primaryColor],
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: currentValueData,
                colors: [Theme.of(context).primaryColor],
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ]),
      ),
    );
  }
}
