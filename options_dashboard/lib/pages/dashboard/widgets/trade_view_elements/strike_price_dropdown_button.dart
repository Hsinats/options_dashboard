import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';

class StrikePriceDropdownButton extends StatelessWidget {
  final Quote quote;
  final Strategy strategy;
  final TradeInfo tradeInformation;

  StrikePriceDropdownButton({
    @required this.quote,
    @required this.strategy,
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    List<double> strikeList;
    tradeInformation.tradeType == TradeType.call
        ? strikeList = quote.callStrikes[tradeInformation.expiryDate]
        : strikeList = quote.putStrikes[tradeInformation.expiryDate];
    return strikeList != null
        ? DropdownButton(
            isDense: true,
            value: tradeInformation.strikePrice,
            onChanged: (double newChosenStrikePrice) {
              tradeInformation.updateTradeCallback(
                  newStrikePrice: newChosenStrikePrice);
              strategy.updateStrategyInfo(quote);
            },
            items: strikeList.map<DropdownMenuItem<double>>((element) {
              return DropdownMenuItem<double>(
                child: Text(
                  '\$${element.toStringAsFixed(2)}',
                  style: tradeInformation.tradeType == TradeType.call
                      ? element > quote.stockPrice
                          ? Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.green, fontWeight: FontWeight.bold)
                          : Theme.of(context).textTheme.bodyText1
                      : element < quote.stockPrice
                          ? Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.green, fontWeight: FontWeight.bold)
                          : Theme.of(context).textTheme.bodyText1,
                ),
                value: element,
              );
            }).toList(),
          )
        : Container(child: CircularProgressIndicator());
  }
}
