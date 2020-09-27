import 'package:intl/intl.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:flutter/material.dart';

class PlaybookDateDropdownButton extends StatelessWidget {
  PlaybookDateDropdownButton({
    @required this.tradeInformation,
    @required this.dateList,
  });

  final TradeInfo tradeInformation;
  final dateList;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DateTime>(
      isDense: true,
      value: tradeInformation.expiryDate,
      onChanged: (DateTime newExpiryDate) {},
      items: dateList.map<DropdownMenuItem<DateTime>>((DateTime element) {
        return new DropdownMenuItem(
          value: element,
          child: new Text(
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30)))} (30)',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }
}
