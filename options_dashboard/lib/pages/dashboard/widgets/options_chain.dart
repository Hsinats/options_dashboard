import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/dashboard.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:options_dashboard/pages/dashboard/widgets/trade_view_elements/date_dropdown_button.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';

class OptionsChain extends StatelessWidget {
  final Quote quote;
  final DateTime expiryDate;
  final Strategy strategy;
  final DashboardState state;
  OptionsChain(
    this.quote,
    this.expiryDate,
    this.strategy,
    this.state,
  );

  @override
  Widget build(BuildContext context) {
    return quote.hasOptions
        ? ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
                DashboardHeader(
                  quote: quote,
                  context: context,
                ),
                DataHeader(
                  'Options Chain',
                  action:
                      DateDropdownButtonOptionChain(quote: quote, state: state),
                ),
                Text(
                  'Tap on a bid price to add a sell order to you strategy. The ask price does the same thing for buy orders.',
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Calls',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _tableHeaders,
                    columnSpacing: 10,
                    rows: _buildTable(
                      context,
                      quote.optionsChains,
                      expiryDate,
                      TradeType.call,
                      quote.stockPrice,
                      strategy,
                      quote,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Puts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _tableHeaders,
                    columnSpacing: 10,
                    rows: _buildTable(
                      context,
                      quote.optionsChains,
                      expiryDate,
                      TradeType.put,
                      quote.stockPrice,
                      strategy,
                      quote,
                    ),
                  ),
                ),
              ])
        : Center(
            child: Text('Unable to find options associated with this security'),
          );
  }
}

const _tableHeaders = [
  DataColumn(
    label: Text('Strike'),
    numeric: true,
  ),
  DataColumn(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Text('Bid'),
      ),
      numeric: true),
  DataColumn(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Text('Ask'),
      ),
      numeric: true),
  DataColumn(
      label: Text(
        'Implied\nVolatility',
        textAlign: TextAlign.end,
      ),
      numeric: true),
  DataColumn(label: Text('Volume'), numeric: true),
  DataColumn(
      label: Text(
        'Open\nInterest',
        textAlign: TextAlign.end,
      ),
      numeric: true),
  DataColumn(
      label: Text(
        'Vol.\n/Interest',
        textAlign: TextAlign.end,
      ),
      numeric: true),
];

_buildTable(
  BuildContext context,
  final Map<DateTime, dynamic> optionsChain,
  final DateTime expiryDate,
  final TradeType tradeType,
  final double stockPrice,
  final Strategy strategy,
  final Quote quote,
) {
  List<DataRow> tableBody = [];
  int tradeInt;
  if (tradeType == TradeType.call) {
    tradeInt = 0;
  } else {
    tradeInt = 1;
  }
  optionsChain[expiryDate][tradeInt].forEach((key, value) {
    bool bought = false;
    bool sold = false;
    int index;
    for (TradeInfo trade in strategy.tradeList) {
      if (trade.expiryDate == expiryDate) {
        if (trade.tradeType == tradeType &&
            trade.strikePrice == key &&
            trade.expiryDate == expiryDate) {
          index = trade.index;
          if (trade.buyOrSell == BuyOrSell.buy) {
            bought = true;
          }
          if (trade.buyOrSell == BuyOrSell.sell) {
            sold = true;
          }
        }
      }
    }
    tableBody.add(DataRow(
      cells: [
        DataCell(
          Text(key.toStringAsFixed(2),
              style: tradeInt == 0
                  ? stockPrice > key
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null
                  : stockPrice < key
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null),
        ),
        DataCell(InkWell(
          onTap: () {
            if (!sold) {
              if (strategy.tradeList.length != 5) {
                strategy.addTradeFromOptionsChain(
                    strikePrice: key,
                    expiryDate: expiryDate,
                    tradeType: tradeType,
                    bid: value['bid'],
                    ask: value['ask'],
                    lastPrice: value['lastPrice'],
                    optionsChain: optionsChain,
                    buyOrSell: BuyOrSell.sell);
                strategy.updateStrategyInfo(quote);
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Maximum of 5 trades allowed')));
              }
            } else {
              if (strategy.tradeList.length != 1) {
                strategy.removeTrade(
                  context,
                  index,
                  quote,
                );
                strategy.updateStrategyInfo(quote);
              } else
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Can\'t remove the last trade.'),
                ));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(3),
              color: sold ? Colors.red[200] : null, //Colors.indigo[100],
            ),
            padding: const EdgeInsets.all(6),
            child: Text(value['bid'].toStringAsFixed(2),
                style: tradeInt == 0
                    ? stockPrice > key
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : null
                    : stockPrice < key
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : null),
          ),
        )),
        DataCell(InkWell(
          onTap: () {
            if (!bought) {
              if (strategy.tradeList.length != 5) {
                strategy.addTradeFromOptionsChain(
                    strikePrice: key,
                    expiryDate: expiryDate,
                    tradeType: tradeType,
                    bid: value['bid'],
                    ask: value['ask'],
                    lastPrice: value['lastPrice'],
                    optionsChain: optionsChain,
                    buyOrSell: BuyOrSell.buy);
                strategy.updateStrategyInfo(quote);
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Maximum of 5 trades allowed')));
              }
            } else {
              if (strategy.tradeList.length != 1) {
                strategy.removeTrade(context, index, quote);
                strategy.updateStrategyInfo(quote);
              } else
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Can\'t remove the last trade.'),
                ));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(3),
              color: bought ? Colors.green[200] : null, // Colors.indigo[100],
            ),
            padding: const EdgeInsets.all(6),
            child: Text(value['ask'].toStringAsFixed(2),
                style: tradeInt == 0
                    ? stockPrice > key
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : null
                    : stockPrice < key
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : null),
          ),
        )),
        DataCell(Text(
            (value['impliedVolatility']).toStringAsFixed(3).toString(),
            style: tradeInt == 0
                ? stockPrice > key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null
                : stockPrice < key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null)),
        DataCell(Text((value['volume'] ?? 0).toStringAsFixed(0).toString(),
            style: tradeInt == 0
                ? stockPrice > key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null
                : stockPrice < key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null)),
        DataCell(Text(
            (value['openInterest'] ?? 0).toStringAsFixed(0).toString(),
            style: tradeInt == 0
                ? stockPrice > key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null
                : stockPrice < key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null)),
        DataCell(Text(
            ((value['volume'] ?? 0) / value['openInterest'] ?? 0)
                .toStringAsFixed(3)
                .toString(),
            style: tradeInt == 0
                ? stockPrice > key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null
                : stockPrice < key
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null)),
      ],
    ));
  });
  return tableBody;
}

// tradePressCallback(
//     BuildContext context,
//     Strategy strategy,
//     double strikePrice,
//     int expiryDate,
//     TradeType tradeType,ER
//     double bid,
//     double ask,
//     lastPrice,
//     optionsChain) {
//   if (!bought) {
//     if (strategy.tradeList.length != 5) {
//       strategy.addTradeFromOptionsChain(
//           strikePrice: strikePrice,
//           expiryDate: expiryDate,
//           tradeType: tradeType,
//           bid: bid,
//           ask: ask,
//           lastPrice: lastPrice,
//           optionsChain: optionsChain);
//     }
//   } else {
//     Scaffold.of(context)
//         .showSnackBar(SnackBar(content: Text('Can\'t add more than 5 trades')));
//   }
// }
