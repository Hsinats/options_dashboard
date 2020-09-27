import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';

class RemoveTradeFromList extends StatelessWidget {
  final TradeInfo tradeInformation;
  final Strategy strategy;
  final Quote quote;

  RemoveTradeFromList(
      {@required this.tradeInformation,
      @required this.strategy,
      @required this.quote});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (strategy.tradeList.length != 1) {
          strategy.removeTrade(context, tradeInformation.index, quote);
          strategy.updateStrategyInfo(quote);
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Can\'t remove the last trade.'),
          ));
        }
      },
      child: Icon(
        Icons.clear,
        size: 24,
      ),
    );
  }
}
