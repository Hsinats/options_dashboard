import 'package:flutter/material.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/graphs/return_chart.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

import '../dashboard.dart';
import '../dashboard_state.dart';
import '../responsive.dart';

class DashboardTabMobile extends StatelessWidget {
  DashboardTabMobile({
    @required this.quote,
    @required this.returnChart,
    @required this.strategy,
    @required this.state,
    @required this.passedStrategy,
  });

  final Quote quote;
  final Widget returnChart;
  final Strategy strategy;
  final DashboardState state;
  final Strategies passedStrategy;
  @override
  Widget build(BuildContext context) {
    List<Widget> tradeList = [];
    if (quote.hasOptions && !state.analytics) {
      strategy.tradeList.forEach((trade) {
        tradeList.add(Responsive(
          mobile: TradeItemMobile(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
          tablet: TradeItemTablet(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
          desktop: TradeItemTablet(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
        ));
        tradeList.add(Divider());
      });
      tradeList.add(
        AddTradeToRow(strategy: strategy, quote: quote),
      );
    }
    return quote.hasOptions
        ? ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
                DashboardHeader(
                  quote: quote,
                  context: context,
                ),
                TradeListHeader(
                  context,
                  strategy: strategy,
                  quote: quote,
                  state: state,
                  passedStrategy: passedStrategy,
                ),
                PayoffChart(strategy, quote),
                // ReturnChart(stockPrice: quote.stockPrice, strategy: strategy),
                DataHeader(
                  'Strategy Summary',
                  action: InkWell(
                    onTap: () {
                      state.toggleAnalytics();
                    },
                    child: state.analytics
                        ? Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 24,
                              ),
                              Text(
                                ' Trade list',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.assessment,
                                size: 24,
                              ),
                              Text(
                                ' Returns',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                  ),
                ),
                state.analytics
                    ? StrategySliders(
                        strategy: strategy, state: state, quote: quote)
                    : Column(children: [
                        DashboardStrategySummaryMobile(
                          strategy: strategy,
                          quote: quote,
                        ),
                        DataHeader(
                          'Trade List',
                          action: InkWell(
                            onTap: () {
                              strategy.toggleUseBidAsk();
                              strategy.updateStrategyInfo(quote);
                            },
                            child: Row(
                              children: [
                                strategy.useBidAsk
                                    ? Icon(Icons.radio_button_checked)
                                    : Icon(Icons.radio_button_unchecked),
                                Text(
                                  ' Mid price',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ...tradeList
                      ]),
              ])
        : Center(
            child: Text(
              'Unable to find options associated with this security',
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          );
  }
}

class DashboardTabTablet extends StatelessWidget {
  DashboardTabTablet({
    @required this.quote,
    @required this.returnChart,
    @required this.strategy,
    @required this.state,
    @required this.passedStrategy,
  });

  final Quote quote;
  final Widget returnChart;
  final Strategy strategy;
  final DashboardState state;
  final Strategies passedStrategy;
  @override
  Widget build(BuildContext context) {
    List<Widget> tradeList = [];
    if (quote.hasOptions && !state.analytics) {
      strategy.tradeList.forEach((trade) {
        tradeList.add(Responsive(
          mobile: TradeItemMobile(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
          tablet: TradeItemTablet(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
          desktop: TradeItemTablet(
              context: context,
              quote: quote,
              tradeInformation: trade,
              strategy: strategy,
              dashboardState: state),
        ));
        tradeList.add(Divider());
      });
      tradeList.add(
        AddTradeToRow(strategy: strategy, quote: quote),
      );
    }
    return quote.hasOptions
        ? ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
                DashboardHeader(
                  quote: quote,
                  context: context,
                ),
                TradeListHeader(
                  context,
                  strategy: strategy,
                  quote: quote,
                  state: state,
                  passedStrategy: passedStrategy,
                ),
                PayoffChart(strategy, quote),
                // ReturnChart(stockPrice: quote.stockPrice, strategy: strategy),
                DataHeader(
                  'Strategy Summary',
                  action: InkWell(
                    onTap: () {
                      state.toggleAnalytics();
                    },
                    child: state.analytics
                        ? Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 24,
                              ),
                              Text(
                                ' Trade list',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.assessment,
                                size: 24,
                              ),
                              Text(
                                ' Returns',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                  ),
                ),
                state.analytics
                    ? StrategySliders(
                        strategy: strategy, state: state, quote: quote)
                    : Column(children: [
                        DashboardStrategySummaryMobile(
                          strategy: strategy,
                          quote: quote,
                        ),
                        DataHeader(
                          'Trade List',
                          action: InkWell(
                            onTap: () {
                              strategy.toggleUseBidAsk();
                              strategy.updateStrategyInfo(quote);
                            },
                            child: Row(
                              children: [
                                strategy.useBidAsk
                                    ? Icon(Icons.radio_button_checked)
                                    : Icon(Icons.radio_button_unchecked),
                                Text(
                                  ' Mid price',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ...tradeList
                      ]),
              ])
        : Center(
            child: Text(
              'Unable to find options associated with this security',
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          );
  }
}
