import 'package:flutter/material.dart';
import 'package:options_dashboard/functions/to_sentence_case.dart';
import 'package:options_dashboard/models/data_structures.dart';

class TradeTypeDropdownButton extends StatelessWidget {
  final Quote quote;
  final TradeInfo tradeInformation;
  final Strategy strategy;

  TradeTypeDropdownButton({
    @required this.quote,
    @required this.strategy,
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TradeType>(
      isDense: true,
      value: tradeInformation.tradeType,
      onChanged: (TradeType newTransactionType) {
        if (newTransactionType == TradeType.stock &&
            tradeInformation.tradeType != TradeType.stock) {
          tradeInformation.updateTradeCallback(
              newStrikePrice: quote.stockPrice,
              newSavedStrikePrice: tradeInformation.strikePrice);
        } else if (tradeInformation.tradeType == TradeType.stock &&
            newTransactionType != TradeType.stock) {
          if (tradeInformation.savedStrike != null) {
            tradeInformation.updateTradeCallback(
                newStrikePrice: tradeInformation.savedStrike);
          } else {
            tradeInformation.updateTradeCallback(
                newStrikePrice:
                    quote.defaultStrikePrice[tradeInformation.expiryDate]);
          }
        }
        if (newTransactionType == TradeType.call) {
          if (!quote.callStrikes[tradeInformation.expiryDate]
              .contains(tradeInformation.strikePrice)) {
            tradeInformation.updateTradeCallback(
                newStrikePrice: quote.callStrikes[tradeInformation.expiryDate]
                    [quote.callStrikes.length ~/ 2]);
          }
        }
        if (newTransactionType == TradeType.put) {
          if (!quote.putStrikes[tradeInformation.expiryDate]
              .contains(tradeInformation.strikePrice)) {
            tradeInformation.updateTradeCallback(
                newStrikePrice: quote.putStrikes[tradeInformation.expiryDate]
                    [quote.putStrikes.length ~/ 2]);
          }
        }
        tradeInformation.updateTradeCallback(newTradeType: newTransactionType);
        strategy.updateStrategyInfo(quote);
      },
      items:
          TradeType.values.map<DropdownMenuItem<TradeType>>((TradeType value) {
        return DropdownMenuItem<TradeType>(
            value: value,
            child: Text(
                toSentenceCase(value
                    .toString()
                    .substring(value.toString().indexOf('.') + 1)),
                style: Theme.of(context).textTheme.bodyText1));
      }).toList(),
    );
  }
}
