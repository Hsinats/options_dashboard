import 'package:flutter/material.dart';

import 'package:options_dashboard/models/data_structures.dart';

class AddTradeToRow extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;

  AddTradeToRow({
    @required this.strategy,
    @required this.quote,
  });
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (strategy.tradeList.length < 5) {
          strategy.addTrade(strategy.tradeList.last.tradeType == TradeType.call
              ? quote.callStrikes[strategy.tradeList.last.expiryDate]
              : quote.putStrikes[strategy.tradeList.last.expiryDate]);
          strategy.updateStrategyInfo(quote);
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Maximum of 5 trades allowed')));
        }
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 20,
            ),
            Text(
              'Add up to 5 trades',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
