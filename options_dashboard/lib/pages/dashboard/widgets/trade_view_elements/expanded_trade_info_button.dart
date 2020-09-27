import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';

class ExpandTradeInfoButton extends StatelessWidget {
  final Strategy strategy;
  final int index;
  final Quote quote;

  ExpandTradeInfoButton(
      {@required this.strategy, @required this.index, @required this.quote});

  @override
  Widget build(BuildContext context) {
    bool expanded;
    if (index >= strategy.tradeList.length) {
      expanded = false;
    } else {
      expanded = strategy.tradeList[index].expanded;
    }
    return GestureDetector(
      onTap: () {
        strategy.expandTrade(
          index,
          context: context,
          quote: quote,
        );
      },
      child: expanded
          ? Icon(
              Icons.keyboard_arrow_left,
              size: 24,
            )
          : Icon(
              Icons.expand_more,
              size: 24,
            ),
    );
  }
}
