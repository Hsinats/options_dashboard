import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/quote.dart';

class Fundamentals extends StatelessWidget {
  final DateTime dividendDate;
  final double dividendYield;
  final double dividendRate;
  final String yearRange;
  final int marketCap;
  final double peRatio;
  final int averageVolume;
  final Quote quote;
  Fundamentals({
    @required this.dividendDate,
    @required this.dividendYield,
    @required this.dividendRate,
    @required this.yearRange,
    @required this.marketCap,
    @required this.peRatio,
    @required this.averageVolume,
    @required this.quote,
  });
  final String unavailable = '-';

  @override
  Widget build(BuildContext context) {
    String outputDividendDate;
    String outputDividendYield;
    String outputYearRange;
    String outputMarketCap;
    String outputVolume;
    String outputPE;
    if (dividendDate != null) {
      outputDividendDate = DateFormat('yyyy-MMM-dd').format(dividendDate);
      if (dividendRate != null && dividendYield != null) {
        final String outputDividendRate =
            (dividendRate * 100).toStringAsFixed(2);
        outputDividendYield = '$dividendYield ($outputDividendRate%)';
      } else {
        outputDividendYield = '-';
      }
    } else {
      outputDividendYield = '-';
    }
    if (yearRange == null) {
      outputYearRange = unavailable;
    } else {
      outputYearRange = yearRange;
    }
    if (marketCap == null) {
      outputMarketCap = unavailable;
    } else {
      outputMarketCap = NumberFormat.compact().format(marketCap).toString();
    }
    if (peRatio == null) {
      outputPE = unavailable;
    } else {
      outputPE = peRatio.toStringAsFixed(2);
    }
    if (averageVolume == null) {
      outputVolume = unavailable;
    } else {
      outputVolume = NumberFormat.compact().format(averageVolume).toString();
    }
    return Column(
      children: [
        Table(
          children: [
            TableRow(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Text('Market cap')),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text('\$ $outputMarketCap')),
              ],
            ),
            TableRow(children: [
              Align(alignment: Alignment.centerRight, child: Text('52w range')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$outputYearRange',
                    textAlign: TextAlign.right,
                  ))
            ]),
            outputDividendYield == '-'
                ? TableRow(children: [Container(), Container()])
                : TableRow(
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('Dividend Date')),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('${outputDividendDate ?? unavailable}')),
                    ],
                  ),
            TableRow(children: [
              Align(alignment: Alignment.centerRight, child: Text('Dividend')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('$outputDividendYield'))
            ]),
            TableRow(
              children: [
                Align(
                    alignment: Alignment.centerRight, child: Text('PE Ratio')),
                Align(
                    alignment: Alignment.centerRight, child: Text('$outputPE')),
              ],
            ),
            TableRow(children: [
              Align(
                alignment: Alignment.centerRight,
                child: averageVolume > 1000000
                    ? Text('Avg. Volume')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.info_outline),
                          Text(
                            ' Avg. Volume',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('$outputVolume'))
            ]),
            TableRow(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Earnings date')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('${quote.earningsDate}'))
            ]),
            TableRow(children: [
              Align(alignment: Alignment.centerRight, child: Text('EPS(TTL)')),
              Align(
                  alignment: Alignment.centerRight, child: Text('${quote.eps}'))
            ]),
          ],
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
