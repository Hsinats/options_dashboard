import 'package:intl/intl.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';

class DateDropdownButton extends StatelessWidget {
  DateDropdownButton({
    @required this.strategy,
    @required this.quote,
    @required this.trade,
    @required this.state,
  });

  final Strategy strategy;
  final Quote quote;
  final TradeInfo trade;
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DateTime>(
      isDense: true,
      value: trade.expiryDate,
      onChanged: (DateTime newExpiryDate) async {
        trade.updateTradeCallback(newExpiryDate: newExpiryDate);
        if (quote.optionsChains['$newExpiryDate'] == null) {
          state.toggleLookingUpSymbol();
          await quote.getQuote(false,
              date: newExpiryDate
                      .subtract(Duration(hours: 16, minutes: 30))
                      .subtract(Duration(hours: 4))
                      .millisecondsSinceEpoch ~/
                  1000);
          if (trade.tradeType == TradeType.call
              ? !quote.callStrikes[newExpiryDate].contains(trade.strikePrice)
              : !quote.putStrikes[newExpiryDate].contains(trade.strikePrice)) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Preview strike price not found for new date.')));
            trade.strikePrice = quote.defaultStrikePrice[newExpiryDate];
          }
          state.toggleLookingUpSymbol();
        }
        strategy.updateStrategyInfo(quote);
      },
      items: quote.expirationDates.map((DateTime element) {
        final String expiryDate = DateFormat('yyyy-MMM-dd').format(element);
        final int numDays = element.difference(DateTime.now()).inDays;
        return new DropdownMenuItem(
          value: element,
          child: new Text(
            '$expiryDate ($numDays)',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }
}

class DateDropdownButtonOptionChain extends StatelessWidget {
  DateDropdownButtonOptionChain({
    @required this.quote,
    @required this.state,
  });

  final Quote quote;
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DateTime>(
      isDense: true,
      value: state.ocExpiryDate,
      onChanged: (DateTime newExpiryDate) async {
        if (quote.optionsChains['$newExpiryDate'] == null) {
          state.toggleLookingUpSymbol();
          await quote.getQuote(false,
              date: newExpiryDate.millisecondsSinceEpoch ~/ 1000);
          state.setOCExpiryDate(newExpiryDate);
          state.toggleLookingUpSymbol();
        }
      },
      items: quote.expirationDates.map((DateTime element) {
        final String expiryDate = DateFormat('yyyy-MMM-dd').format(element);
        final int numDays = element.difference(DateTime.now()).inDays;
        return new DropdownMenuItem(
          value: element,
          child: new Text(
            '$expiryDate ($numDays)',
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
