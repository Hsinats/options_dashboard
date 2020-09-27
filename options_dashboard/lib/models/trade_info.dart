import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:options_dashboard/functions/black_scholes.dart';

class TradeInfo extends ChangeNotifier {
  BuyOrSell buyOrSell;
  TradeType tradeType;
  DateTime expiryDate;
  int quantity;
  bool expanded = false;
  bool customPremium = false;
  int index;
  double strikePrice,
      premium,
      impliedVolatility,
      bid,
      ask,
      lastPrice,
      savedStrike;

  TradeInfo({
    @required this.expiryDate,
    @required this.strikePrice,
    this.buyOrSell = BuyOrSell.buy,
    this.tradeType = TradeType.call,
    this.index = 0,
    this.bid,
    this.ask,
    this.lastPrice,
    this.impliedVolatility,
    this.quantity = 100,
    this.premium,
  });

  set setCustomPremiumValue(double newCustomPremiumValue) {
    premium = newCustomPremiumValue / 100;
  }

  void toggleCustomPremium() {
    customPremium = !customPremium;
    notifyListeners();
  }

  void updateTradeCallback({
    BuyOrSell newBuyOrSell,
    int newQuantity,
    TradeType newTradeType,
    double newStrikePrice,
    DateTime newExpiryDate,
    double newSavedStrikePrice,
  }) {
    if (newBuyOrSell != null) buyOrSell = newBuyOrSell;
    if (newQuantity != null) quantity = newQuantity;
    if (newTradeType != null) tradeType = newTradeType;
    if (newStrikePrice != null) strikePrice = newStrikePrice;
    if (newSavedStrikePrice != null) savedStrike = newSavedStrikePrice;
    if (newExpiryDate != null) expiryDate = newExpiryDate;
    notifyListeners();
  }

  updatePremiums({
    @required Map<DateTime, dynamic> optionsChain,
    @required bool useBidAsk,
  }) {
    if (tradeType == TradeType.stock) {
      premium = 0;
    } else {
      int tradeID;
      tradeType == TradeType.call ? tradeID = 0 : tradeID = 1;
      Map optionList = optionsChain[expiryDate][tradeID];
      double newPremium;
      double newIV;

      optionList.forEach((key, value) {
        if (key == strikePrice) {
          newIV = optionList[key]['impliedVolatility'];
          if (buyOrSell == BuyOrSell.buy) {
            if (optionList[key]['ask'] != 0 && optionList[key]['ask'] != null) {
              if (useBidAsk) {
                newPremium =
                    (optionList[key]['ask'] + optionList[key]['bid']) / 2;
              } else {
                newPremium = optionList[key]['ask'];
              }
            } else {
              newPremium = optionList[key]['lastPrice'];
            }
          } else {
            if (optionList[key]['bid'] != 0 && optionList[key]['bid'] != null) {
              if (useBidAsk) {
                newPremium =
                    (optionList[key]['ask'] + optionList[key]['bid']) / 2;
              } else {
                newPremium = optionList[key]['bid'];
              }
            } else {
              newPremium = optionList[key]['lastPrice'];
            }
          }
        }
      });
      impliedVolatility = newIV;
      if (!customPremium) {
        premium = newPremium;
      }
    }
  }

  double tradeValue({
    @required double stockPrice,
    @required double volatility,
    @required double interest,
    @required DateTime onDate,
    bool premiums = true,
  }) {
    double rawValue;
    double output;
    if (tradeType == TradeType.call) {
      rawValue = callValue(
        stockPrice: stockPrice,
        strikePrice: strikePrice,
        volatility: volatility,
        interest: interest,
        term: expiryDate.difference(onDate).inMinutes / (365 * 24 * 60),
      );
      if (premiums) {
        rawValue -= premium;
      }
    } else if (tradeType == TradeType.put) {
      rawValue = putValue(
        stockPrice: stockPrice,
        strikePrice: strikePrice,
        volatility: volatility,
        interest: interest,
        term: expiryDate.difference(onDate).inMinutes / (365 * 24 * 60),
      );
      if (premiums) {
        rawValue -= premium;
      }
    } else {
      rawValue = stockPrice - strikePrice;
    }
    if (buyOrSell == BuyOrSell.sell) {
      rawValue *= -1;
    }
    output = rawValue * quantity;
    return output;
  }
}

enum TradeType { call, put, stock }

enum BuyOrSell { buy, sell }
