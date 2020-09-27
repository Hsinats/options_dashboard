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
    return IconButton(
        icon: Icon(
          Icons.clear,
          size: 20,
        ),
        onPressed: () {
          if (strategy.tradeList.length != 1) {
            strategy.tradeList.removeAt(tradeInformation.index);
            strategy.updateStrategyInfo(quote);
          }
        });
  }
}
