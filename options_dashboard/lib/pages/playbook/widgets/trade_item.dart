import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/pages/playbook/widgets/buy_or_sell.dart';
import 'package:options_dashboard/pages/playbook/widgets/date.dart';
import 'package:options_dashboard/pages/playbook/widgets/quantity.dart';
import 'package:options_dashboard/pages/playbook/widgets/strike_price.dart';
import 'package:options_dashboard/pages/playbook/widgets/trade_type.dart';

class PlaybookTradeItem extends StatelessWidget {
  const PlaybookTradeItem({
    @required this.tradeInformation,
    @required this.dateList,
  });

  final TradeInfo tradeInformation;
  final List<DateTime> dateList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              PlaybookBuyOrSellDropdownButton(
                tradeInformation: tradeInformation,
              ),
              PlaybookQuantityDropdownButton(
                tradeInformation: tradeInformation,
              ),
              PlaybookTradeTypeDropdownButton(
                  tradeInformation: tradeInformation),
              tradeInformation.tradeType == TradeType.stock
                  ? Text('at \$ 100')
                  : PlaybookStrikePriceDropdownButton(
                      tradeInformation: tradeInformation,
                    ),
              Expanded(child: Container()),
            ],
          ),
          tradeInformation.tradeType == TradeType.stock
              ? Container()
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    PlaybookDateDropdownButton(
                      tradeInformation: tradeInformation,
                      dateList: [tradeInformation.expiryDate],
                    ),
                    Expanded(child: Container()),
                    Text(
                      'Premium: \$ ${tradeInformation.premium.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
