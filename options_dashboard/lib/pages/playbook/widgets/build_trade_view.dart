import 'package:flutter/material.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/pages/playbook/widgets/trade_item.dart';

List<Widget> buildTradeView(List<TradeInfo> tradeList) {
  List<Widget> output = [];
  tradeList.forEach((trade) {
    output.add(PlaybookTradeItem(
      tradeInformation: trade,
      dateList: [trade.expiryDate],
    ));
    output.add(Divider(
      height: 2,
      color: Colors.purple,
    ));
  });
  return output;
}
