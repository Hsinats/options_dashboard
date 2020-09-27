import 'package:flutter/material.dart';
import 'package:options_dashboard/functions/black_scholes.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';

class DashboardStrategySummaryMobile extends StatelessWidget {
  const DashboardStrategySummaryMobile({
    Key key,
    @required this.strategy,
    @required this.quote,
  }) : super(key: key);

  final Strategy strategy;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    double netTheta = 0;
    strategy.tradeList.forEach((trade) {
      double thetaPoint;
      thetaPoint = theta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      if (trade.buyOrSell == BuyOrSell.sell) {
        thetaPoint *= -1;
      }
      netTheta += thetaPoint * trade.quantity;
    });

    // strategy.totalPremiums;
    return Container(
      // padding: const EdgeInsets.only(bottom: 5, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Table(
              children: [
                buildTwoColumnTableRow('Premiums',
                    '\$${strategy.totalPremiums.toStringAsFixed(2)}'),
                buildTwoColumnTableRow('Max risk', '\$${strategy.maxRisk}'),
                buildTwoColumnTableRow('Max reward', '\$${strategy.maxReturn}'),
                TableRow(
                  children: [
                    Row(
                      children: [
                        strategy.singleDate
                            ? Text('Breakeven point(s)')
                            : Tooltip(
                                message:
                                    'Strategies with multiple exiration dates may retun incomplete data.',
                                child: Row(
                                  children: [
                                    Text(
                                      'Breakeven point(s)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(Icons.warning),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    Text('\$ ${strategy.breakPoints}'),
                  ],
                ),
                buildTwoColumnTableRow(
                    'Time decay', '\$${netTheta.toStringAsFixed(2)}/day'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardStrategySummaryTablet extends StatelessWidget {
  const DashboardStrategySummaryTablet({
    Key key,
    @required this.strategy,
    @required this.quote,
  }) : super(key: key);

  final Strategy strategy;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    double netTheta = 0;
    strategy.tradeList.forEach((trade) {
      double thetaPoint;
      thetaPoint = theta(
          stockPrice: quote.stockPrice,
          strikePrice: trade.strikePrice,
          volatility: trade.impliedVolatility,
          interest: quote.interest,
          term: (trade.expiryDate.difference(DateTime.now()).inMinutes /
              (365 * 24 * 60)),
          tradeType: trade.tradeType);
      if (trade.buyOrSell == BuyOrSell.sell) {
        thetaPoint *= -1;
      }
      netTheta += thetaPoint * trade.quantity;
    });

    // strategy.totalPremiums;
    return Container(
      // padding: const EdgeInsets.only(bottom: 5, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Table(
              children: [
                buildFourColumnTableRow(
                  'Premiums',
                  '\$${strategy.totalPremiums.toStringAsFixed(2)}',
                  'Max risk',
                  '\$${strategy.maxRisk}',
                ),
                buildFourColumnTableRow(
                  'Max reward',
                  '\$${strategy.maxReturn}',
                  'Breakeven',
                  '\$ ${strategy.breakPoints}',
                ),
                buildFourColumnTableRow(
                  'Time decay',
                  '\$${netTheta.toStringAsFixed(2)}/day',
                  '#',
                  '#',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
