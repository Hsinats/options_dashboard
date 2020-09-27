import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';

class PlaybookStrikePriceDropdownButton extends StatelessWidget {
  final TradeInfo tradeInformation;

  PlaybookStrikePriceDropdownButton({
    @required this.tradeInformation,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isDense: true,
      value: tradeInformation.strikePrice,
      onChanged: (double newChosenStrikePrice) {},
      items: [tradeInformation.strikePrice]
          .map<DropdownMenuItem<double>>((element) {
        return DropdownMenuItem<double>(
          child: Container(
            child: Text('\$ ${element.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                )),
          ),
          value: element,
        );
      }).toList(),
    );
  }
}
