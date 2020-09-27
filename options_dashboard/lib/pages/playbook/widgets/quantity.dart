import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';

class PlaybookQuantityDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;

  PlaybookQuantityDropdownButton({
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      isDense: true,
      value: tradeInformation.quantity,
      onChanged: (int newQuantity) {},
      items: [tradeInformation.quantity].map((int element) {
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
