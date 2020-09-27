import 'dart:math';

import 'package:options_dashboard/models/data_structures.dart';

void main() {
  mcROR(1.5, 0.4, 0.1, 100).forEach((element) {
    print(element.value);
  });
}

List<ReturnData> mcROR(
    double payoffRation, double prob, double riskSize, int trades) {
  List<ReturnData> simResults = [];
  Random rng = Random(420);

  simResults.add(ReturnData(0, 1));
  for (int i = 0; i < trades; i++) {
    // print(rng.nextDouble());
    if (rng.nextDouble() <= prob) {
      print('above');
      simResults.add(ReturnData(
          (i + 1).toDouble(), simResults[i].value + riskSize * payoffRation));
    } else {
      print('below');
      ReturnData((i + 1).toDouble(), simResults[i].value - riskSize);
    }
  }

  return simResults;
}

// print(riskOfRuin(2, .33333333, .01, 1));

// double riskOfRuin(
//   double payoffRatio, // payoff ratio
//   double prob, // pop
//   double riskSize, // % of portfolio per trade
//   double level, // max loss tolerance
// ) {
//   double avWin = riskSize * payoffRatio;
//   double avLoss = riskSize;

//   double z = prob * avWin - (1 - prob) * avLoss;

//   double a = sqrt(prob * pow(avWin, 2) + (1 - prob) * pow(avLoss, 2));

//   double p = 0.5 * (1 + z / a);

//   double ror = pow(((1 - p) / p), level / a);

//   double output = ror * 100;
//   return output;
//   // double avgWin = payoffRatio * riskSize;
//   // double avgLoss = riskSize;
//   // double ev = prob * avgWin - (1 - prob) * avgLoss;
//   // double e2 = prob * pow(avgWin, 2) - (1 - prob) * pow(avgLoss, 2);
//   // double p = 0.5 * ev / (2 * sqrt(e2));

//   // double ror = pow(((1 - p) / p), level * sqrt(e2));

//   // double output = ror;
//   // return output;
// }
