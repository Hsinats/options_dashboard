import 'package:options_dashboard/services/optimize_trade.dart';

class StrategyPass {
  final int index;
  final StrategyType strategyGroup;
  dynamic strategyType;

  StrategyPass({
    this.index,
    this.strategyGroup,
  });

  void getStrategy() {
    if (strategyGroup == StrategyType.all) {
      if (index <= BullishStrategies.values.length - 1) {
        strategyType = BullishStrategies.values[index];
      } else if (index <=
          (BullishStrategies.values.length +
              BearishStrategies.values.length -
              1)) {
        strategyType =
            BullishStrategies.values[index - BullishStrategies.values.length];
      } else if (index <=
          (BullishStrategies.values.length +
              BearishStrategies.values.length +
              NeutralStrategies.values.length -
              1)) {
        strategyType = NeutralStrategies.values[index -
            BullishStrategies.values.length -
            BearishStrategies.values.length];
      } else if (index <=
          (BullishStrategies.values.length +
              BearishStrategies.values.length +
              NeutralStrategies.values.length -
              1)) {
        strategyType = VolatileStrategies.values[index -
            BullishStrategies.values.length -
            BearishStrategies.values.length -
            NeutralStrategies.values.length];
      }
    } else if (strategyGroup == StrategyType.bearish) {
      strategyType = BearishStrategies.values[index];
    } else if (strategyGroup == StrategyType.bullish) {
      strategyType = BullishStrategies.values[index];
    } else if (strategyGroup == StrategyType.neutral) {
      strategyType = NeutralStrategies.values[index];
    } else if (strategyGroup == StrategyType.volatile) {
      strategyType = VolatileStrategies.values[index];
    }
  }
}

enum BullishStrategies {
  longCall,
  bullCallSpread,
  bullPutSpread,
  coveredCall,
  protectivePut,
  cashSecuredPut
}

enum BearishStrategies { longPut, bearPutSpread, bearCallSpread }

enum NeutralStrategies {
  collar,
  shortStraddle,
  longStrangle,
  ironCondor,
  longCallButterfly
}
enum VolatileStrategies { longStraddle, longStrangle }
