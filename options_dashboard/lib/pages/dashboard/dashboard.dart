import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/graphs/return_chart.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';
import 'package:options_dashboard/services/optimize_trade.dart';
import 'package:options_dashboard/services/symbol_search.dart';
import 'package:options_dashboard/utils/database.dart';
import 'package:options_dashboard/widgets/drawer.dart';
import 'package:provider/provider.dart';

import 'dashboard_state.dart';
import 'responsive.dart';

class Dashboard extends StatelessWidget {
  Dashboard({
    this.symbol,
    this.passedStrategy,
    Key key,
  }) : super(key: key);
  final symbolInputController = TextEditingController();
  final String symbol;
  final Strategies passedStrategy;

  @override
  Widget build(BuildContext context) {
    final dashboardState = Provider.of<DashboardState>(context);
    final quote = Provider.of<Quote>(context);
    final strategy = Provider.of<Strategy>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(200),
        title: Text('The Dashboard'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                Company searchedCompany = await showSearch(
                  context: context,
                  delegate: CompanySymbolSearch(),
                );
                if (searchedCompany != null) {
                  quote.setCompany(searchedCompany);
                  searchCompany(quote, strategy, dashboardState, context);
                }
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          dashboardState.lookingUpSymbol
              ? LinearProgressIndicator()
              : Container(),
          dashboardState.error
              ? Text('ERROR: ${quote.errorMessage}!')
              : dashboardState.hasData
                  ? Expanded(
                      child: PageView(
                        controller: dashboardState.tabController,
                        onPageChanged: (newIndex) {
                          dashboardState.bottomNavBarPress(newIndex);
                        },
                        // index: dashboardState.bottomNavBarIndex,
                        children: [
                          _DashboardTab(
                            state: dashboardState,
                            strategy: strategy,
                            quote: quote,
                            returnChart: ReturnChart(
                                stockPrice: quote.stockPrice,
                                strategy: strategy),
                            passedStrategy: passedStrategy,
                          ),
                          Responsive(
                            mobile: RiskTabMobile(
                              quote: quote,
                              strategy: strategy,
                              state: dashboardState,
                            ),
                            tablet: RiskTabTablet(
                              quote: quote,
                              strategy: strategy,
                              state: dashboardState,
                            ),
                            desktop: RiskTabTablet(
                              quote: quote,
                              strategy: strategy,
                              state: dashboardState,
                            ),
                          ),
                          OptionsChain(
                            quote,
                            dashboardState.ocExpiryDate,
                            strategy,
                            dashboardState,
                          ),
                        ],
                      ),
                    )
                  : SearchHistoryTable(
                      quote, strategy, dashboardState, context),
        ],
      ),
      bottomNavigationBar: dashboardState.hasData
          ? BottomNavigationBar(
              unselectedItemColor: Colors.black54,
              showUnselectedLabels: true,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  title: Text('Strategy'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.warning),
                  title: Text(
                    'Risk\nManagment',
                    textAlign: TextAlign.center,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.link),
                  title: Text(
                    'Options\nChain',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              currentIndex: dashboardState.bottomNavBarIndex,
              onTap: (int newIndex) {
                print(newIndex);
                dashboardState.bottomNavBarPress(newIndex);
              },
              // currentIndex: dashboardState.tabController.page.toInt(),
              selectedItemColor: Colors.indigo[700],
            )
          : null,
      drawer: Drawer(
        child: DrawerItems(),
      ),
    );
  }
}

class SearchHistoryTable extends StatelessWidget {
  SearchHistoryTable(
      this.quote, this.strategy, this.dashboardState, this.buildContext);

  TableRow _popularTableRow(String symbol, String name) {
    return TableRow(children: [
      InkWell(
        onTap: () {
          quote.setCompany(Company(name, symbol));
          searchCompany(
            quote,
            strategy,
            dashboardState,
            buildContext,
          );
        },
        child: Container(
            padding: const EdgeInsets.all(4),
            child: Text(symbol.toUpperCase())),
      ),
      InkWell(
        onTap: () {
          quote.setCompany(Company(name, symbol));
          searchCompany(
            quote,
            strategy,
            dashboardState,
            buildContext,
          );
        },
        child: Text(name),
      )
    ]);
  }

  final Quote quote;
  final Strategy strategy;
  final DashboardState dashboardState;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        FutureBuilder(
            future: DBProvider.db.getSearchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<TableRow> historyRows = [];
                if (snapshot.data != null) {
                  List<Map> searchHistoryData = snapshot.data;
                  List<SearchHistory> historyList = [];
                  searchHistoryData.forEach((element) {
                    historyList.add(SearchHistory(
                        element['ticker'], element['name'], element['date']));
                  });
                  historyList.sort((a, b) => b.date.compareTo(a.date));
                  for (int i = 0; i < min(10, historyList.length); i++) {
                    historyRows.add(_popularTableRow(
                        historyList[i].ticker, historyList[i].name));
                  }
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    historyRows.isNotEmpty
                        ? DataHeader('Search History')
                        : Container(),
                    historyRows.isNotEmpty
                        ? Table(
                            columnWidths: {
                              0: FlexColumnWidth(1.5),
                              1: FlexColumnWidth(3)
                            },
                            children: historyRows,
                          )
                        : Container(),
                  ],
                );
              } else {
                return LinearProgressIndicator();
              }
            }),
        DataHeader('Popular Tickers'),
        Table(
          columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(3)},
          children: [
            _popularTableRow('aal', 'American Airlines Gp'),
            _popularTableRow('aapl', 'Apple Inc.'),
            _popularTableRow('ge', 'General Electric Company'),
            _popularTableRow('msft', 'Microsoft Corp'),
            _popularTableRow('qqq', 'Investco QQQ Trust'),
            _popularTableRow('spy', 'SPDR S&P 500 ETF Trust'),
            _popularTableRow('tsla', 'Tesla, Inc. Inc.'),
            _popularTableRow('xom', 'Exxon Mobil Corp'),
          ],
        )
      ],
    ));
  }
}

// class _FundamentalsTab extends StatelessWidget {
//   _FundamentalsTab({
//     @required this.stockHistory,
//     @required this.quote,
//   });

//   final StockHistory stockHistory;
//   final Quote quote;
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       children: [
//         DashboardHeader(
//           quote: quote,
//           context: context,
//         ),
//         DataHeader('Stock History'),
//         StockHistoryChart(stockHistory),
//         DataHeader('Fundamentals'),
//         Fundamentals(
//           dividendDate: quote.dividendDate,
//           dividendYield: quote.dividendYield,
//           dividendRate: quote.dividendRate,
//           yearRange: quote.yearRange,
//           marketCap: quote.marketCap,
//           peRatio: quote.peRatio,
//           averageVolume: quote.averageVolume,
//           quote: quote,
//         ),
//       ],
//     );
//   }
// }

class DataHeader extends StatelessWidget {
  const DataHeader(
    this.title, {
    this.action,
    Key key,
  }) : super(key: key);
  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Color(0xff000066),
        ),
        Container(
          height: 32,
          child: Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headline2),
              Expanded(child: Container()),
              action != null ? action : Container(),
            ],
          ),
        ),
        Divider(
          color: Color(0xff000066),
        ),
      ],
    );
  }
}

class _DashboardTab extends StatelessWidget {
  _DashboardTab({
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
                        Responsive(
                          mobile: DashboardStrategySummaryMobile(
                            strategy: strategy,
                            quote: quote,
                          ),
                          tablet: DashboardStrategySummaryTablet(
                            strategy: strategy,
                            quote: quote,
                          ),
                          desktop: DashboardStrategySummaryTablet(
                            strategy: strategy,
                            quote: quote,
                          ),
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

class StrategySliders extends StatelessWidget {
  const StrategySliders({
    Key key,
    @required this.strategy,
    @required this.state,
    @required this.quote,
  }) : super(key: key);

  final Strategy strategy;
  final DashboardState state;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final onDay = DateFormat('yyyy-MMM-dd').format(strategy.thetaDate);
    final atTime = DateFormat('HH:mm').format(strategy.thetaDate);
    final dte =
        (strategy.minExpiryDate.difference(strategy.thetaDate).inHours / 24)
            .toStringAsFixed(1);
    double expiryValue = 0;
    strategy.tradeList.forEach((trade) {
      expiryValue += trade.tradeValue(
          stockPrice: strategy.customStockPrice,
          volatility: quote.impliedVolatility[strategy.minExpiryDate],
          interest: quote.interest,
          onDate: strategy.minExpiryDate,
          premiums: false);
    });
    final double valueRemaining =
        expiryValue - strategy.valueAtCustomDateAndInterest;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('At \$${strategy.customStockPrice.toStringAsFixed(2)}'),
            InkWell(
              onTap: () {
                strategy.updateCustomStockPrice(quote.stockPrice);
                strategy.getDateStrategyValue(
                  range: quote.confidenceInterval,
                  interest: quote.interest,
                  quote: quote,
                );
              },
              child: Text('Reset price'),
            ),
            // Text('probability: '),
          ],
        ),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: strategy.customStockPrice,
          max: quote.confidenceInterval[strategy.minExpiryDate][1],
          min: quote.confidenceInterval[strategy.minExpiryDate][0],
          onChanged: (double newCustomStockPrice) {
            strategy.updateCustomStockPrice(newCustomStockPrice);
            strategy.getDateStrategyValue(
              range: quote.confidenceInterval,
              interest: quote.interest,
              quote: quote,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('On $onDay at $atTime'),
            Text('DTE: $dte'),
          ],
        ),
        Slider(
            activeColor: Theme.of(context).primaryColor,
            value: strategy.thetaDate.millisecondsSinceEpoch.toDouble(),
            min: state.sliderStart.millisecondsSinceEpoch.toDouble(),
            max: strategy.minExpiryDate.millisecondsSinceEpoch.toDouble(),
            onChanged: (double newThetaDate) {
              strategy.updateThetaDate(
                  DateTime.fromMillisecondsSinceEpoch(newThetaDate ~/ 1));
              strategy.getDateStrategyValue(
                range: quote.confidenceInterval,
                interest: quote.interest,
                quote: quote,
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('I.V.: ${strategy.volSliderValue.toStringAsFixed(4)}'),
            InkWell(
              onTap: () {
                strategy.setVolSliderValue(
                    quote.impliedVolatility[strategy.minExpiryDate]);
                strategy.getDateStrategyValue(
                  range: quote.confidenceInterval,
                  interest: quote.interest,
                  quote: quote,
                );
              },
              child: Text('Reset I.V.'),
            ),
          ],
        ),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: strategy.volSliderValue,
          min: 0,
          max: strategy.volSliderMax,
          onChanged: (double newVolSliderValue) {
            strategy.setVolSliderValue(newVolSliderValue);
            strategy.getDateStrategyValue(
              range: quote.confidenceInterval,
              interest: quote.interest,
              quote: quote,
            );
          },
        ),
        Divider(),
        Table(
          children: [
            TableRow(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Present value')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '\$${(strategy.currentValue + strategy.totalPremiums).toStringAsFixed(2)}')),
            ]),
            TableRow(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Value at custom')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '\$${(strategy.valueAtCustomDateAndInterest + strategy.totalPremiums).toStringAsFixed(2)}')),
            ]),
            TableRow(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Value holding to expiry')),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('\$${valueRemaining.toStringAsFixed(2)}')),
            ]),
          ],
        ),
        Divider()
      ],
    );
  }
}

searchCompany(
  Quote quote,
  Strategy strategy,
  DashboardState dashboardState,
  BuildContext context,
) async {
  dashboardState.toggleLookingUpSymbol();
  await quote.getQuote(true);
  if (!quote.error) {
    // await stockHistory.getStockHistory(quote.symbol);
    dashboardState.setErrorFalse();
    // if (!stockHistory.error) {
    dashboardState.setHasDataTrue();
    FocusScope.of(context).unfocus();
    if (quote.hasOptions) {
      dashboardState.setOCExpiryDate(quote.defaultExpirationDate);
      strategy.initialize(
        trade: TradeInfo(
          expiryDate: quote.defaultExpirationDate,
          strikePrice: quote.defaultStrikePrice[quote.defaultExpirationDate],
          bid: quote.optionsChains[quote.defaultExpirationDate][0]
              [quote.defaultStrikePrice[quote.defaultExpirationDate]]['bid'],
          ask: quote.optionsChains[quote.defaultExpirationDate][0]
              [quote.defaultStrikePrice[quote.defaultExpirationDate]]['ask'],
          lastPrice: quote.optionsChains[quote.defaultExpirationDate][0]
                  [quote.defaultStrikePrice[quote.defaultExpirationDate]]
              ['lastPrice'],
          impliedVolatility: quote.optionsChains[quote.defaultExpirationDate][0]
                  [quote.defaultStrikePrice[quote.defaultExpirationDate]]
              ['impliedVolatility'],
        ),
      );
      strategy.initializeSliders(quote);
      strategy.updateStrategyInfo(quote);
      strategy.updateThetaDate(DateTime.now());
      strategy.setVolSliderValue(
          quote.impliedVolatility[quote.defaultExpirationDate],
          setNewMax: true);
      dashboardState.setOCExpiryDate(quote.defaultExpirationDate);
    }
    dashboardState.toggleSearching();
    // } else {
    //   dashboardState.setErrorTrue();
    //   dashboardState.setHasDataFalse();
    // }
  } else {
    dashboardState.setErrorTrue();
    dashboardState.setHasDataFalse();
  }
  dashboardState.toggleLookingUpSymbol();
}
