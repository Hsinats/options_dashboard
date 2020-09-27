import 'package:flutter/material.dart';
import 'package:options_dashboard/models/quote.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    Key key,
    @required this.quote,
    @required this.context,
  }) : super(key: key);

  final Quote quote;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        '${quote.symbol.toUpperCase()} - ',
                        style: Theme.of(context).textTheme.headline1,
                        maxLines: 2,
                      ),
                      Text(
                        '\$ ${quote.stockPrice.toStringAsFixed(2)} (${quote.stockPriceChange.toStringAsFixed(2)})',
                        style: TextStyle(
                            color: quote.stockPriceChange > 0
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                  Text(
                    quote.companyName,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
