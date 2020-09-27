// import 'package:options_dashboard/data/quoteData.dart';
// import 'package:web_scraper/web_scraper.dart';
// import 'dart:convert';

// // https://query2.finance.yahoo.com/v7/finance/options/amd

// Future<Quote> getStockInformation(String symbol) async {
//   Map<String, dynamic> rawQuote;
//   Quote quote;
//   bool _error = false;
//   String errorMessage;
//   final optionsScraper =
//       WebScraper('https://query2.finance.yahoo.com/v7/finance/');
//   if (await optionsScraper
//       .loadWebPage('options/$symbol')
//       .timeout(Duration(seconds: 10), onTimeout: () {
//     return false;
//   })) {
//     rawQuote = jsonDecode(optionsScraper.getPageContent());
//     try {
//       print(rawQuote['optionChain']['result'][0]);
//     } catch (e) {
//       _error = true;
//       errorMessage = 'Error looking up symbol.';
//     }
//     try {
//       print(rawQuote['optionChain']['result'][0]['expirationDates'][0]);
//     } catch (e) {
//       _error = true;
//       errorMessage = 'This symbol does not have any listed options.';
//     }
//     if (!_error) {
//       Set<double> strikes = {};
//       Map<double, Map<String, dynamic>> calls = {};
//       Map<double, Map<String, dynamic>> puts = {};
//       double _callVolatility;
//       double _putVolatility;
//       double firstITM;
//       double impliedVolatility;
//       double stockPrice =
//           rawQuote['optionChain']['result'][0]['quote']['regularMarketPrice'];

//       rawQuote['optionChain']['result'][0]['options'][0]['calls']
//           .forEach((element) {
//         strikes.add(element['strike']);
//         calls[element['strike']] = {
//           'currency': element['currency'],
//           'lastPrice': element['lastPrice'],
//           'bid': element['bid'],
//           'ask': element['ask'],
//           'inTheMoney': element['inTheMoney'],
//           'openInterest': element['openInterest'],
//           'impliedVolatility': element['impliedVolatility'],
//         };
//       });
//       rawQuote['optionChain']['result'][0]['options'][0]['puts']
//           .forEach((element) {
//         strikes.add(element['strike']);
//         puts[element['strike']] = {
//           'currency': element['currency'],
//           'lastPrice': element['lastPrice'],
//           'bid': element['bid'],
//           'ask': element['ask'],
//           'inTheMoney': element['inTheMoney'],
//           'openInterest': element['openInterest'],
//           'impliedVolatility': element['impliedVolatility'],
//         };
//       });
//       for (double strike in calls.keys) {
//         if (strike >
//             rawQuote['optionChain']['result'][0]['quote']
//                 ['regularMarketPrice']) {
//           _callVolatility = calls[strike]['impliedVolatility'];
//           firstITM = strike;
//           break;
//         }
//       }
//       for (double strike in puts.keys) {
//         if (strike <
//             rawQuote['optionChain']['result'][0]['quote']
//                 ['regularMarketPrice']) {
//           _putVolatility = puts[strike]['impliedVolatility'];
//           break;
//         }
//       }
//       impliedVolatility = ((_callVolatility + _putVolatility) / 2);
//       quote = Quote(
//         companyName: rawQuote['optionChain']['result'][0]['quote']
//                     ['quoteType'] ==
//                 'EQUITY'
//             ? rawQuote['optionChain']['result'][0]['quote']['displayName']
//             : rawQuote['optionChain']['result'][0]['quote']['quoteSourceName'],
//         symbol: rawQuote['optionChain']['result'][0]['quote']['symbol'],
//         stockPrice: stockPrice,
//         stockPriceChange: rawQuote['optionChain']['result'][0]['quote']
//             ['regularMarketChange'],
//         strikes: strikes.toList(),
//         impliedVolatility: impliedVolatility,
//         expirationDates:
//             rawQuote['optionChain']['result'][0]['expirationDates'].cast<int>(),
//         optionsChains: {
//           rawQuote['optionChain']['result'][0]['options'][0]['expirationDate']
//               .toString(): [
//             calls,
//             puts,
//           ]
//         },
//         firstITM: firstITM,
//         error: false,
//       );
//     } else {
//       quote = Quote(
//         error: true,
//         errorMessage: errorMessage,
//       );
//     }
//   } else {
//     _error = true;
//     errorMessage = 'Could not reach server';
//     quote = Quote(
//       error: _error,
//       errorMessage: errorMessage,
//     );
//   }
//   return quote;
// }
