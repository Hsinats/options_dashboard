import 'dart:math';

import 'package:meta/meta.dart';
import 'package:quantity/number.dart';

// Converts the mean of a normal distriution to associated log normal
// distribution.
double logNormalMean(num normalMean, {num stDev = 1}) {
  double output = exp(stDev);
  return output;
}

// Returns the probability density function for a log normal distribution.
double logNormalPdf(num x, {@required num mean, num stDev = 1}) {
  double output = (1 /
      (x * sqrt(2 * pi) * exp(-pow(log(x) - mean, 2) / (2 * pow(stDev, 2)))));
  return output;
}

// Returns the cumulative distribution function for a log normal distribution.
double logNormalCdf(num x, {@required num mean, num stDev = 1}) {
  double output = 0.5 + 0.5 * erf((log(x) - mean) / (sqrt(2) * stDev));
  return output;
}

double logNormPDF({
  @required double stockPrice,
  @required double position,
  @required double volatility,
  @required DateTime expiryDate,
}) {
  double output;
  double _mu = log(stockPrice);
  double _timeToExpiry =
      expiryDate.difference(DateTime.now()).inMinutes / (365 * 24 * 60);
  double _sigma2 = pow(volatility, 2) * _timeToExpiry;
  output = (1 / position) *
      (1 / (sqrt(_sigma2) * sqrt(2 * pi))) *
      exp(-pow(log(position) - _mu, 2) / (2 * _sigma2));
  return output;
}

double logNormCDF({
  @required double stockPrice,
  @required double position,
  @required double volatility,
  @required DateTime expiryDate,
}) {
  double _mu = log(stockPrice);
  double _timeToExpiry =
      expiryDate.difference(DateTime.now()).inMinutes / (365 * 24 * 60);
  double _sigma2 = pow(volatility, 2) * _timeToExpiry;
  double probabiliity =
      0.5 + 0.5 * erf(pow(log(position) - _mu, 2) / (2 * _sigma2));
  return probabiliity;
}

// double normalDist({
//   @required String distribution,
//   @required double stockPrice,
//   @required double position,
//   @required double volatility,
//   @required int expiryDate,
// }) {
//   double probabiliity;

//   if (distribution == 'lognorm') {
//     double _mu = log(stockPrice);
//     double _timeToExpiry =
//         (expiryDate - DateTime.now().millisecondsSinceEpoch / 1000) /
//             (365 * 24 * 60 * 60);
//     double _sigma2 = pow(volatility, 2) * _timeToExpiry;
//     probabiliity = (1 / position) *
//         (1 / (sqrt(_sigma2) * sqrt(2 * pi))) *
//         exp(-pow(log(position) - _mu, 2) / (2 * _sigma2));
//   } else if (distribution == 'lognormCDF') {
//     double _mu =
//         log(pow(stockPrice, 2) / sqrt(pow(stockPrice, 2) + pow(volatility, 2)));
//     double _sigma2 = log(1 + pow(volatility, 2) / pow(stockPrice, 2));
//     probabiliity =
//         0.5 + 0.5 * erf((log(position) - _mu) / (sqrt(2) * sqrt(_sigma2)));
//   } else if (distribution == 'lognormCDF') {
//     double _mu = log(stockPrice);
//     double _timeToExpiry =
//         (expiryDate - DateTime.now().millisecondsSinceEpoch / 1000) /
//             (365 * 24 * 60 * 60);
//     double _sigma2 = pow(volatility, 2) * _timeToExpiry;
//     probabiliity = 0.5 + 0.5 * erf(pow(log(position) - _mu, 2) / (2 * _sigma2));
//   }
//   return probabiliity;
// }

// // double normalDist({
// //   @required String distribution,
// //   @required double stockPrice,
// //   @required double position,
// //   @required double volatility,
// //   @required int expiryDate,
// // }) {
// //   double trueVolatility = stockPrice * volatility;
// //   double probabiliity;
// //   print(volatility);
// //   if (distribution == 'lognorm') {
// //         // Creating distribution parameters
// //     double _mu =
// //         log(pow(stockPrice, 2) / sqrt(pow(stockPrice, 2) + pow(volatility, 2)));
// //     double _sigma2 = log(1 + pow(volatility, 2) / pow(stockPrice, 2));

// //     // Determining the probability
// //     probabiliity = (1 / position) *
// //         (1 / (sqrt(_sigma2) * sqrt(2 * pi))) *
// //         exp(-pow(log(position) - _mu, 2) / (2 * _sigma2));
// //   } else if (distribution == 'lognormCDF') {
// //     double _mu =
// //         log(pow(stockPrice, 2) / sqrt(pow(stockPrice, 2) + pow(volatility, 2)));
// //     double _sigma2 = log(1 + pow(trueVolatility, 2) / pow(stockPrice, 2));
// //     probabiliity =
// //         0.5 + 0.5 * erf((log(position) - _mu) / (sqrt(2) * sqrt(_sigma2)));
// //   }
// //   return probabiliity;
// // }
