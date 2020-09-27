import 'dart:math';

import 'package:flutter/material.dart';
import 'package:options_dashboard/models/quote.dart';
import 'package:options_dashboard/models/trade_info.dart';
import 'package:options_dashboard/functions/black_scholes.dart';
import 'package:options_dashboard/functions/distribution.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:options_dashboard/pages/dashboard/widgets/trade_item.dart';

class Strategy with ChangeNotifier {
  List<TradeInfo> tradeList;
  List<String> breakPoints = [];
  List<int> slopes;
  List<ReturnData> returnData, currentValueData, pdfData;
  double currentValue;
  double valueAtCustomDateAndInterest, customStockPrice;
  double totalPremiums, strategyValue, pop, payoffRatio, rOR;
  String maxRisk, maxReturn;
  List<Widget> tradeView;
  DateTime minExpiryDate;
  DateTime thetaDate = DateTime.now();
  double volSliderValue, volSliderMax;
  bool useBidAsk = true;
  bool singleDate = true;

  void updateCustomStockPrice(newCustomStockPrice) {
    customStockPrice = newCustomStockPrice;
    notifyListeners();
  }

  void toggleUseBidAsk() {
    useBidAsk = !useBidAsk;
    notifyListeners();
  }

  void initializeSliders(Quote quote) {
    volSliderValue = quote.impliedVolatility[tradeList[0].expiryDate];
    volSliderMax = volSliderValue * 2;
    updateCustomStockPrice(quote.stockPrice);
    notifyListeners();
  }

  void updateThetaDate(DateTime newThetaDate) {
    thetaDate = newThetaDate;
    notifyListeners();
  }

  void setVolSliderValue(double newVolSliderValue, {bool setNewMax}) {
    volSliderValue = newVolSliderValue;
    if (setNewMax ?? false) {
      volSliderMax = newVolSliderValue * 3;
    }
    notifyListeners();
  }

  void addTradeFromOptionsChain({
    @required strikePrice,
    @required expiryDate,
    @required tradeType,
    @required bid,
    @required ask,
    @required lastPrice,
    @required optionsChain,
    @required buyOrSell,
  }) {
    tradeList.add(TradeInfo(
      expiryDate: expiryDate,
      strikePrice: strikePrice,
      index: tradeList.length,
      tradeType: tradeType,
      bid: bid,
      ask: ask,
      lastPrice: lastPrice,
      buyOrSell: buyOrSell,
    ));
    updateAllPremiums(optionsChain: optionsChain);
  }

  void buildTradeView({
    @required BuildContext context,
    @required Quote quote,
    @required Strategy strategy,
    @required DashboardState dashboardState,
  }) {
    tradeView = [];
    tradeList.forEach((trade) {
      tradeView.add(TradeItemMobile(
          context: context,
          quote: quote,
          tradeInformation: trade,
          strategy: strategy,
          dashboardState: dashboardState));
      tradeView.add(Divider(
          // height: 2,
          // indent: 8,
          // endIndent: 8,
          // color: Colors.purple,
          ));
    });
    notifyListeners();
  }

  void expandTrade(int index, {BuildContext context, Quote quote}) {
    tradeList[index].expanded = !tradeList[index].expanded;
    notifyListeners();
  }

  void initialize({
    @required TradeInfo trade,
  }) {
    tradeList = [];
    tradeList.add(trade);
    notifyListeners();
  }

  void updateStrategyInfo(
    Quote quote,
  ) {
    updateAllPremiums(
      optionsChain: quote.optionsChains,
    );
    determineStrategyValue(
      stockPrice: quote.stockPrice,
      range: quote.confidenceInterval,
      volatility: quote.impliedVolatility,
      interest: quote.interest,
    );
    determineRisk(
        stockPrice: quote.stockPrice,
        volatility: quote.impliedVolatility,
        interest: quote.interest);
    getDateStrategyValue(
      range: quote.confidenceInterval,
      interest: quote.interest,
      quote: quote,
    );
    determineCurrentPoint(quote.stockPrice,
        quote.impliedVolatility[minExpiryDate], quote.interest);
    notifyListeners();
  }

  updateAllPremiums({
    @required Map<DateTime, dynamic> optionsChain,
  }) {
    totalPremiums = 0;
    for (TradeInfo trade in tradeList) {
      trade.updatePremiums(
        optionsChain: optionsChain,
        useBidAsk: useBidAsk,
      );
      trade.tradeType != TradeType.stock
          ? trade.buyOrSell == BuyOrSell.sell
              ? totalPremiums += trade.premium * trade.quantity
              : totalPremiums -= trade.premium * trade.quantity
          : totalPremiums += 0;
    }
    notifyListeners();
  }

  void getDateStrategyValue({
    @required Map<DateTime, List<double>> range,
    @required double interest,
    @required Quote quote,
  }) {
    currentValueData = [];
    double pointValue, tradeValue;
    double _stepWidth =
        max(0.01, (range[minExpiryDate][1] - range[minExpiryDate][0]) / 50);
    for (double i = range[minExpiryDate][0];
        i < range[minExpiryDate][1];
        i += _stepWidth) {
      pointValue = 0;
      tradeList.forEach((trade) {
        tradeValue = trade.tradeValue(
          stockPrice: i,
          volatility: volSliderValue,
          interest: interest,
          onDate: thetaDate,
        );
        pointValue += tradeValue;
      });
      currentValueData
          .add(ReturnData(i, double.parse(pointValue.toStringAsFixed(2))));
    }

    pointValue = 0;
    tradeList.forEach((trade) {
      tradeValue = trade.tradeValue(
          stockPrice: customStockPrice,
          volatility: volSliderValue,
          interest: interest,
          onDate: thetaDate);
      pointValue += tradeValue;
    });
    valueAtCustomDateAndInterest = pointValue - totalPremiums;

    notifyListeners();
  }

  void determineCurrentPoint(
      double stockPrice, double volatility, double interest) {
    double pointValue = 0.0, tradeValue = 0.0;
    tradeList.forEach((trade) {
      tradeValue = trade.tradeValue(
          stockPrice: stockPrice,
          volatility: volatility,
          interest: interest,
          onDate: DateTime.now());
      pointValue += tradeValue;
    });
    currentValue = pointValue - totalPremiums;
  }

  void determineStrategyValue({
    @required double stockPrice,
    @required Map<DateTime, double> volatility,
    @required Map<DateTime, List<double>> range,
    @required double interest,
  }) {
    double stratValueTally = 0;
    double evTally = 0,
        gainTally = 0,
        lossTally = 0,
        gainPTally = 0,
        lossPTally = 0;
    double pointValue, _pdfAt, tradeValue;
    returnData = [];
    pdfData = [];
    minExpiryDate = determineMinExpiryDate(tradeList);
    double _stepWidth =
        max(0.01, (range[minExpiryDate][5] - range[minExpiryDate][4]) / 150);
    for (double i = range[minExpiryDate][4];
        i < range[minExpiryDate][5];
        i += _stepWidth) {
      pointValue = 0;
      tradeList.forEach((trade) {
        tradeValue = trade.tradeValue(
            stockPrice: i,
            volatility: volatility[trade.expiryDate],
            interest: interest,
            onDate: minExpiryDate);
        pointValue += tradeValue;
      });
      stratValueTally = pointValue;
      _pdfAt = logNormPDF(
        stockPrice: stockPrice,
        position: i,
        volatility: volatility[minExpiryDate],
        expiryDate: minExpiryDate,
      );
      evTally += stratValueTally * _pdfAt * _stepWidth;

      returnData.add(ReturnData(i, pointValue));
      pdfData.add(ReturnData(i, _pdfAt));

      if (pointValue > 0) {
        gainTally += _pdfAt * _stepWidth * stratValueTally;
        gainPTally += _pdfAt * _stepWidth;
      } else if (pointValue < 0) {
        lossPTally += _pdfAt * _stepWidth;
        lossTally += _pdfAt * _stepWidth * stratValueTally;
      }
    }
    // } else {
    //   tradeList.forEach((trade) {
    //     stratValueTally += trade.tradeValue(
    //       stockPrice: stockPrice,
    //       volatility: volatility[trade.expiryDate],
    //       interest: interest,
    //       onDate: minExpiryDate,
    //     );
    //   });
    // }
    strategyValue = evTally;
    pop = gainPTally / (gainPTally + lossPTally);
    if (pop != 0) {
      payoffRatio = ((gainTally / pop) / (lossTally / (1 - pop))).abs();
    } else {
      payoffRatio = 0;
    }
    rOR = riskOfRuin(probability: pop, winSize: payoffRatio, betSize: 0.05);
    notifyListeners();
  }

  void determineRisk(
      {@required double stockPrice,
      @required Map<DateTime, double> volatility,
      @required double interest}) {
    int _slopeTally;
    String _maxRisk, _maxReturn;
    slopes = [];
    List<double> _strikes = [], _vertexValue;

    // Working with slopes so that we can find the behavior in different areas
    tradeList.forEach((trade) {
      if (!_strikes.contains(trade.strikePrice)) {
        _strikes.add(trade.strikePrice);
      }
    });
    _strikes.sort();
    for (int i = 0; i < _strikes.length; i++) {
      double _strike = _strikes[i];
      if (!_strikes.sublist(0, i).contains(_strike)) {
        _slopeTally = 0;
        for (TradeInfo _trade in tradeList) {
          if (_trade.tradeType == TradeType.stock) {
            if (_trade.buyOrSell == BuyOrSell.buy) {
              _slopeTally += _trade.quantity ~/ 100;
            } else {
              _slopeTally -= _trade.quantity ~/ 100;
            }
          } else if (_trade.tradeType == TradeType.put) {
            if (_trade.strikePrice >= _strike) {
              if (_trade.buyOrSell == BuyOrSell.buy) {
                _slopeTally -= _trade.quantity ~/ 100;
              } else {
                _slopeTally += _trade.quantity ~/ 100;
              }
            }
          } else {
            if (_trade.strikePrice < _strike) {
              if (_trade.buyOrSell == BuyOrSell.buy) {
                _slopeTally += _trade.quantity ~/ 100;
              } else {
                _slopeTally -= _trade.quantity ~/ 100;
              }
            }
          }
        }
        slopes.add(_slopeTally);
      }
    }
    _slopeTally = 0;
    for (TradeInfo _trade in tradeList) {
      if (_trade.tradeType == TradeType.call ||
          _trade.tradeType == TradeType.stock) {
        if (_trade.buyOrSell == BuyOrSell.buy) {
          _slopeTally += _trade.quantity ~/ 100;
        } else {
          _slopeTally -= _trade.quantity ~/ 100;
        }
      }
    }

    slopes.add(_slopeTally);
    _strikes.insert(0, 0);
    // Checking if something is unlimited risk/gain then finding true risk/reward
    if (slopes.last > 0) {
      _maxReturn = 'Unlimited';
      _vertexValue = findVertextValues(
              strikes: _strikes,
              tradeList: tradeList,
              volatility: volatility,
              interest: interest,
              minExpiryDate: minExpiryDate,
              risk: true)
          .toList();
      _maxRisk = _vertexValue.reduce(min).toStringAsFixed(2);
    } else if (slopes.last < 0) {
      _maxRisk = 'Unlimited';
      _vertexValue = findVertextValues(
              strikes: _strikes,
              tradeList: tradeList,
              volatility: volatility,
              interest: interest,
              minExpiryDate: minExpiryDate,
              risk: false)
          .toList();
      _maxReturn = _vertexValue.reduce(max).toStringAsFixed(2);
    } else {
      _vertexValue = findVertextValues(
              strikes: _strikes,
              tradeList: tradeList,
              volatility: volatility,
              interest: interest,
              minExpiryDate: minExpiryDate,
              risk: true)
          .toList();
      _maxRisk = _vertexValue.reduce(min).toStringAsFixed(2);
      _vertexValue = findVertextValues(
              strikes: _strikes,
              tradeList: tradeList,
              volatility: volatility,
              interest: interest,
              minExpiryDate: minExpiryDate,
              risk: false)
          .toList();
      _maxReturn = _vertexValue.reduce(max).toStringAsFixed(2);
    }
    maxRisk = _maxRisk;
    maxReturn = _maxReturn;

    _vertexValue = findVertextValues(
            strikes: _strikes,
            tradeList: tradeList,
            volatility: volatility,
            interest: interest,
            minExpiryDate: minExpiryDate,
            risk: false)
        .toList();

    // Breakeven points
    breakPoints = [];
    singleDate = true;

    for (TradeInfo trade in tradeList) {
      if (trade.expiryDate != minExpiryDate) {
        singleDate = false;
        break;
      }
    }
    if (singleDate) {
      for (int index = 1; index < _strikes.length; index++) {
        double breakeven;
        if (_vertexValue[index].isNegative &&
            !_vertexValue[index - 1].isNegative) {
          breakeven = _strikes[index - 1] -
              _vertexValue[index - 1] / (slopes[index - 1] * 100);
          breakPoints.add(breakeven.toStringAsFixed(2));
        } else if (!_vertexValue[index].isNegative &&
            _vertexValue[index - 1].isNegative) {
          breakeven = _strikes[index - 1] -
              _vertexValue[index - 1] / (slopes[index - 1] * 100);
          breakPoints.add(breakeven.toStringAsFixed(2));
        }
      }
      if ((_vertexValue.last > 0 && slopes.last < 0) ||
          (_vertexValue.last < 0 && slopes.last > 0)) {
        double breakeven;
        breakeven = _strikes.last - _vertexValue.last / (slopes.last * 100);
        breakPoints.add(breakeven.toStringAsFixed(2));
      }
    } else {
      for (int i = 1; i < returnData.length; i++) {
        if (returnData[i].value.isNegative &&
                !returnData[i - 1].value.isNegative ||
            !returnData[i].value.isNegative &&
                returnData[i - 1].value.isNegative) {
          breakPoints.add(
              ((returnData[i].x + returnData[i - 1].x) / 2).toStringAsFixed(2));
        }
      }
    }
  }

  // void determineRisk({
  //   @required double stockPrice,
  //   @required double impliedVolatility,
  // }) {

  //   for (int i = 0; i < _strikes.length - 1; i++) {
  //     if (_vertexValue[i] < 0 && _vertexValue[i + 1] > 0) {
  //       _toAdd = _strikes[i] + _vertexValue[i].abs() / (_slopes[i].abs() * 100);
  //       _breakOutPoints.add(_toAdd);
  //       _allPoints.add(_toAdd);
  //     } else if (_vertexValue[i] > 0 && _vertexValue[i + 1] < 0) {
  //       _toAdd = _strikes[i] + _vertexValue[i].abs() / (_slopes[i].abs() * 100);
  //       _breakDownPoints.add(
  //           _strikes[i] + _vertexValue[i].abs() / (_slopes[i].abs() * 100));
  //       _allPoints.add(_toAdd);
  //     }
  //   }

  //   if (_vertexValue.last.isNegative && _slopes.last > 0) {
  //     _toAdd =
  //         _strikes.last + _vertexValue.last.abs() / (_slopes.last.abs() * 100);
  //     _breakOutPoints.add(_toAdd);
  //     _allPoints.add(_toAdd);
  //   } else if (!_vertexValue.last.isNegative && _slopes.last.isNegative) {
  //     _toAdd =
  //         _strikes.last + _vertexValue.last.abs() / (_slopes.last.abs() * 100);
  //     _breakDownPoints.add(
  //         _strikes.last + _vertexValue.last.abs() / (_slopes.last.abs() * 100));
  //     _allPoints.add(_toAdd);
  //   }

  //   _allPoints.toList().sort();
  //   _breakEvenPoints = _allPoints.toList();
  //   _breakEvenPoints.sort();
  //   if (_breakEvenPoints.length != 0) {
  //     if (_breakOutPoints.contains(_breakEvenPoints.last)) {
  //       pop = 1;
  //       _breakOutPoints.forEach((element) {
  //         pop -= normalDist(
  //           distribution: 'lognormCDF',
  //           stockPrice: stockPrice,
  //           position: element,
  //           volatility: impliedVolatility,
  //           expiryDate: expiryDate,
  //           outlook: outlook,
  //         );
  //       });
  //       _breakDownPoints.forEach((element) {
  //         pop += normalDist(
  //           distribution: 'lognormCDF',
  //           stockPrice: stockPrice,
  //           position: element,
  //           volatility: impliedVolatility,
  //           expiryDate: expiryDate,
  //           outlook: outlook,
  //         );
  //       });
  //     } else {
  //       pop = 0;
  //       _breakOutPoints.forEach((element) {
  //         pop -= normalDist(
  //           distribution: 'lognormCDF',
  //           stockPrice: stockPrice,
  //           position: element,
  //           volatility: impliedVolatility,
  //           expiryDate: expiryDate,
  //           outlook: outlook,
  //         );
  //       });
  //       _breakDownPoints.forEach((element) {
  //         pop += normalDist(
  //           distribution: 'lognormCDF',
  //           stockPrice: stockPrice,
  //           position: element,
  //           volatility: impliedVolatility,
  //           expiryDate: expiryDate,
  //           outlook: outlook,
  //         );
  //       });
  //     }
  //   } else {
  //     double _valueAtAPoint = 0;
  //     tradeList.forEach((trade) {
  //       _valueAtAPoint += getOptionExpiryValue(
  //           tradeType: trade.tradeType,
  //           bought: trade.buyOrSell == BuyOrSell.buy,
  //           strikePrice: trade.strikePrice,
  //           stockPrice: stockPrice,
  //           premium: trade.premium,
  //           quantity: trade.quantity);
  //     });
  //     if (_valueAtAPoint > 0) {
  //       pop = 1;
  //     } else {
  //       pop = 0;
  //     }
  //   }
  //   breakPoints = [];
  //   _breakEvenPoints.forEach((element) {
  //     breakPoints.add(element.toStringAsFixed(2));
  //   });

  //   maxRisk = _maxRisk ?? 0;
  //   maxReturn = _maxReturn ?? 0;
  //   pop *= 100;
  //   notifyListeners();
  // }

  void addTrade(List<double> strikeList) {
    tradeList.add(
      TradeInfo(
        strikePrice: strikeList.contains(tradeList.last.strikePrice)
            ? tradeList.last.strikePrice
            : strikeList[strikeList.length ~/ 2],
        buyOrSell: tradeList.last.buyOrSell,
        tradeType: tradeList.last.tradeType,
        expiryDate: tradeList.last.expiryDate,
        index: tradeList.length,
      ),
    );
    for (int i = 0; i < tradeList.length; i++) {
      tradeList[i].index = i;
    }
    notifyListeners();
  }

  void removeTrade(BuildContext context, int index, Quote quote) {
    tradeList.removeAt(index);
    for (int i = 0; i < tradeList.length; i++) {
      tradeList[i].index = i;
    }
    updateStrategyInfo(quote);
    notifyListeners();
  }
}

List<double> findVertextValues(
    {@required List<double> strikes,
    @required List<TradeInfo> tradeList,
    @required Map<DateTime, double> volatility,
    @required double interest,
    @required DateTime minExpiryDate,
    @required bool risk}) {
  double _tradeTally;
  List<double> _vertexValue = [];
  double _term;
  for (double _strike in strikes) {
    _tradeTally = 0;
    for (TradeInfo _trade in tradeList) {
      _term = (_trade.expiryDate.difference(minExpiryDate).inMinutes /
          (365 * 24 * 60));
      if (_trade.tradeType == TradeType.call) {
        double tradeValue;
        tradeValue = _trade.quantity *
            callValue(
              stockPrice: _strike,
              strikePrice: _trade.strikePrice,
              volatility: risk ? 0 : volatility[minExpiryDate],
              interest: interest,
              term: _term,
            );
        if (_trade.buyOrSell == BuyOrSell.buy) {
          _tradeTally += -_trade.premium * _trade.quantity + tradeValue;
        } else {
          _tradeTally += _trade.premium * _trade.quantity - tradeValue;
        }
      } else if (_trade.tradeType == TradeType.put) {
        double tradeValue;
        tradeValue = _trade.quantity *
            putValue(
              stockPrice: _strike,
              strikePrice: _trade.strikePrice,
              volatility: risk ? 0 : volatility[minExpiryDate],
              interest: interest,
              term: _term,
            );
        if (_trade.buyOrSell == BuyOrSell.buy) {
          _tradeTally += -_trade.premium * _trade.quantity + tradeValue;
        } else {
          _tradeTally += _trade.premium * _trade.quantity - tradeValue;
        }
      } else {
        _tradeTally += _trade.quantity * (_strike - _trade.strikePrice);
      }
    }
    _vertexValue.add(_tradeTally);
  }
  return _vertexValue;
}

double riskOfRuin({
  double probability,
  double winSize,
  double betSize,
}) {
  double e;
  double e2;
  double lossSize = 1;

  double betSize = 0.01;
  double win = betSize * winSize;
  double loss = betSize;
  print("avg win= $win");
  print("avg loss = $loss");
  print("prob $probability");
  double expectedReturn = probability * win - (1 - probability) * loss;
  print('EV $expectedReturn');
  double e_2 = probability * pow(win, 2) - (1 - probability) * pow(loss, 2);
  print('e2 $e_2');
  double p = 0.5 + expectedReturn / (2 * sqrt(e_2));
  print("p = $p");
  double rOR = pow((1 - p) / p, 0.1 * sqrt(e_2));
  print(rOR);
  e = probability * winSize * betSize - (1 - probability) * lossSize * betSize;
  e2 = probability * pow(winSize * betSize, 2) -
      (1 - probability) * pow(lossSize * betSize, 2);
  double ror;
  // double p;
  p = 0.5 + e / (2 * e2);
  double base = (1 - p) / p;
  if (!e2.isNegative) {
    double exponent = 0.001 * sqrt(e2);
    ror = pow(base, exponent);
  } else {
    ror = 1;
  }
  double output = ror * 100;
  // print("Risk of ruin");
  // print(output);
  return output;
}

class ReturnData {
  final double x;
  final double value;
  ReturnData(this.x, this.value);
}

DateTime determineMinExpiryDate(List<TradeInfo> tradeList) {
  DateTime minExpiryDate;
  tradeList.forEach((trade) {
    if (minExpiryDate == null) {
      minExpiryDate = trade.expiryDate;
    } else {
      if (trade.expiryDate.isBefore(minExpiryDate)) {
        minExpiryDate = trade.expiryDate;
      }
    }
  });
  return minExpiryDate;
}

bool inConfidenceInterval(double value,
    {double lowerBound, double upperBound}) {
  return value > lowerBound && value < upperBound;
}
