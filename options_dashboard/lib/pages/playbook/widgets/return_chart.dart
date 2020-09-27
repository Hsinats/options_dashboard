import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:options_dashboard/models/trade_info.dart';
export 'return_chart.dart';

Container buildPlaybookReturnChart(
  context, {
  @required List<TradeInfo> tradeList,
  @required double stockPrice,
  @required List<double> range,
}) {
  // Arranged the strikes prices and shows external behavior outside of strike
  // range.
  List<double> strikePriceList = [];
  List<FlSpot> valueDataToPlot = [];
  double _xMin = range[0];
  double _xMax = range[1];
  List<double> _yValues = [];
  double _yMin;
  double _yMax;

  for (int i = 0; i < tradeList.length; i++) {
    strikePriceList.add(tradeList[i].strikePrice);
  }
  strikePriceList.add(_xMin);
  strikePriceList.add(stockPrice);
  strikePriceList.add(_xMax);
  strikePriceList.sort();

  strikePriceList.forEach((strike) {
    double summedValue = 0;
    tradeList.forEach((trade) {
      summedValue += trade.tradeValue(
        stockPrice: strike,
        interest: 0.05,
        volatility: trade.impliedVolatility,
        onDate: DateTime.now(),
      );
    });
    valueDataToPlot.add(FlSpot(
      strike,
      summedValue,
    ));
    _yValues.add(summedValue);
  });

  _yMin = _yValues.reduce(min);
  _yMax = _yValues.reduce(max);

  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width / 2,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        clipData: FlClipData.all(),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
              textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              showTitles: true,
              interval: 5),
        ),
        minX: _xMin,
        maxX: _xMax,
        minY: _yMin - (_yMax - _yMin).abs() * 0.1,
        maxY: _yMax + (_yMax - _yMin).abs() * 0.1,
        extraLinesData: ExtraLinesData(verticalLines: [
          VerticalLine(x: 100, color: Colors.black26),
        ], horizontalLines: [
          HorizontalLine(y: 0, color: Colors.black26)
        ]),
        axisTitleData: FlAxisTitleData(
          bottomTitle: AxisTitle(
            titleText: 'Market Price',
            textStyle: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
            showTitle: false,
          ),
          leftTitle: AxisTitle(
            titleText: 'Return',
            showTitle: false,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            colors: [Colors.indigo],
            barWidth: 3,
            dotData: FlDotData(
              show: false,
            ),
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
            spots: valueDataToPlot,
          ),
        ],
      ),
    ),
  );
}
