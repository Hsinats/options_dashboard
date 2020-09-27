import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/pages/playbook/widgets/build_trade_view.dart';
import 'package:options_dashboard/pages/playbook/widgets/return_chart.dart';

class BullPutSpread extends StatelessWidget {
  final double stockPrice = 100;
  final List<double> range = [90, 110];
  final List<TradeInfo> tradeList = [
    TradeInfo(
        strikePrice: 100,
        expiryDate: DateTime.now(),
        premium: 4,
        impliedVolatility: 0.2,
        tradeType: TradeType.put,
        buyOrSell: BuyOrSell.sell),
    TradeInfo(
      expiryDate: DateTime.now(),
      strikePrice: 97,
      premium: 2,
      buyOrSell: BuyOrSell.buy,
      impliedVolatility: 0.2,
      tradeType: TradeType.put,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      height: MediaQuery.of(context).size.height - 140,
      child: ListView(
        children: <Widget>[
          Text(
            'Bull put spread',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Bullish/Neutral strategy',
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.fade,
          ),
          Divider(
            height: 2,
            color: Colors.indigo,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'How to',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('sell a put'),
                          Text('buy a put at a lower strike price')
                        ],
                      )),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Max risk',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('equal to premium paid')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Max reward',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('unlimited')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Effect of volatility',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('helps position')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Effect of time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('hurts position')),
                ],
              ),
            ],
          ),
          Divider(
            height: 2,
            color: Colors.indigo,
          ),
          SizedBox(
            height: 12.0,
          ),
          buildPlaybookReturnChart(
            context,
            tradeList: tradeList,
            stockPrice: stockPrice,
            range: range,
          ),
          Divider(
            height: 2,
            color: Colors.purple,
          ),
          ...buildTradeView(tradeList),
        ],
      ),
    );
  }
}
