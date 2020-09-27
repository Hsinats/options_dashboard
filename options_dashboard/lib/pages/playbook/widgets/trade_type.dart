import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/functions/to_sentence_case.dart';

class PlaybookTradeTypeDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;

  PlaybookTradeTypeDropdownButton({
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TradeType>(
      isDense: true,
      value: tradeInformation.tradeType,
      onChanged: (TradeType newTransactionType) {},
      items: [tradeInformation.tradeType]
          .map<DropdownMenuItem<TradeType>>((TradeType value) {
        return DropdownMenuItem<TradeType>(
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
