import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';

class QuantityDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;
  final Quote quote;
  final Strategy strategy;
  final List<int> quantityList = [
    0,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000
  ];

  QuantityDropdownButton({
    @required this.tradeInformation,
    @required this.quote,
    @required this.strategy,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      isDense: true,
      value: tradeInformation.quantity,
      onChanged: (int newQuantity) {
        tradeInformation.updateTradeCallback(
          newQuantity: newQuantity,
        );
        strategy.updateStrategyInfo(quote);
      },
      items: quantityList.map((int element) {
        return new DropdownMenuItem(
          value: element,
          child: new Text(
            tradeInformation.tradeType == TradeType.stock
                ? (element).toString()
                : (element / 100).toStringAsFixed(0),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }
}
