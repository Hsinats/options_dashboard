import 'package:meta/meta.dart';
import 'package:options_dashboard/functions/distribution.dart';
import 'package:options_dashboard/models/data_structures.dart';

determineBestTrades(
  Strategies currentStrategy, {
  Quote quote,
  DateTime expiryDate,
}) {
  List<TradeInfo> bestTradeList;
  if (singleOptionStrategies.keys.contains(currentStrategy)) {
    bestTradeList = determineBestSingleOptionsPlay(
        quote: quote,
        expiryDate: expiryDate,
        range: quote.confidenceInterval[expiryDate],
        tradeType: singleOptionStrategies[currentStrategy]['tradeType'],
        buyOrSell: singleOptionStrategies[currentStrategy]['buyOrSell'],
        quantity: singleOptionStrategies[currentStrategy]['quantity'],
        stock: singleOptionStrategies[currentStrategy]['stock'],
        buyOrSellStock: singleOptionStrategies[currentStrategy]
            ['buyOrSellStock']);
  } else if (doubleOptionStrategies.keys.contains(currentStrategy)) {
    bestTradeList = determineBestDoubleOptionsPlay(
        quote: quote,
        expiryDate: expiryDate,
        range: quote.confidenceInterval[expiryDate],
        tradeTypeOne: doubleOptionStrategies[currentStrategy]['tradeTypeOne'],
        buyOrSellOne: doubleOptionStrategies[currentStrategy]['buyOrSellOne'],
        quantityOne: doubleOptionStrategies[currentStrategy]['quantityOne'],
        tradeTypeTwo: doubleOptionStrategies[currentStrategy]['tradeTypeTwo'],
        buyOrSellTwo: doubleOptionStrategies[currentStrategy]['buyOrSellTwo'],
        quantityTwo: doubleOptionStrategies[currentStrategy]['quantityTwo'],
        stock: doubleOptionStrategies[currentStrategy]['stock'],
        buyOrSellStock: doubleOptionStrategies[currentStrategy]
            ['buyOrSellStock']);
  } else if (trippleOptionStregies.keys.contains(currentStrategy)) {
    bestTradeList = determineBestTrippleOptionsPlay(
        quote: quote,
        expiryDate: expiryDate,
        range: quote.confidenceInterval[expiryDate],
        tradeTypeOne: trippleOptionStregies[currentStrategy]['tradeTypeOne'],
        buyOrSellOne: trippleOptionStregies[currentStrategy]['buyOrSellOne'],
        quantityOne: trippleOptionStregies[currentStrategy]['quantityOne'],
        tradeTypeTwo: trippleOptionStregies[currentStrategy]['tradeTypeTwo'],
        buyOrSellTwo: trippleOptionStregies[currentStrategy]['buyOrSellTwo'],
        quantityTwo: trippleOptionStregies[currentStrategy]['quantityTwo'],
        tradeTypeThree: trippleOptionStregies[currentStrategy]
            ['tradeTypeThree'],
        buyOrSellThree: trippleOptionStregies[currentStrategy]
            ['buyOrSellThree'],
        quantityThree: trippleOptionStregies[currentStrategy]['quantityThree'],
        stock: doubleOptionStrategies[currentStrategy]['stock'],
        buyOrSellStock: doubleOptionStrategies[currentStrategy]
            ['buyOrSellStock']);
  }
  return bestTradeList;
}

determineBestSingleOptionsPlay({
  @required Quote quote,
  @required DateTime expiryDate,
  @required List<double> range,
  @required TradeType tradeType,
  @required BuyOrSell buyOrSell,
  int quantity = 100,
  bool stock = false,
  BuyOrSell buyOrSellStock,
  int quantityStock = 100,
}) {
  double stratValueTally;
  double bestStrategyReturn;
  List<TradeInfo> bestStrategyTradeList;
  double _stepWidth = (range[1] - range[0]) / 50;
  Map otpionChain = tradeType == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];
  otpionChain.forEach((strike, value) {
    List<TradeInfo> tradeList = [];
    if (stock) {
      tradeList.add(TradeInfo(
          expiryDate: expiryDate,
          strikePrice: quote.stockPrice,
          tradeType: TradeType.stock,
          buyOrSell: buyOrSellStock,
          quantity: quantity));
    }
    tradeList.add(TradeInfo(
      expiryDate: expiryDate,
      strikePrice: strike,
      bid: value['bid'],
      ask: value['ask'],
      lastPrice: value['lastPrice'],
      tradeType: tradeType,
      buyOrSell: buyOrSell,
      quantity: quantity,
    ));
    tradeList.forEach((trade) {
      if (trade.tradeType != TradeType.stock) {
        if (trade.buyOrSell == BuyOrSell.buy) {
          trade.premium = trade.ask != 0 ? trade.ask : trade.lastPrice;
        } else {
          trade.premium = trade.bid != 0 ? trade.bid : trade.lastPrice;
        }
      }
    });
    for (double point = range[0]; point < range[1]; point += _stepWidth) {
      double pointValue = 0, _pdfAt;
      stratValueTally = 0;
      tradeList.forEach((trade) {
        pointValue += trade.tradeValue(
          stockPrice: point,
          volatility: quote.impliedVolatility[trade.expiryDate],
          interest: quote.interest,
          onDate: trade.expiryDate,
        );
      });
      _pdfAt = logNormPDF(
          stockPrice: quote.stockPrice,
          position: point,
          volatility: quote.impliedVolatility[tradeList[0].expiryDate],
          expiryDate: expiryDate);
      stratValueTally += pointValue * _pdfAt * _stepWidth;
    }
    if (bestStrategyReturn == null) {
      bestStrategyReturn = stratValueTally;
      bestStrategyTradeList = tradeList;
    } else if (stratValueTally > bestStrategyReturn) {
      bestStrategyReturn = stratValueTally;
      bestStrategyTradeList = tradeList;
    }
  });
  for (int i = 0; i < bestStrategyTradeList.length; i++) {
    bestStrategyTradeList[i].index = i;
  }
  return bestStrategyTradeList;
}

determineBestDoubleOptionsPlay({
  @required Quote quote,
  @required DateTime expiryDate,
  @required List<double> range,
  @required TradeType tradeTypeOne,
  @required BuyOrSell buyOrSellOne,
  @required int quantityOne,
  @required TradeType tradeTypeTwo,
  @required BuyOrSell buyOrSellTwo,
  @required int quantityTwo,
  bool stock = false,
  BuyOrSell buyOrSellStock,
  int quantityStock = 100,
}) {
  double bestStrategyReturn, stratValueTally;
  List<TradeInfo> bestStrategyTradeList;
  double _stepWidth = (range[1] - range[0]) / 20;
  Map optionChainOne = tradeTypeOne == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];
  Map optionChainTwo = tradeTypeTwo == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];

  for (double stockPriceOne in optionChainOne.keys) {
    for (double stockPriceTwo in optionChainTwo.keys) {
      if (stockPriceTwo >= stockPriceOne) {
        List<TradeInfo> tradeList = stock
            ? [
                TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice: quote.stockPrice,
                  tradeType: TradeType.stock,
                  buyOrSell: buyOrSellStock,
                  quantity: quantityStock,
                )
              ]
            : [];
        tradeList.add(TradeInfo(
          expiryDate: expiryDate,
          strikePrice: stockPriceOne,
          premium: optionChainOne[stockPriceOne]['ask'] != 0
              ? optionChainOne[stockPriceOne]['ask']
              : optionChainOne[stockPriceOne]['lastPrice'],
          tradeType: tradeTypeOne,
          buyOrSell: buyOrSellOne,
          quantity: quantityOne,
        ));
        tradeList.add(TradeInfo(
          expiryDate: expiryDate,
          strikePrice: stockPriceTwo,
          premium: optionChainTwo[stockPriceTwo]['ask'] != 0
              ? optionChainTwo[stockPriceTwo]['ask']
              : optionChainTwo[stockPriceTwo]['lastPrice'],
          tradeType: tradeTypeTwo,
          buyOrSell: buyOrSellTwo,
          quantity: quantityTwo,
        ));
        double pointValue = 0;
        for (double point = range[0]; point < range[1]; point += _stepWidth) {
          double _pdfAt;
          stratValueTally = 0;
          tradeList.forEach((trade) {
            pointValue += trade.tradeValue(
              stockPrice: point,
              volatility: quote.impliedVolatility[trade.expiryDate],
              interest: quote.interest,
              onDate: trade.expiryDate,
            );
          });
          _pdfAt = logNormPDF(
              stockPrice: quote.stockPrice,
              position: point,
              volatility: quote.impliedVolatility[tradeList[0].expiryDate],
              expiryDate: expiryDate);
          stratValueTally += pointValue * _pdfAt * _stepWidth;
        }
        if (bestStrategyReturn == null) {
          bestStrategyReturn = stratValueTally;
          bestStrategyTradeList = tradeList;
        } else if (stratValueTally > bestStrategyReturn) {
          bestStrategyReturn = stratValueTally;
          bestStrategyTradeList = tradeList;
        }
      }
    }
  }
  for (int i = 0; i < bestStrategyTradeList.length; i++) {
    bestStrategyTradeList[i].index = i;
  }
  return bestStrategyTradeList;
}

determineBestTrippleOptionsPlay({
  @required Quote quote,
  @required DateTime expiryDate,
  @required List<double> range,
  @required TradeType tradeTypeOne,
  @required BuyOrSell buyOrSellOne,
  @required int quantityOne,
  @required TradeType tradeTypeTwo,
  @required BuyOrSell buyOrSellTwo,
  @required int quantityTwo,
  @required TradeType tradeTypeThree,
  @required BuyOrSell buyOrSellThree,
  @required int quantityThree,
  bool stock = false,
  BuyOrSell buyOrSellStock,
  int quantityStock = 100,
}) {
  double bestStrategyReturn;
  double stratValueTally;
  List<TradeInfo> bestStrategyTradeList;
  double _stepWidth = (range[1] - range[0]) / 50;
  Map optionChainOne = tradeTypeOne == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];
  Map optionChainTwo = tradeTypeTwo == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];
  Map optionChainThree = tradeTypeThree == TradeType.call
      ? quote.optionsChains[expiryDate][0]
      : quote.optionsChains[expiryDate][1];

  for (double stockPriceOne in optionChainOne.keys) {
    for (double stockPriceTwo in optionChainTwo.keys) {
      for (double stockPriceThree in optionChainThree.keys)
        if (stockPriceTwo >= stockPriceOne &&
            stockPriceThree >= stockPriceTwo) {
          List<TradeInfo> tradeList = stock
              ? TradeInfo(
                  expiryDate: expiryDate,
                  strikePrice: quote.stockPrice,
                  tradeType: TradeType.stock,
                  buyOrSell: buyOrSellStock,
                  quantity: quantityStock)
              : [];
          tradeList.add(TradeInfo(
              expiryDate: expiryDate,
              strikePrice: stockPriceOne,
              premium: optionChainOne[stockPriceOne]['ask'] != 0
                  ? optionChainOne[stockPriceOne]['ask']
                  : optionChainOne[stockPriceOne]['lastPrice'],
              tradeType: tradeTypeOne,
              buyOrSell: buyOrSellOne,
              quantity: quantityOne));
          tradeList.add(TradeInfo(
              expiryDate: expiryDate,
              strikePrice: stockPriceTwo,
              premium: optionChainTwo[stockPriceTwo]['ask'] != 0
                  ? optionChainTwo[stockPriceTwo]['ask']
                  : optionChainTwo[stockPriceTwo]['lastPrice'],
              tradeType: tradeTypeTwo,
              buyOrSell: buyOrSellTwo,
              quantity: quantityTwo));
          tradeList.add(TradeInfo(
            expiryDate: expiryDate,
            strikePrice: stockPriceThree,
            premium: optionChainThree[stockPriceThree]['ask'] != 0
                ? optionChainThree[stockPriceThree]['ask']
                : optionChainThree[stockPriceThree]['lastPrice'],
            tradeType: tradeTypeThree,
            buyOrSell: buyOrSellThree,
            quantity: quantityThree,
          ));
          double pointValue = 0;
          for (double point = range[0]; point < range[1]; point += _stepWidth) {
            double _pdfAt;

            stratValueTally = 0;
            tradeList.forEach((trade) {
              pointValue += trade.tradeValue(
                stockPrice: point,
                volatility: quote.impliedVolatility[trade.expiryDate],
                interest: quote.interest,
                onDate: trade.expiryDate,
              );
            });
            _pdfAt = logNormPDF(
                stockPrice: quote.stockPrice,
                position: point,
                volatility: quote.impliedVolatility[tradeList[0].expiryDate],
                expiryDate: expiryDate);
            stratValueTally += pointValue * _pdfAt * _stepWidth;
          }
          if (bestStrategyReturn == null) {
            bestStrategyReturn = stratValueTally;
            bestStrategyTradeList = tradeList;
          } else if (stratValueTally > bestStrategyReturn) {
            bestStrategyReturn = stratValueTally;
            bestStrategyTradeList = tradeList;
          }
        }
    }
  }
  for (int i = 0; i < bestStrategyTradeList.length; i++) {
    bestStrategyTradeList[i].index = i;
  }
  return bestStrategyTradeList;
}

enum Strategies {
  longCall,
  bullCallSpread,
  bullPutSpread,
  coveredCall,
  protectivePut,
  cashSecuredPut,
  longPut,
  bearPutSpread,
  bearCallSpread,
  collar,
  shortStaddle,
  shortStrangle,
  ironCondor,
  longCallButterfly,
  longStraddle,
  longStrangle
}

Map<Strategies, String> optionsIDs = {
  Strategies.longCall: 'Long Call',
  Strategies.bullCallSpread: 'Bull Call Spread',
  Strategies.bullPutSpread: 'Bull Put Spread',
  Strategies.coveredCall: 'Covered Call',
  Strategies.protectivePut: 'Protective Put',
  Strategies.cashSecuredPut: 'Cash Secured Put',
  Strategies.longPut: 'Long Put',
  Strategies.bearPutSpread: 'Bear Put Spread',
  Strategies.bearCallSpread: 'Bear Call Spread',
  Strategies.collar: 'Collar',
  Strategies.shortStaddle: 'Short Straddle',
  Strategies.shortStrangle: 'Short Strangle',
  Strategies.ironCondor: 'Iron Condor',
  Strategies.longCallButterfly: 'Long Call Butterfly',
  Strategies.longStraddle: 'Long Straddle',
  Strategies.longStrangle: 'Long Strangle',
};

enum StrategyType { all, bullish, bearish, neutral, volatile }

// enum BullishStrategies {
//   longCall,
//   bullCallSpread,
//   bullPutSpread,
//   coveredCall,
//   protectivePut,
//   cashSecuredPut
// }

// enum BearishStrategies { longPut, bearPutSpread, bearCallSpread }

// enum NeutralStrategies {
//   collar,
//   shortStaddle,
//   shortStrangle,
//   ironCondor,
//   calendarSpread,
//   coveredCombination,
//   longCallButterfly
// }

// enum VolatileStrategies {
//   longStraddle,
//   longStrangle,
//   callBackSpreak,
//   putBackSpread
// }

Map<Strategies, Map<String, dynamic>> singleOptionStrategies = {
  Strategies.longCall: {
    'tradeType': TradeType.call,
    'buyOrSell': BuyOrSell.buy,
    'quantity': 100,
    'stock': false,
    'buyOrSellStock': null,
  },
  Strategies.coveredCall: {
    'tradeType': TradeType.call,
    'buyOrSell': BuyOrSell.sell,
    'quantity': 100,
    'stock': true,
    'buyOrSellStock': BuyOrSell.buy,
  },
  Strategies.protectivePut: {
    'tradeType': TradeType.put,
    'buyOrSell': BuyOrSell.buy,
    'quantity': 100,
    'stock': true,
    'buyOrSellStock': BuyOrSell.buy,
  },
  Strategies.cashSecuredPut: {
    'tradeType': TradeType.put,
    'buyOrSell': BuyOrSell.sell,
    'quantity': 100,
    'stock': false,
    'buyOrSellStock': null,
  },
  Strategies.longPut: {
    'tradeType': TradeType.put,
    'buyOrSell': BuyOrSell.buy,
    'quantity': 100,
    'stock': false,
    'buyOrSellStock': null,
  }
};

Map<Strategies, Map<String, dynamic>> doubleOptionStrategies = {
  Strategies.bullCallSpread: {
    'tradeTypeOne': TradeType.call,
    'buyOrSellOne': BuyOrSell.buy,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.sell,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
  Strategies.bullPutSpread: {
    'tradeTypeOne': TradeType.put,
    'buyOrSellOne': BuyOrSell.buy,
    'tradeTypeTwo': TradeType.put,
    'buyOrSellTwo': BuyOrSell.sell,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
  Strategies.bearPutSpread: {
    'tradeTypeOne': TradeType.put,
    'buyOrSellOne': BuyOrSell.sell,
    'tradeTypeTwo': TradeType.put,
    'buyOrSellTwo': BuyOrSell.buy,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
  Strategies.bearCallSpread: {
    'tradeTypeOne': TradeType.call,
    'buyOrSellOne': BuyOrSell.sell,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.buy,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
  Strategies.collar: {
    'tradeTypeOne': TradeType.put,
    'buyOrSellOne': BuyOrSell.buy,
    'quantityOne': 100,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.sell,
    'quantityTwo': 100,
    'stock': true,
    'buyOrSellStock': BuyOrSell.buy,
  },
  Strategies.shortStrangle: {
    'name': 'Short Strangle',
    'tradeTypeOne': TradeType.put,
    'buyOrSellOne': BuyOrSell.sell,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.sell,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
  Strategies.longStrangle: {
    'tradeTypeOne': TradeType.put,
    'buyOrSellOne': BuyOrSell.buy,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.buy,
    'stock': false,
    'buyOrSellStock': null,
    'quantityOne': 100,
    'quantityTwo': 100,
  },
};

Map<Strategies, Map<String, dynamic>> trippleOptionStregies = {
  Strategies.longCallButterfly: {
    'tradeTypeOne': TradeType.call,
    'buyOrSellOne': BuyOrSell.buy,
    'quantityOne': 100,
    'tradeTypeTwo': TradeType.call,
    'buyOrSellTwo': BuyOrSell.sell,
    'quantityTwo': 200,
    'tradeTypeThree': TradeType.call,
    'buyOrSellThree': BuyOrSell.buy,
    'quantityThree': 100,
    'stock': false,
    'buyOrSellStock': null,
  }
};
