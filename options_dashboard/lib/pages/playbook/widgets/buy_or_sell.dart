import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/functions/to_sentence_case.dart';

class PlaybookBuyOrSellDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;

  PlaybookBuyOrSellDropdownButton({
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BuyOrSell>(
      isDense: true,
      value: tradeInformation.buyOrSell,
      onChanged: (BuyOrSell newTransactionType) {},
      items: [tradeInformation.buyOrSell]
          .map<DropdownMenuItem<BuyOrSell>>((BuyOrSell value) {
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
