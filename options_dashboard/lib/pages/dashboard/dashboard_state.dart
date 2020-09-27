import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

class DashboardState extends ChangeNotifier {
  bool summary = false;
  bool lookingUpSymbol = false;
  bool trades = true;
  bool error = false;
  bool searching = true;
  bool fundamentals = false;
  bool charts = true;
  bool tradeList = true;
  bool strategyInfo = false;
  bool hasData = false;
  bool probabilitySlider = false;
  int bottomNavBarIndex = 0;
  bool dateSlider = false, analytics = false;
  DateTime ocExpiryDate;
  DateTime sliderStart = DateTime.now();
  String symbolInput;
  GraphType graphType = GraphType.history;
  double confidence = 0.95;
  Strategies strategy = Strategies.longCall;
  PageController tabController = PageController(initialPage: 0);

  void toggleprobabilitySlider() {
    probabilitySlider = !probabilitySlider;
    notifyListeners();
  }

  void toggleDateSlider() {
    dateSlider = !dateSlider;
    notifyListeners();
  }

  void toggleAnalytics() {
    analytics = !analytics;
    notifyListeners();
  }

  void setStrategy(Strategies newStrategy) {
    strategy = newStrategy;
    notifyListeners();
  }

  void setHasDataTrue() {
    hasData = true;
    notifyListeners();
  }

  void setHasDataFalse() {
    hasData = false;
    notifyListeners();
  }

  void setOCExpiryDate(DateTime newExpiryDate) {
    ocExpiryDate = newExpiryDate;
    notifyListeners();
  }

  void bottomNavBarPress(int index) {
    tabController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    bottomNavBarIndex = index;
    print(index);
    notifyListeners();
  }

  void toggleFundamentals() {
    fundamentals = !fundamentals;
    notifyListeners();
  }

  void toggleStrategyInfo() {
    strategyInfo = !strategyInfo;
    notifyListeners();
  }

  void toggleTradeList() {
    tradeList = !tradeList;
    notifyListeners();
  }

  void toggleTrades() {
    trades = !trades;
    notifyListeners();
  }

  void toggleCharts() {
    charts = !charts;
    notifyListeners();
  }

  void toggleSummary() {
    summary = !summary;
    notifyListeners();
  }

  void toggleSearching() {
    searching = !searching;
    notifyListeners();
  }

  void toggleLookingUpSymbol() {
    lookingUpSymbol = !lookingUpSymbol;
    notifyListeners();
  }

  void setErrorFalse() {
    error = false;
    notifyListeners();
  }

  void setErrorTrue() {
    error = true;
    notifyListeners();
  }

  void setSymbolInput(String text) {
    symbolInput = text;
    notifyListeners();
  }

  String get getSymbolInput => symbolInput;

  void setGraphType(GraphType newGraphType) {
    graphType = newGraphType;
    notifyListeners();
  }
}

enum GraphType { history, payoff, tradeRange }
