import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:options_dashboard/functions/confidence_interval.dart';
import 'package:options_dashboard/models/search_history.dart';
import 'package:options_dashboard/services/symbol_search.dart';
import 'package:options_dashboard/utils/database.dart';
import 'package:web_scraper/web_scraper.dart';

class Quote with ChangeNotifier {
  String rawSymbol, errorMessage;
  double interest = 0.04;
  List<DateTime> expirationDates;
  Duration currentOffset = Duration(hours: 4);
  DateTime defaultExpirationDate;
  Map<DateTime, dynamic> optionsChains = {};
  bool error;
  bool hasOptions;
  Map<DateTime, double> defaultStrikePrice = {}, impliedVolatility = {};
  Map<DateTime, List<double>> callStrikes = {},
      putStrikes = {},
      confidenceInterval = {};
  Map<DateTime, Set<double>> strikes = {};
  // Fundamentals
  String companyName, symbol;
  double stockPrice, stockPriceChange;
  DateTime dividendDate;
  double dividendYield;
  double dividendRate;
  String yearRange, earningsDate;
  String eps;
  int marketCap;
  double peRatio;
  int averageVolume;
  // Map<int, List<ReturnData>> callVolatilitySmile = {}, putVolatilitySmile = {};

  final optionsScraper =
      WebScraper('https://query2.finance.yahoo.com/v7/finance/');

  void updateRawSymbol(String text) {
    rawSymbol = text;
  }

  void setCompany(Company company) {
    rawSymbol = company.symbol;
  }

  Future<void> getQuote(bool initialLookup, {int date}) async {
    String _query;
    if (initialLookup) {
      _query = 'options/$rawSymbol';
    } else {
      _query = 'options/$rawSymbol?date=$date';
    }
    if (await optionsScraper.loadWebPage(_query).timeout(Duration(seconds: 10),
        onTimeout: () {
      return false;
    })) {
      Map<String, dynamic> rawQuote =
          jsonDecode(optionsScraper.getPageContent());
      try {
        print(rawQuote['optionChain']['result'][0]);
        error = false;
      } catch (e) {
        error = true;
        errorMessage = 'Unable to find security with that symbol.';
      }
      if (!error) {
        try {
          print(rawQuote['optionChain']['result'][0]['expirationDates'][0]);
          hasOptions = true;
        } catch (e) {
          hasOptions = false;
          errorMessage = 'This symbol does not have any listed options.';
        }
        if (initialLookup) {
          symbol = rawSymbol;
          stockPrice = rawQuote['optionChain']['result'][0]['quote']
              ['regularMarketPrice'];
          stockPriceChange = rawQuote['optionChain']['result'][0]['quote']
              ['regularMarketChange'];
          companyName =
              rawQuote['optionChain']['result'][0]['quote']['longName'];
          expirationDates = [];
          rawQuote['optionChain']['result'][0]['expirationDates']
              .forEach((date) {
            expirationDates.add(DateTime.fromMillisecondsSinceEpoch(date * 1000)
                .add(Duration(hours: 16, minutes: 30))
                .add(Duration(hours: 4)));
          });
          DBProvider.db.newSearch(SearchHistory(
              symbol, companyName, DateTime.now().millisecondsSinceEpoch));
          try {
            dividendDate = DateTime.fromMillisecondsSinceEpoch(
                rawQuote['optionChain']['result'][0]['quote']['dividendDate'] *
                    1000);
            dividendYield = rawQuote['optionChain']['result'][0]['quote']
                ['trailingAnnualDividendRate'];
            dividendRate = rawQuote['optionChain']['result'][0]['quote']
                ['trailingAnnualDividendYield'];
          } catch (e) {
            dividendDate = null;
            dividendYield = null;
            dividendRate = null;
          }
          try {
            print(rawQuote['optionChain']['result'][0]['quote']
                ['earningsTimestampStart']);
            DateTime earningStart = DateTime.fromMillisecondsSinceEpoch(
                rawQuote['optionChain']['result'][0]['quote']
                        ['earningsTimestampStart'] *
                    1000);
            DateTime earningEnd = DateTime.fromMillisecondsSinceEpoch(
                rawQuote['optionChain']['result'][0]['quote']
                        ['earningsTimestampEnd'] *
                    1000);
            earningStart == earningEnd
                ? earningsDate = DateFormat('MMM-dd').format(earningStart)
                : earningsDate =
                    '${DateFormat('MMM-dd').format(earningStart)} to ${DateFormat('MMM-dd').format(earningEnd)}';
            eps = rawQuote['optionChain']['result'][0]['quote']
                    ['epsTrailingTwelveMonths']
                .toStringAsFixed(2);
          } catch (e) {
            earningsDate = '-';
            eps = '-';
          }
          String yearHigh = rawQuote['optionChain']['result'][0]['quote']
                  ['fiftyTwoWeekHigh']
              .toStringAsFixed(2);
          String yearLow = rawQuote['optionChain']['result'][0]['quote']
                  ['fiftyTwoWeekLow']
              .toStringAsFixed(2);
          yearRange = '$yearLow - $yearHigh';
          marketCap =
              rawQuote['optionChain']['result'][0]['quote']['marketCap'];
          peRatio = rawQuote['optionChain']['result'][0]['quote']['trailingPE'];
          averageVolume = rawQuote['optionChain']['result'][0]['quote']
              ['averageDailyVolume3Month'];
        }
        if (hasOptions) {
          DateTime _activeExpirationDate = DateTime.fromMillisecondsSinceEpoch(
                  rawQuote['optionChain']['result'][0]['options'][0]
                          ['expirationDate'] *
                      1000)
              .add(Duration(hours: 16, minutes: 30))
              .add(Duration(hours: 4));
          if (initialLookup) {
            defaultExpirationDate = _activeExpirationDate;
          }
          Map<double, Map<String, dynamic>> _calls = {};
          Map<double, Map<String, dynamic>> _puts = {};
          double _callVolatility;
          double _putVolatility;
          List _callList =
              rawQuote['optionChain']['result'][0]['options'][0]['calls'];
          List _callRange;
          for (int i = 0; i < _callList.length - 1; i++) {
            if (_callList[i]['inTheMoney'] == false) {
              defaultStrikePrice[_activeExpirationDate] =
                  _callList[i]['strike'];
              _callVolatility = _callList[i]['impliedVolatility'];
              _callRange = _callList.sublist(
                  max(0, i - 10), min(i + 10, _callList.length - 1));
              break;
            } else {
              _callRange = _callList;
            }
          }

          callStrikes[_activeExpirationDate] = [];
          strikes[_activeExpirationDate] = {};
          _callRange.forEach((call) {
            callStrikes[_activeExpirationDate].add(call['strike']);
            strikes[_activeExpirationDate].add(call['strike']);
            _calls[call['strike']] = {
              'currency': call['currency'],
              'lastPrice': call['lastPrice'],
              'bid': call['bid'],
              'ask': call['ask'],
              'inTheMoney': call['inTheMoney'],
              'openInterest': call['openInterest'],
              'impliedVolatility': call['impliedVolatility'],
              'volume': call['volume'],
            };
          });

          List _putList =
              rawQuote['optionChain']['result'][0]['options'][0]['puts'];
          List _putRange;
          for (int i = 0; i < _putList.length - 1; i++) {
            if (_putList[i]['inTheMoney'] != true) {
              _putVolatility = _putList[i]['impliedVolatility'];
              _putRange = _putList.sublist(
                  max(0, i - 10), min(i + 10, _putList.length - 1));
            } else if (i == _putList.length - 1) {
              _putRange = _putList.sublist(
                  max(0, i - 10), min(i + 10, _putList.length - 1));
            } else {
              _putRange = _putList;
            }
          }
          putStrikes[_activeExpirationDate] = [];
          _putRange.forEach((put) {
            putStrikes[_activeExpirationDate].add(put['strike']);
            strikes[_activeExpirationDate].add(put['strike']);
            _puts[put['strike']] = {
              'currency': put['currency'],
              'lastPrice': put['lastPrice'],
              'bid': put['bid'],
              'ask': put['ask'],
              'inTheMoney': put['inTheMoney'],
              'openInterest': put['openInterest'],
              'impliedVolatility': put['impliedVolatility'],
              'volume': put['volume'],
            };
          });
          impliedVolatility[_activeExpirationDate] =
              ((_callVolatility + _putVolatility) / 2);
          confidenceInterval[_activeExpirationDate] =
              determineConfidenceIntervalLogNorm(
                  mean: stockPrice,
                  variance: impliedVolatility[_activeExpirationDate],
                  probability: 0.95,
                  expiryDate: _activeExpirationDate);
          if (initialLookup) {
            optionsChains = {};
          }
          optionsChains[_activeExpirationDate] = [
            _calls,
            _puts,
          ];
        }
      }
    } else {
      error = true;
      errorMessage = 'Could not connect to server';
    }
    notifyListeners();
  }
}
