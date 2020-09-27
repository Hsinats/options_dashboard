import 'dart:math';

import 'package:meta/meta.dart';
import 'package:normal/normal.dart';

void main() {}

double callValue({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double output = Normal.cdf(d1(
              stockPrice: stockPrice,
              strikePrice: strikePrice,
              volatility: volatility,
              interest: interest,
              term: term)) *
          stockPrice -
      strikePrice *
          exp(-interest * term) *
          Normal.cdf(d2(
              stockPrice: stockPrice,
              strikePrice: strikePrice,
              volatility: volatility,
              interest: interest,
              term: term));
  return output;
}

double putValue({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double output = strikePrice *
          exp(-interest * term) *
          Normal.cdf(-d2(
              stockPrice: stockPrice,
              strikePrice: strikePrice,
              volatility: volatility,
              interest: interest,
              term: term)) -
      Normal.cdf(-d1(
              stockPrice: stockPrice,
              strikePrice: strikePrice,
              volatility: volatility,
              interest: interest,
              term: term)) *
          stockPrice;
  return output;
}

d1({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double output = (log(stockPrice / strikePrice) +
          (interest + pow(volatility, 2) / 2) * term) /
      (volatility * sqrt(term));
  return output;
}

d2({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double output = d1(
        stockPrice: stockPrice,
        strikePrice: strikePrice,
        volatility: volatility,
        interest: interest,
        term: term,
      ) -
      volatility * sqrt(term);
  return output;
}
