import 'package:options_dashboard/functions/distribution.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

optimizeTrade(
  Strategies currentStrategy, {
  Quote quote,
  DateTime expiryDate,
}) {
  var range = quote.confidenceInterval[expiryDate];
  var _stepWidth = (range[1] - range[0]) / 20;

  List<TradeInfo> bestStrategyTradeList;
  if (strats[currentStrategy].length == 1) {
    double tradeTally;
    double bestStrategyReturn;
    Map chain1 = strats[currentStrategy].first.tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    chain1.forEach((strike, value) {
      List<TradeInfo> tradeList = [
        TradeInfo(
          expiryDate: expiryDate,
          strikePrice: strike,
          bid: value['bid'],
          ask: value['ask'],
          lastPrice: value['lastPrice'],
          tradeType: strats[currentStrategy].first.tradeType,
          buyOrSell: strats[currentStrategy].first.buyOrSell,
          quantity: strats[currentStrategy].first.quantity,
        )
      ];
      tradeList.first
          .updatePremiums(optionsChain: quote.optionsChains, useBidAsk: false);
      for (double point = range[0]; point < range[1]; point += _stepWidth) {
        tradeTally = determinePointValue(
            tradeList, point, quote, expiryDate, _stepWidth);
      }
      if (bestStrategyReturn == null) {
        bestStrategyReturn = tradeTally;
        bestStrategyTradeList = tradeList;
      } else if (tradeTally > bestStrategyReturn) {
        bestStrategyReturn = tradeTally;
        bestStrategyTradeList = tradeList;
      }
    });
  } else if (strats[currentStrategy].length == 2) {
    double tradeTally;
    double bestStrategyReturn;
    Map chain1 = strats[currentStrategy][0].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain2 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];

    bool sameStrike;
    if (currentStrategy == Strategies.shortStaddle ||
        currentStrategy == Strategies.longStraddle) {
      sameStrike = true;
    } else {
      sameStrike = false;
    }

    for (double strike1 in chain1.keys) {
      for (double strike2 in chain2.keys) {
        if (sameStrike ? strike1 == strike2 : strike2 > strike1) {
          List<TradeInfo> tradeList = [
            TradeInfo(
              expiryDate: expiryDate,
              strikePrice:
                  strats[currentStrategy][0].tradeType != TradeType.stock
                      ? strike1
                      : quote.stockPrice,
              bid: chain1[strike1]['bid'],
              ask: chain1[strike1]['ask'],
              lastPrice: chain1[strike1]['lastPrice'],
              tradeType: strats[currentStrategy][0].tradeType,
              buyOrSell: strats[currentStrategy][0].buyOrSell,
              quantity: strats[currentStrategy][0].quantity,
            ),
            TradeInfo(
              expiryDate: expiryDate,
              strikePrice: strike2,
              bid: chain1[strike2]['bid'],
              ask: chain1[strike2]['ask'],
              lastPrice: chain1[strike2]['lastPrice'],
              tradeType: strats[currentStrategy][1].tradeType,
              buyOrSell: strats[currentStrategy][1].buyOrSell,
              quantity: strats[currentStrategy][1].quantity,
            )
          ];
          tradeList.forEach((trade) {
            if (trade.tradeType != TradeType.stock) {
              trade.updatePremiums(
                  optionsChain: quote.optionsChains, useBidAsk: false);
            } else {
              trade.premium = 0;
            }
          });
          for (double point = range[0]; point < range[1]; point += _stepWidth) {
            tradeTally = determinePointValue(
                tradeList, point, quote, expiryDate, _stepWidth);
          }
          if (bestStrategyReturn == null) {
            bestStrategyReturn = tradeTally;
            bestStrategyTradeList = tradeList;
          } else if (tradeTally > bestStrategyReturn) {
            bestStrategyReturn = tradeTally;
            bestStrategyTradeList = tradeList;
          }
        }
      }
    }
  } else if (strats[currentStrategy].length == 3) {
    double tradeTally;
    double bestStrategyReturn;
    Map chain1 = strats[currentStrategy][0].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain2 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain3 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    for (double strike1 in chain1.keys) {
      for (double strike2 in chain2.keys) {
        for (double strike3 in chain3.keys) {
          if (strike3 > strike2 && strike2 > strike1) {
            List<TradeInfo> tradeList = [
              TradeInfo(
                expiryDate: expiryDate,
                strikePrice:
                    strats[currentStrategy][0].tradeType != TradeType.stock
                        ? strike1
                        : quote.stockPrice,
                bid: chain1[strike1]['bid'],
                ask: chain1[strike1]['ask'],
                lastPrice: chain1[strike1]['lastPrice'],
                tradeType: strats[currentStrategy][0].tradeType,
                buyOrSell: strats[currentStrategy][0].buyOrSell,
                quantity: strats[currentStrategy][0].quantity,
              ),
              TradeInfo(
                expiryDate: expiryDate,
                strikePrice: strike2,
                bid: chain1[strike2]['bid'],
                ask: chain1[strike2]['ask'],
                lastPrice: chain1[strike2]['lastPrice'],
                tradeType: strats[currentStrategy][1].tradeType,
                buyOrSell: strats[currentStrategy][1].buyOrSell,
                quantity: strats[currentStrategy][1].quantity,
              ),
              TradeInfo(
                expiryDate: expiryDate,
                strikePrice: strike3,
                bid: chain1[strike3]['bid'],
                ask: chain1[strike3]['ask'],
                lastPrice: chain1[strike3]['lastPrice'],
                tradeType: strats[currentStrategy][2].tradeType,
                buyOrSell: strats[currentStrategy][2].buyOrSell,
                quantity: strats[currentStrategy][2].quantity,
              )
            ];
            tradeList.forEach((trade) {
              if (trade.tradeType != TradeType.stock) {
                trade.updatePremiums(
                    optionsChain: quote.optionsChains, useBidAsk: false);
              } else {
                trade.premium = 0;
              }
            });
            for (double point = range[0];
                point < range[1];
                point += _stepWidth) {
              tradeTally = determinePointValue(
                  tradeList, point, quote, expiryDate, _stepWidth);
            }
            if (bestStrategyReturn == null) {
              bestStrategyReturn = tradeTally;
              bestStrategyTradeList = tradeList;
            } else if (tradeTally > bestStrategyReturn) {
              bestStrategyReturn = tradeTally;
              bestStrategyTradeList = tradeList;
            }
          }
        }
      }
    }
  } else {
    double tradeTally;
    double bestStrategyReturn;
    Map chain1 = strats[currentStrategy][0].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain2 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain3 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    Map chain4 = strats[currentStrategy][1].tradeType == TradeType.call
        ? quote.optionsChains[expiryDate][0]
        : quote.optionsChains[expiryDate][1];
    for (double strike1 in chain1.keys) {
      for (double strike2 in chain2.keys) {
        for (double strike3 in chain3.keys) {
          for (double strike4 in chain4.keys) {
            if (strike4 > strike3 && strike3 > strike2 && strike2 > strike1) {
              List<TradeInfo> tradeList = [
                TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice:
                      strats[currentStrategy][0].tradeType != TradeType.stock
                          ? strike1
                          : quote.stockPrice,
                  bid: chain1[strike1]['bid'],
                  ask: chain1[strike1]['ask'],
                  lastPrice: chain1[strike1]['lastPrice'],
                  tradeType: strats[currentStrategy][0].tradeType,
                  buyOrSell: strats[currentStrategy][0].buyOrSell,
                  quantity: strats[currentStrategy][0].quantity,
                ),
                TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice: strike2,
                  bid: chain1[strike2]['bid'],
                  ask: chain1[strike2]['ask'],
                  lastPrice: chain1[strike2]['lastPrice'],
                  tradeType: strats[currentStrategy][1].tradeType,
                  buyOrSell: strats[currentStrategy][1].buyOrSell,
                  quantity: strats[currentStrategy][1].quantity,
                ),
                TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice: strike3,
                  bid: chain1[strike3]['bid'],
                  ask: chain1[strike3]['ask'],
                  lastPrice: chain1[strike3]['lastPrice'],
                  tradeType: strats[currentStrategy][2].tradeType,
                  buyOrSell: strats[currentStrategy][2].buyOrSell,
                  quantity: strats[currentStrategy][2].quantity,
                ),
                TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice: strike4,
                  bid: chain1[strike4]['bid'],
                  ask: chain1[strike4]['ask'],
                  lastPrice: chain1[strike4]['lastPrice'],
                  tradeType: strats[currentStrategy][3].tradeType,
                  buyOrSell: strats[currentStrategy][3].buyOrSell,
                  quantity: strats[currentStrategy][3].quantity,
                )
              ];
              tradeList.forEach((trade) {
                if (trade.tradeType != TradeType.stock) {
                  trade.updatePremiums(
                      optionsChain: quote.optionsChains, useBidAsk: false);
                } else {
                  trade.premium = 0;
                }
              });
              for (double point = range[0];
                  point < range[1];
                  point += _stepWidth) {
                tradeTally = determinePointValue(
                    tradeList, point, quote, expiryDate, _stepWidth);
              }
              if (bestStrategyReturn == null) {
                bestStrategyReturn = tradeTally;
                bestStrategyTradeList = tradeList;
              } else if (tradeTally > bestStrategyReturn) {
                bestStrategyReturn = tradeTally;
                bestStrategyTradeList = tradeList;
              }
            }
          }
        }
      }
    }
  }
  return bestStrategyTradeList;
}

double determinePointValue(List<TradeInfo> tradeList, double stockPrice,
    Quote quote, DateTime date, double stepWidth) {
  double tradeTally = 0;
  tradeList.forEach((trade) {
    double pointValue = trade.tradeValue(
        stockPrice: stockPrice,
        volatility: quote.impliedVolatility[date],
        interest: quote.interest,
        onDate: date);
    double pdfAt = logNormPDF(
        stockPrice: quote.stockPrice,
        position: stockPrice,
        volatility: quote.impliedVolatility[tradeList[0].expiryDate],
        expiryDate: date);
    tradeTally += pointValue * pdfAt * stepWidth;
  });
  return tradeTally;
}

Map<Strategies, List<TradeInfo>> strats = {
  Strategies.longCall: [
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.coveredCall: [
    TradeInfo(
      tradeType: TradeType.stock,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.protectivePut: [
    TradeInfo(
      tradeType: TradeType.stock,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.cashSecuredPut: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.bullCallSpread: [
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.bullPutSpread: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.bearCallSpread: [
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.bearPutSpread: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.collar: [
    TradeInfo(
      tradeType: TradeType.stock,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.shortStrangle: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.shortStaddle: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.longStrangle: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.longStraddle: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.longCallButterfly: [
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 200,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
  Strategies.ironCondor: [
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.put,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.sell,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    ),
    TradeInfo(
      tradeType: TradeType.call,
      buyOrSell: BuyOrSell.buy,
      quantity: 100,
      expiryDate: null,
      strikePrice: null,
    )
  ],
};
