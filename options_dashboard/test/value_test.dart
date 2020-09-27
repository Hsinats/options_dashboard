import 'package:flutter/foundation.dart';

double getOptionExpiryValue(
    {@required bool call,
    @required bool bought,
    @required double strikePrice,
    @required double stockPrice,
    @required double premium}) {
  double optionValue;

  if (call) {
    if (stockPrice > strikePrice) {
      optionValue = stockPrice - strikePrice - premium;
    } else {
      optionValue = -premium;
    }
    if (!bought) {
      optionValue = -optionValue;
    }
  } else {
    if (stockPrice < strikePrice) {
      optionValue = strikePrice - stockPrice - premium;
    } else {
      optionValue = -premium;
    }
    if (!bought) {
      optionValue = -optionValue;
    }
  }

  return optionValue;
}
