import 'dart:math';
import 'package:meta/meta.dart';
import 'package:normal/normal.dart';
import 'package:options_dashboard/models/trade_info.dart';

void main() {}

double callValue({
  @required double stockPrice,
  @required double strikePrice,
  @required double volatility,
  @required double interest,
  @required double term,
}) {
  double d_1 = d1(
      stockPrice: stockPrice,
      strikePrice: strikePrice,
      volatility: volatility,
      interest: interest,
      term: term);
  double d_2 = d_1 - volatility * sqrt(term);
  double value = Normal.cdf(d_1) * stockPrice -
      strikePrice * exp(-interest * term) * Normal.cdf(d_2);
  return value;
}

double putValue({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double d_1 = d1(
      stockPrice: stockPrice,
      strikePrice: strikePrice,
      volatility: volatility,
      interest: interest,
      term: term);
  double d_2 = d_1 - volatility * sqrt(term);
  double value = -Normal.cdf(-d_1) * stockPrice +
      strikePrice * exp(-interest * term) * Normal.cdf(-d_2);
  return value;
}

d1({
  @required double stockPrice,
  @required strikePrice,
  @required volatility,
  @required interest,
  @required term,
}) {
  double relativePrice = stockPrice / strikePrice;
  double output;
  if (relativePrice == 1) {
    output = 0;
  } else {
    output = (log(relativePrice) + (interest + pow(volatility, 2) / 2) * term) /
        (volatility * sqrt(term));
  }
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

double delta(
    {@required double stockPrice,
    @required strikePrice,
    @required volatility,
    @required interest,
    @required term,
    @required TradeType tradeType}) {
  double output;
  if (tradeType == TradeType.call) {
    output = Normal.cdf(d1(
        stockPrice: stockPrice,
        strikePrice: strikePrice,
        volatility: volatility,
        interest: interest,
        term: term));
  } else {
    output = 1 -
        Normal.cdf(d1(
            stockPrice: stockPrice,
            strikePrice: strikePrice,
            volatility: volatility,
            interest: interest,
            term: term));
  }
  // String outputString = output.toStringAsFixed(4);
  return output;
}

double gamma(
    {@required double stockPrice,
    @required strikePrice,
    @required volatility,
    @required interest,
    @required term,
    @required TradeType tradeType}) {
  double output = nPrime(d1(
          stockPrice: stockPrice,
          strikePrice: strikePrice,
          volatility: volatility,
          interest: interest,
          term: term)) /
      (stockPrice * volatility * sqrt(term));
  output *= 10000;
  return output;
}

double vega(
    {@required double stockPrice,
    @required strikePrice,
    @required volatility,
    @required interest,
    @required term,
    TradeType tradeType = TradeType.call}) {
  double output = stockPrice *
      nPrime(d1(
          stockPrice: stockPrice,
          strikePrice: strikePrice,
          volatility: volatility,
          interest: interest,
          term: term)) *
      sqrt(term);
  output *= 100;
  return output;
}

double theta(
    {@required double stockPrice,
    @required strikePrice,
    @required volatility,
    @required interest,
    @required term,
    TradeType tradeType = TradeType.call}) {
  double output;
  if (tradeType == TradeType.call) {
    output = -stockPrice *
            nPrime(d1(
                stockPrice: stockPrice,
                strikePrice: strikePrice,
                volatility: volatility,
                interest: interest,
                term: term)) *
            volatility /
            (2 * sqrt(term)) -
        interest *
            strikePrice *
            exp(-interest * term) *
            Normal.cdf(d2(
                stockPrice: stockPrice,
                strikePrice: strikePrice,
                volatility: volatility,
                interest: interest,
                term: term));
  } else {
    output = -stockPrice *
            nPrime(d1(
                stockPrice: stockPrice,
                strikePrice: strikePrice,
                volatility: volatility,
                interest: interest,
                term: term)) *
            volatility /
            (2 * sqrt(term)) +
        interest *
            strikePrice *
            exp(-interest * term) *
            Normal.cdf(-d2(
                stockPrice: stockPrice,
                strikePrice: strikePrice,
                volatility: volatility,
                interest: interest,
                term: term));
  }
  return output;
}

rho(
    {@required double stockPrice,
    @required strikePrice,
    @required volatility,
    @required interest,
    @required term,
    TradeType tradeType = TradeType.call}) {
  double output;
  if (tradeType == TradeType.call) {
    output = strikePrice *
        term *
        exp(interest * term) *
        Normal.cdf(d2(
            stockPrice: stockPrice,
            strikePrice: strikePrice,
            volatility: volatility,
            interest: interest,
            term: term));
  } else {
    output = -strikePrice *
        term *
        exp(interest * term) *
        Normal.cdf(d2(
            stockPrice: stockPrice,
            strikePrice: strikePrice,
            volatility: volatility,
            interest: interest,
            term: term));
  }
  output /= 100;
  return output;
}

double nPrime(x) {
  double output = 1 / (sqrt(2 * pi)) * exp(-pow(x, 2) / 2);
  output /= 10000;
  return output;
}
