import 'dart:math';

void main() {}

double normalDist(
    {String distribution,
    double stockPrice,
    double position,
    double volatility}) {
  double trueVolatility = stockPrice * volatility;
  double probabiliity;
  if (distribution == 'normal') {
    probabiliity = 1 /
        (trueVolatility * sqrt(2 * pi)) *
        exp(-0.5 *
            pow((position - stockPrice) / trueVolatility, 2) /
            (2 * pow(trueVolatility, 2)));
  }
  return probabiliity;
}
