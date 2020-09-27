import 'package:flutter/cupertino.dart';

class CompanyInfo with ChangeNotifier {
  String name;
  String ticker;
  double stockPrice;
  double dayChange;
  double dayChangePercent;

  set setName(String newName) {
    name = newName;
    notifyListeners();
  }

  set setTicker(String newTicker) {
    ticker = newTicker;
    notifyListeners();
  }

  set setStockPrice(double newStockPrice) {
    stockPrice = newStockPrice;
    notifyListeners();
  }

  set setDayChange(double newDayChange) {
    dayChange = newDayChange;
    notifyListeners();
  }

  set setDayChangePercent(double newDayChangePercent) {
    dayChangePercent = newDayChangePercent;
    notifyListeners();
  }
}
