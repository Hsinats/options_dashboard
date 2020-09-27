import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/stock_history.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockHistoryChart extends StatelessWidget {
  final StockHistory stockHistory;

  StockHistoryChart(this.stockHistory);

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    double _high;
    double _low;
    int _max;
    stockHistory.history.forEach((point) {
      if (_high == null) {
        _high = point.high;
        _low = point.low;
        _max = point.volume;
      } else if (point.high > _high) {
        _high = point.high;
      } else if (point.low < _low) {
        _low = point.low;
      } else if (point.volume > _max) {
        _max = point.volume;
      }
    });
    return Column(
      children: [
        Container(
            height: _screenWidth / 2,
            width: _screenWidth,
            child: SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
              primaryXAxis: DateTimeAxis(isVisible: true),
              primaryYAxis: NumericAxis(
                name: 'price',
                maximum: _high + (_high - _low) * 0.1,
                minimum: _low - (_high - _low) * 0.2,
                numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
                isVisible: true,
              ),
              axes: [
                NumericAxis(
                    name: 'vol',
                    isVisible: false,
                    maximum: _max * 10.toDouble()),
              ],
              tooltipBehavior: TooltipBehavior(enable: true, shared: true),
              series: <CartesianSeries<SecurityDataPoint, dynamic>>[
                CandleSeries<SecurityDataPoint, dynamic>(
                    name: 'Price',
                    yAxisName: 'price',
                    dataSource: stockHistory.history,
                    xValueMapper: (SecurityDataPoint datePoint, _) =>
                        datePoint.date,
                    lowValueMapper: (SecurityDataPoint datePoint, _) =>
                        datePoint.low,
                    highValueMapper: (SecurityDataPoint datePoint, _) =>
                        datePoint.high,
                    openValueMapper: (SecurityDataPoint datePoint, _) =>
                        datePoint.open,
                    closeValueMapper: (SecurityDataPoint datePoint, _) =>
                        datePoint.close),
                ColumnSeries<SecurityDataPoint, dynamic>(
                  name: 'Volume',
                  yAxisName: 'vol',
                  dataSource: stockHistory.history,
                  xValueMapper: (SecurityDataPoint datePoint, _) =>
                      datePoint.date,
                  yValueMapper: (SecurityDataPoint datePoint, _) =>
                      datePoint.volume,
                )
              ],
            )),
      ],
    );
  }
}
