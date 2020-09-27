import 'package:flutter/cupertino.dart';
import 'package:options_dashboard/pages/playbook/plays/plays.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

class PlaybookState extends ChangeNotifier {
  PlaybookState({this.index});

  int index = 0;
  double width;
  double height;
  StrategyType strategyType = StrategyType.all;
  List<Widget> output;

  final List<Widget> strategies = [
        LongCall(),
        BullCallSpread(),
        BullPutSpread(),
        CoveredCall(),
        ProtectivePut(),
        CashSecuredPut(),
        LongPut(),
        BearPutSpread(),
        BearCallSpread(),
        Collar(),
        ShortStraddle(),
        ShortStrangle(),
        IronCondor(),
        LongCallButterfly(),
        LongStraddle(),
        LongStrangle()
      ],
      bullishStrategies = [
        LongCall(),
        BullCallSpread(),
        BullPutSpread(),
        CoveredCall(),
        ProtectivePut(),
        CashSecuredPut(),
      ],
      bearishStrategies = [
        LongPut(),
        BearPutSpread(),
        BearCallSpread(),
      ],
      neutralStrategies = [
        Collar(),
        ShortStraddle(),
        ShortStrangle(),
        IronCondor(),
        LongCallButterfly(),
      ],
      volatileStraties = [
        LongStraddle(),
        LongStrangle(),
      ];

  void increaseIndex() {
    if (index != output.length - 1) index++;
    notifyListeners();
  }

  void decreaseIndex() {
    if (index != 0) index--;
    notifyListeners();
  }

  void changeStrategyType(StrategyType newStrategyType) {
    if (strategyType != newStrategyType) {
      index = 0;
    }
    strategyType = newStrategyType;
    playbookSection();
    notifyListeners();
  }

  List<Widget> playbookSection() {
    if (strategyType == StrategyType.all) {
      output = strategies;
    } else if (strategyType == StrategyType.bearish) {
      output = bearishStrategies;
    } else if (strategyType == StrategyType.bullish) {
      output = bullishStrategies;
    } else if (strategyType == StrategyType.neutral) {
      output = neutralStrategies;
    } else {
      output = volatileStraties;
    }
    return output;
  }

  void doNothing() {}
}
