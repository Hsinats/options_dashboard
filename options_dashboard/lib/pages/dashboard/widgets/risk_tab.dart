import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/functions/black_scholes.dart';
import 'package:options_dashboard/pages/dashboard/dashboard.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:options_dashboard/pages/dashboard/graphs/trade_range.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';

class RiskTabMobile extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;
  final DashboardState state;

  RiskTabMobile({
    @required this.quote,
    @required this.strategy,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    double netDelta = 0;
    double netTheta = 0;
    double netVega = 0;
    double netGamma = 0;
    strategy.tradeList.forEach((trade) {
      double deltaPoint;
      double thetaPoint;
      double vegaPoint;
      double gammaPoint;
      deltaPoint = delta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      thetaPoint = theta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      vegaPoint = vega(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      gammaPoint = gamma(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      if (trade.buyOrSell == BuyOrSell.sell) {
        deltaPoint *= -1;
        thetaPoint *= -1;
        vegaPoint *= -1;
        gammaPoint *= -1;
      }
      netDelta += deltaPoint * trade.quantity;
      netTheta += thetaPoint * trade.quantity;
      netVega += vegaPoint * trade.quantity;
      netGamma += gammaPoint * trade.quantity;
    });
    int dte = strategy.minExpiryDate.difference(DateTime.now()).inDays;
    double maxReturn = strategy.maxReturn != 'Unlimited'
        ? double.parse(strategy.maxReturn)
        : double.infinity;
    double maxRisk = strategy.maxRisk != 'Unlimited'
        ? double.parse(strategy.maxRisk)
        : double.infinity;
    String maxPayoff =
        maxRisk != double.infinity && maxReturn != double.infinity
            ? '${(maxReturn / maxRisk.abs()).toStringAsFixed(2)}:1'
            : maxReturn != double.infinity ? '0:1' : 'infinite';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        DashboardHeader(
          quote: quote,
          context: context,
        ),
        DataHeader(
          'Trade Range',
          action: Text(
              'on ${DateFormat('yyyy-MMM-dd').format(strategy.minExpiryDate)} ($dte)'),
        ),
        PdfChart(strategy),
        DataHeader('Strategy Overview'),
        _RiskOverviewTableMobile(
          netTheta: netTheta,
          netVega: netVega,
          netGamma: netGamma,
          maxRisk: strategy.maxRisk,
          maxReward: strategy.maxReturn,
          strategy: strategy,
        ),
        DataHeader('Statistics'),
        Table(
          children: [
            TableRow(children: [
              Text('Breakeven points'),
              Text('\$${strategy.breakPoints}'),
            ]),
            TableRow(
              children: [
                Text('Time decay'),
                Text('\$${netTheta.toStringAsFixed(2)}/day'),
              ],
            ),
            TableRow(
              children: [
                Text('Payoff ratio'),
                strategy.payoffRatio != double.nan
                    ? Text('${strategy.payoffRatio.toStringAsFixed(2)}:1')
                    : Text('infinte'),
              ],
            ),
            TableRow(
              children: [
                Text('Max payoff ratio'),
                Text('$maxPayoff'),
              ],
            ),
            TableRow(children: [
              Text('Probability of profit'),
              Text('${(strategy.pop * 100).toStringAsFixed(2)}\%')
            ]),
          ],
        ),
        DataHeader('Greeks'),
        Table(children: [
          TableRow(
            children: [
              Text('Net delta'),
              Text('\$${netDelta.toStringAsFixed(2)}/\$'),
            ],
          ),
          TableRow(
            children: [
              Text('Net gamma'),
              Text('\$${netGamma.toStringAsFixed(2)}/\$²'),
            ],
          ),
          TableRow(
            children: [
              Text('Net theta'),
              Text('\$${netTheta.toStringAsFixed(2)}/day'),
            ],
          ),
          TableRow(
            children: [
              Text('Net vega'),
              Text('\$${netVega.toStringAsFixed(2)}/%'),
            ],
          ),
        ]),
        SizedBox(height: 12)
      ],
    );
  }
}

class RiskTabTablet extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;
  final DashboardState state;

  RiskTabTablet({
    @required this.quote,
    @required this.strategy,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    double netDelta = 0;
    double netTheta = 0;
    double netVega = 0;
    double netGamma = 0;
    strategy.tradeList.forEach((trade) {
      double deltaPoint;
      double thetaPoint;
      double vegaPoint;
      double gammaPoint;
      deltaPoint = delta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      thetaPoint = theta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      vegaPoint = vega(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      gammaPoint = gamma(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      if (trade.buyOrSell == BuyOrSell.sell) {
        deltaPoint *= -1;
        thetaPoint *= -1;
        vegaPoint *= -1;
        gammaPoint *= -1;
      }
      netDelta += deltaPoint * trade.quantity;
      netTheta += thetaPoint * trade.quantity;
      netVega += vegaPoint * trade.quantity;
      netGamma += gammaPoint * trade.quantity;
    });
    int dte = strategy.minExpiryDate.difference(DateTime.now()).inDays;
    double maxReturn = strategy.maxReturn != 'Unlimited'
        ? double.parse(strategy.maxReturn)
        : double.infinity;
    double maxRisk = strategy.maxRisk != 'Unlimited'
        ? double.parse(strategy.maxRisk)
        : double.infinity;
    String maxPayoff =
        maxRisk != double.infinity && maxReturn != double.infinity
            ? '${(maxReturn / maxRisk.abs()).toStringAsFixed(2)}:1'
            : maxReturn != double.infinity ? '0:1' : 'infinite';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        DashboardHeader(
          quote: quote,
          context: context,
        ),
        DataHeader(
          'Trade Range',
          action: Text(
              'on ${DateFormat('yyyy-MMM-dd').format(strategy.minExpiryDate)} ($dte)'),
        ),
        PdfChart(strategy),
        DataHeader('Strategy Overview'),
        _RiskOverviewTableTablet(
          netTheta: netTheta,
          netVega: netVega,
          netGamma: netGamma,
          maxRisk: strategy.maxRisk,
          maxReward: strategy.maxReturn,
          strategy: strategy,
        ),
        DataHeader('Statistics'),
        Table(
          children: [
            buildFourColumnTableRow(
                'Breakeven points',
                '\$${strategy.breakPoints}',
                'Time decay',
                '\$${netTheta.toStringAsFixed(2)}/day'),
            buildFourColumnTableRow(
                'Payoff ratio',
                strategy.payoffRatio != double.nan
                    ? '${strategy.payoffRatio.toStringAsFixed(2)}:1'
                    : 'infinte',
                'Max payoff ratio',
                '$maxPayoff'),
            buildFourColumnTableRow(
                'Probability of profit',
                '${(strategy.pop * 100).toStringAsFixed(2)}\%',
                'Risk of ruin',
                '100 %')
          ],
        ),
        DataHeader('Greeks'),
        Table(children: [
          buildFourColumnTableRow(
              'Net delta',
              '\$${netDelta.toStringAsFixed(2)}/\$',
              'Net gamma',
              '\$${netGamma.toStringAsFixed(2)}/\$²'),
          buildFourColumnTableRow(
              'Net theta',
              '\$${netTheta.toStringAsFixed(2)}/day',
              'Net vega',
              '\$${netVega.toStringAsFixed(2)}/%'),
        ]),
        SizedBox(height: 12)
      ],
    );
  }
}

class _RiskOverviewTableMobile extends StatelessWidget {
  _RiskOverviewTableMobile(
      {@required this.netTheta,
      @required this.netVega,
      @required this.netGamma,
      @required this.maxRisk,
      @required this.maxReward,
      @required this.strategy});

  final double netTheta;
  final double netVega;
  final double netGamma;
  final String maxRisk;
  final String maxReward;
  final Strategy strategy;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        buildTwoColumnTableRow(
            strategy.totalPremiums > 0 ? 'You receive' : 'You pay',
            '\$${strategy.totalPremiums.abs().toStringAsFixed(2)}'),
        TableRow(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Max risk',
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  maxRisk == 'Unlimited' ? maxRisk : '\$$maxRisk',
                )),
          ],
        ),
        TableRow(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Max reward',
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  maxReward == 'Unlimited' ? maxReward : '\$$maxReward',
                )),
          ],
        ),
        TableRow(
          children: [
            Text('Expected Return'),
            Text('\$${strategy.strategyValue.toStringAsFixed(2)}'),
          ],
        ),
        TableRow(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Effect of volatility',
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(netVega > 0 ? 'helps position' : 'hurts position')),
          ],
        ),
        TableRow(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Effect of time',
                )),
            Align(
                alignment: Alignment.centerLeft,
                child:
                    Text(netTheta > 0 ? 'helps position' : 'hurts position')),
          ],
        ),
        buildTwoColumnTableRow(
          'Strategy stability',
          netGamma.abs() < 20
              ? 'stable'
              : netGamma < 50 ? 'unstable' : 'very unstable',
        )
      ],
    );
  }
}

class _RiskOverviewTableTablet extends StatelessWidget {
  _RiskOverviewTableTablet(
      {@required this.netTheta,
      @required this.netVega,
      @required this.netGamma,
      @required this.maxRisk,
      @required this.maxReward,
      @required this.strategy});

  final double netTheta;
  final double netVega;
  final double netGamma;
  final String maxRisk;
  final String maxReward;
  final Strategy strategy;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        buildFourColumnTableRow(
          strategy.totalPremiums > 0 ? 'You receive' : 'You pay',
          '\$${strategy.totalPremiums.abs().toStringAsFixed(2)}',
          'Max risk',
          maxRisk == 'Unlimited' ? maxRisk : '\$$maxRisk',
        ),
        buildFourColumnTableRow(
            'Max reward',
            maxReward == 'Unlimited' ? maxReward : '\$$maxReward',
            'Expected Return',
            '\$${strategy.strategyValue.toStringAsFixed(2)}'),
        buildFourColumnTableRow(
            'Effect of volatility',
            netVega > 0 ? 'helps position' : 'hurts position',
            'Effect of time',
            netTheta > 0 ? 'helps position' : 'hurts position'),
      ],
    );
  }
}

List<String> buildConfidenceIntervalOutput(List<double> range) {
  List<String> output = [];
  range.forEach((element) {
    output.add(element.toStringAsFixed(2));
  });
  return output;
}

// class _Warnings extends StatelessWidget {
//   _Warnings({
//     this.earningsWarning = true,
//     this.dividendWarning = true,
//   });

//   final bool earningsWarning;
//   final bool dividendWarning;

//   @override
//   Widget build(BuildContext context) {
//     return Column(mainAxisSize: MainAxisSize.min, children: [
//       DataHeader('Warnings'),
//       earningsWarning
//           ? Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Icon(
//                     Icons.warning,
//                     color: Colors.red,
//                   ),
//                 ),
//                 Flexible(
//                   child: Text(
//                     'The first expiry date of this strategy may be after earnings. This often results in a reduction of implied volatility.',
//                     maxLines: 10,
//                   ),
//                 ),
//               ],
//             )
//           : Container(),
//       dividendWarning
//           ? Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Icon(
//                     Icons.warning,
//                     color: Colors.red,
//                   ),
//                 ),
//                 Flexible(
//                   child: Text(
//                     'The first expiry date of this strategy may be after after a dividend is issues. This will affect the value of different options differently.',
//                     maxLines: 10,
//                   ),
//                 ),
//               ],
//             )
//           : Container(),
//       Divider(
//         color: Colors.indigo,
//       )
//     ]);
//   }
// }
