import 'dart:math';
import 'package:meta/meta.dart';

List<double> determineConfidenceIntervalLogNorm({
  @required double mean,
  @required double variance,
  @required double probability,
  @required DateTime expiryDate,
}) {
  double lowerLimit;
  double upperLimit;
  double lower1SD;
  double upper1SD;
  double lower3SD;
  double upper3SD;
  double _mu = log(mean);
  DateTime _now = DateTime.now();
  double _timeToExpiry =
      expiryDate.difference(_now).inMinutes / (365 * 24 * 60);
  double _sigma2 = pow(variance, 2) * _timeToExpiry;

  // Creating range
  upperLimit = exp(_mu + 1.96 * sqrt(_sigma2));
  lowerLimit = exp(_mu - 1.96 * sqrt(_sigma2));
  upper1SD = exp(_mu + 1 * sqrt(_sigma2));
  lower1SD = exp(_mu - 1 * sqrt(_sigma2));
  upper3SD = exp(_mu + 4 * sqrt(_sigma2));
  lower3SD = exp(_mu - 4 * sqrt(_sigma2));

  return [lowerLimit, upperLimit, lower1SD, upper1SD, lower3SD, upper3SD];
}
