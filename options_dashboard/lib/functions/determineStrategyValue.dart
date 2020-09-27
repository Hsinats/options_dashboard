// import 'package:meta/meta.dart';
// import 'package:options_dashboard/data/trade_info.dart';
// import 'package:options_dashboard/functions/distribution.dart';
// import 'package:options_dashboard/functions/option_expiry_value.dart';
// import 'package:options_dashboard/services/optimize_trade.dart';

// double determineStrategyValue({
//   @required List<TradeInfo> tradeList,
//   @required double stockPrice,
//   @required double volatility,
//   @required List<double> range,
//   @required StrategyType outlook,
//   @required int expiryDate,
// }) {
//   double stratValueTally;
//   double evTally = 0;
//   double currentStockPrice;
//   double _stepWidth = (range[1] - range[0]) / 100;
//   if (range[0] != range[1]) {
//     for (double i = range[0]; i < range[1]; i += _stepWidth) {
//       currentStockPrice = i;
//       stratValueTally = 0;
//       tradeList.forEach((element) {
//         stratValueTally += getOptionExpiryValue(
//                 tradeType: element.tradeType,
//                 bought: element.buyOrSell == BuyOrSell.buy,
//                 strikePrice: element.strikePrice,
//                 stockPrice: currentStockPrice,
//                 premium: element.premium,
//                 quantity: element.quantity) *
//             _stepWidth;
//       });
//       evTally += stratValueTally *
//           normalDist(
//             distribution: 'lognorm',
//             position: currentStockPrice,
//             stockPrice: stockPrice,
//             volatility: volatility,
//             expiryDate: expiryDate,
//             outlook: outlook,
//           );
//     }
//   } else {
//     stratValueTally = 0;
//     tradeList.forEach((element) {
//       stratValueTally += getOptionExpiryValue(
//               tradeType: element.tradeType,
//               bought: element.buyOrSell == BuyOrSell.buy,
//               strikePrice: element.strikePrice,
//               stockPrice: range[0],
//               premium: element.premium,
//               quantity: element.quantity) *
//           _stepWidth;
//     });
//   }
//   return evTally;
// }
