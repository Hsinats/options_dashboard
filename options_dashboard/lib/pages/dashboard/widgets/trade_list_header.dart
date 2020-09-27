import 'package:flutter/material.dart';
import 'package:options_dashboard/functions/to_sentence_case.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/dashboard.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:options_dashboard/pages/dashboard/widgets/svg_icon.dart';
import 'package:options_dashboard/services/optimize.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

class TradeListHeader extends StatelessWidget {
  final BuildContext context;
  final Strategy strategy;
  final Quote quote;
  final DashboardState state;
  final Strategies passedStrategy;

  TradeListHeader(
    this.context, {
    @required this.strategy,
    @required this.quote,
    @required this.state,
    @required this.passedStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return DataHeader(
      'Payoff Chart',
      action: _SuggestTradeButton(
        state: state,
        quote: quote,
        strategy: strategy,
        passedStrategy: passedStrategy,
      ),
    );
  }
}

class _SuggestTradeButton extends StatelessWidget {
  const _SuggestTradeButton({
    Key key,
    @required this.state,
    @required this.quote,
    @required this.strategy,
    @required this.passedStrategy,
  }) : super(key: key);

  final DashboardState state;
  final Quote quote;
  final Strategy strategy;
  final Strategies passedStrategy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: passedStrategy == null
              ? null
              : Theme.of(context).primaryColor.withAlpha(200),
          borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: () async {
          _showSetupDialog(
            context,
            state,
            quote,
            strategy.minExpiryDate,
            strategy,
            passedStrategy,
          );
        },
        child: Row(
          children: [
            SvgIcon(
              'insights',
              tooltipMessage: 'Optimize a trade',
              size: 24,
              filled: passedStrategy == null ? false : true,
            ),
            Text(
              ' Suggest trade',
              style: TextStyle(
                  color: passedStrategy == null ? null : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

_showSetupDialog(
  BuildContext context,
  DashboardState state,
  Quote quote,
  DateTime expiryDate,
  Strategy strategy,
  Strategies passedStrategy,
) {
  showDialog(
    context: context,
    builder: (context) {
      return OptimizeTradeAlertDialog(
          quote, expiryDate, strategy, passedStrategy);
      // return AlertDialog(
      //   title: Text('Choose a strategy'),
      //   content: ListView(
      //     children: [
      //       Text('What\'s your outlook?'),
      //       Text('What strategy do you want to use?'),
      //       DropdownButton<Strategies>(
      //         value: state.strategy,
      //         onChanged: (newStrategyType) {
      //           state.setStrategy(newStrategyType);
      //         },
      //         items: Strategies.values
      //             .map<DropdownMenuItem<Strategies>>((Strategies value) {
      //           return DropdownMenuItem<Strategies>(
      //             value: value,
      //             child: Text(value
      //                 .toString()
      //                 .substring(value.toString().indexOf('.') + 1)),
      //           );
      //         }).toList(),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     FlatButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       child: Text('Cancel'),
      //     ),
      //     RaisedButton(
      //         onPressed: () {
      //           strategy.tradeList = determineBestTrades(
      //             state.strategy,
      //             quote: quote,
      //             expiryDate: expiryDate,
      //           );
      //           strategy.updateStrategyInfo(context, quote: quote);
      //           Navigator.pop(context);
      //         },
      //         child: Text('Optimize'))
      //   ],
      // );
    },
  );
}

class OptimizeTradeAlertDialog extends StatefulWidget {
  final Quote quote;
  final DateTime expiryDate;
  final Strategy strategy;
  final Strategies passedStrategy;
  OptimizeTradeAlertDialog(
    this.quote,
    this.expiryDate,
    this.strategy,
    this.passedStrategy,
  );

  @override
  _OptimizeTradeAlertDialogState createState() =>
      _OptimizeTradeAlertDialogState();
}

class _OptimizeTradeAlertDialogState extends State<OptimizeTradeAlertDialog> {
  List<TradeInfo> tradeList;
  StrategyType strategyType = StrategyType.all;
  Strategies stratToOptimize;

  @override
  void initState() {
    stratToOptimize = widget.passedStrategy != null
        ? widget.passedStrategy
        : Strategies.longCall;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Choose a strategy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What\'s your outlook?'),
            DropdownButton<StrategyType>(
              value: strategyType,
              onChanged: (newStrategyType) {
                setState(() {
                  strategyType = newStrategyType;
                });
              },
              items: StrategyType.values
                  .map<DropdownMenuItem<StrategyType>>((StrategyType value) {
                return DropdownMenuItem<StrategyType>(
                  value: value,
                  child: Text(toSentenceCase(value
                      .toString()
                      .substring(value.toString().indexOf('.') + 1))),
                );
              }).toList(),
            ),
            Text('What strategy do you want to use?'),
            DropdownButton<Strategies>(
              value: stratToOptimize,
              onChanged: (newStrategyType) {
                setState(() {
                  stratToOptimize = newStrategyType;
                });
              },
              items: Strategies.values
                  .map<DropdownMenuItem<Strategies>>((Strategies value) {
                return DropdownMenuItem<Strategies>(
                  value: value,
                  child: Text(optionsIDs[value]),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          RaisedButton(
              onPressed: () {
                widget.strategy.tradeList = optimizeTrade(stratToOptimize,
                    quote: widget.quote,
                    expiryDate: widget.strategy.minExpiryDate);
                // widget.strategy.tradeList = determineBestTrades(
                //   stratToOptimize,
                //   quote: widget.quote,
                //   expiryDate: widget.expiryDate,
                // ); // something is not notifying the listeners here
                widget.strategy.updateStrategyInfo(widget.quote);
                Navigator.pop(context);
              },
              child: Text('Optimize'))
        ],
      );
    });
  }
}
