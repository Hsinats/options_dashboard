// import 'package:options_dashboard/data/quoteData.dart';
// import 'package:web_scraper/web_scraper.dart';
// import 'dart:convert';

// // https://query2.finance.yahoo.com/v7/finance/options/amd

// Future<Quote> getSingleDateStockInformation(Quote quote, int date) async {
//   Map<String, dynamic> rawQuote;
//   bool _error;
//   String errorMessage;
//   final optionsScraper =
//       WebScraper('https://query2.finance.yahoo.com/v7/finance/');
//   if (await optionsScraper
//       .loadWebPage('options/${quote.symbol}?date=$date')
//       .timeout(Duration(seconds: 10), onTimeout: () {
//     return false;
//   })) {
//     rawQuote = jsonDecode(optionsScraper.getPageContent());
//     Set<double> strikes = {};
//     Map<double, Map<String, dynamic>> calls = {};
//     Map<double, Map<String, dynamic>> puts = {};
//     double _callVolatility;
//     double _putVolatility;
//     double firstITM;
//     rawQuote['optionChain']['result'][0]['options'][0]['calls']
//         .forEach((element) {
//       strikes.add(element['strike']);
//       calls[element['strike']] = {
//         'currency': element['currency'],
//         'lastPrice': element['lastPrice'],
//         'bid': element['bid'],
//         'ask': element['ask'],
//         'inTheMoney': element['inTheMoney'],
//         'openInterest': element['openInterest'],
//         'impliedVolatility': element['impliedVolatility'],
//       };
//     });
//     for (double strike in calls.keys) {
//       if (strike >
//           rawQuote['optionChain']['result'][0]['quote']['regularMarketPrice']) {
//         _callVolatility = calls[strike]['impliedVolatility'];
//         firstITM = strike;
//         break;
//       }
//     }
//     rawQuote['optionChain']['result'][0]['options'][0]['puts']
//         .forEach((element) {
//       strikes.add(element['strike']);
//       puts[element['strike']] = {
//         'currency': element['currency'],
//         'lastPrice': element['lastPrice'],
//         'bid': element['bid'],
//         'ask': element['ask'],
//         'inTheMoney': element['inTheMoney'],
//         'openInterest': element['openInterest'],
//         'impliedVolatility': element['impliedVolatility'],
//       };
//     });
//     for (double strike in puts.keys) {
//       if (strike <
//           rawQuote['optionChain']['result'][0]['quote']['regularMarketPrice']) {
//         _putVolatility = puts[strike]['impliedVolatility'];
//         break;
//       }
//     }
//     quote.strikes = strikes.toList();
//     quote.optionsChains[date.toString()] = [calls, puts];
//     quote.impliedVolatility = ((_callVolatility + _putVolatility) / 2);
//     // /sqrt(((((rawQuote['optionChain']['result'][0]['options'][0]
//     //                         ['expirationDate'] +
//     //                     86400) *
//     //                 1000) -
//     //             DateTime.now().millisecondsSinceEpoch) ~/
//     //         86400000) /
//     //     365);
//     quote.firstITM = firstITM;
//   } else {
//     _error = true;
//     errorMessage = 'Could not reach server';
//     quote.error = _error;
//     quote.errorMessage = errorMessage;
//   }
// }
