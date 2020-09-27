import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/widgets/trade_view_elements/trade_view_elements.dart';

import '../dashboard_state.dart';

class TradeItemMobile extends StatelessWidget {
  const TradeItemMobile({
    @required this.context,
    @required this.quote,
    @required this.tradeInformation,
    @required this.strategy,
    @required this.dashboardState,
  });

  final BuildContext context;
  final Quote quote;
  final Strategy strategy;
  final TradeInfo tradeInformation;
  final DashboardState dashboardState;

  @override
  Widget build(BuildContext context) {
    final String optionPrice =
        (tradeInformation.premium ?? 0).toStringAsFixed(2);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              BuyOrSellDropdownButton(
                quote: quote,
                strategy: strategy,
                tradeInformation: tradeInformation,
              ),
              QuantityDropdownButton(
                  tradeInformation: tradeInformation,
                  quote: quote,
                  strategy: strategy),
              TradeTypeDropdownButton(
                  quote: quote,
                  strategy: strategy,
                  tradeInformation: tradeInformation),
              tradeInformation.tradeType == TradeType.stock
                  ? Container()
                  : StrikePriceDropdownButton(
                      quote: quote,
                      strategy: strategy,
                      tradeInformation: tradeInformation,
                    ),
              Expanded(child: Container()),
              tradeInformation.tradeType == TradeType.stock
                  ? Text('at \$ ${quote.stockPrice.toStringAsFixed(2)}')
                  : Container(),
              RemoveTradeFromList(
                  tradeInformation: tradeInformation,
                  strategy: strategy,
                  quote: quote),
            ],
          ),
          tradeInformation.tradeType == TradeType.stock
              ? Container()
              : Row(
                  children: <Widget>[
                    SizedBox(width: 20.0),
                    DateDropdownButton(
                      strategy: strategy,
                      quote: quote,
                      trade: tradeInformation,
                      state: dashboardState,
                    ),
                    Expanded(child: Container()),
                    tradeInformation.customPremium
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    tradeInformation.toggleCustomPremium();
                                    strategy.updateStrategyInfo(quote);
                                    strategy.buildTradeView(
                                        context: context,
                                        quote: quote,
                                        strategy: strategy,
                                        dashboardState: dashboardState);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 24,
                                        color: Colors.indigo,
                                      ),
                                      Text(
                                        'at ¢',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )),
                              Container(
                                height: 24,
                                width: 50,
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (newCustomPremiumValue) {
                                    double newDoubleCustomPremiumValue =
                                        double.parse(newCustomPremiumValue);
                                    tradeInformation.premium =
                                        newDoubleCustomPremiumValue / 100;
                                    strategy.updateStrategyInfo(quote);
                                  },
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () {
                              tradeInformation.toggleCustomPremium();
                              strategy.buildTradeView(
                                  context: context,
                                  quote: quote,
                                  strategy: strategy,
                                  dashboardState: dashboardState);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 24,
                                ),
                                Text(
                                  'at \$ $optionPrice',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                    ExpandTradeInfoButton(
                      quote: quote,
                      strategy: strategy,
                      index: tradeInformation.index,
                    ),
                  ],
                ),
          tradeInformation.expanded
              ? TradeSummaryMobile(
                  quote: quote,
                  strategy: strategy,
                  trade: tradeInformation,
                )
              : Container()
        ],
      ),
    );
  }
}

class TradeItemTablet extends StatelessWidget {
  const TradeItemTablet({
    @required this.context,
    @required this.quote,
    @required this.tradeInformation,
    @required this.strategy,
    @required this.dashboardState,
  });

  final BuildContext context;
  final Quote quote;
  final Strategy strategy;
  final TradeInfo tradeInformation;
  final DashboardState dashboardState;

  @override
  Widget build(BuildContext context) {
    final String optionPrice =
        tradeInformation.premium.toStringAsFixed(2) ?? '-';
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              BuyOrSellDropdownButton(
                quote: quote,
                strategy: strategy,
                tradeInformation: tradeInformation,
              ),
              QuantityDropdownButton(
                  tradeInformation: tradeInformation,
                  quote: quote,
                  strategy: strategy),
              TradeTypeDropdownButton(
                  quote: quote,
                  strategy: strategy,
                  tradeInformation: tradeInformation),
              tradeInformation.tradeType == TradeType.stock
                  ? Container()
                  : StrikePriceDropdownButton(
                      quote: quote,
                      strategy: strategy,
                      tradeInformation: tradeInformation,
                    ),
              tradeInformation.tradeType == TradeType.stock
                  ? Container()
                  : DateDropdownButton(
                      strategy: strategy,
                      quote: quote,
                      trade: tradeInformation,
                      state: dashboardState,
                    ),
              Expanded(child: Container()),
              tradeInformation.tradeType == TradeType.stock
                  ? Text('at \$ ${quote.stockPrice.toStringAsFixed(2)}')
                  : tradeInformation.customPremium
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  tradeInformation.toggleCustomPremium();
                                  strategy.updateStrategyInfo(quote);
                                  strategy.buildTradeView(
                                      context: context,
                                      quote: quote,
                                      strategy: strategy,
                                      dashboardState: dashboardState);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 24,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      'at ¢',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 24,
                              width: 50,
                              child: TextField(
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (newCustomPremiumValue) {
                                  double newDoubleCustomPremiumValue =
                                      double.parse(newCustomPremiumValue);
                                  tradeInformation.premium =
                                      newDoubleCustomPremiumValue / 100;
                                  strategy.updateStrategyInfo(quote);
                                },
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            tradeInformation.toggleCustomPremium();
                            strategy.buildTradeView(
                                context: context,
                                quote: quote,
                                strategy: strategy,
                                dashboardState: dashboardState);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                              ),
                              Text(
                                'at \$ $optionPrice',
                              ),
                            ],
                          ),
                        ),
              tradeInformation.tradeType == TradeType.stock
                  ? Container()
                  : ExpandTradeInfoButton(
                      quote: quote,
                      strategy: strategy,
                      index: tradeInformation.index,
                    ),
              RemoveTradeFromList(
                  tradeInformation: tradeInformation,
                  strategy: strategy,
                  quote: quote),
            ],
          ),
          tradeInformation.tradeType == TradeType.stock
              ? Container()
              : Row(
                  children: <Widget>[],
                ),
          tradeInformation.expanded
              ? TradeSummaryTablet(
                  quote: quote,
                  strategy: strategy,
                  trade: tradeInformation,
                )
              : Container()
        ],
      ),
    );
  }
}
