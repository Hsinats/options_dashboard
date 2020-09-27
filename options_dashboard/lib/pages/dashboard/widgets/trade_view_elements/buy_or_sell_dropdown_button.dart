import 'package:flutter/material.dart';
import 'package:options_dashboard/functions/to_sentence_case.dart';
import 'package:options_dashboard/models/data_structures.dart';

class BuyOrSellDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;
  final Quote quote;
  final Strategy strategy;

  BuyOrSellDropdownButton({
    @required this.quote,
    @required this.strategy,
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BuyOrSell>(
      isDense: true,
      value: tradeInformation.buyOrSell,
      onChanged: (BuyOrSell newTransactionType) {
        tradeInformation.updateTradeCallback(
          newBuyOrSell: newTransactionType,
        );
        strategy.updateStrategyInfo(quote);
      },
      items:
          BuyOrSell.values.map<DropdownMenuItem<BuyOrSell>>((BuyOrSell value) {
        return DropdownMenuItem<BuyOrSell>(
            value: value,
            child: Text(
              toSentenceCase(value
                  .toString()
                  .substring(value.toString().indexOf('.') + 1)),
              style: Theme.of(context).textTheme.bodyText1,
            ));
      }).toList(),
    );
  }
}
