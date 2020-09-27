import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

class SecurityDataPoint {
  final double high, low, open, close;
  final int volume;
  final DateTime date;

  SecurityDataPoint({
    this.date,
    this.open,
    this.close,
    this.high,
    this.low,
    this.volume,
  });
}

class StockHistory extends ChangeNotifier {
  List<SecurityDataPoint> history;
  bool error = false;
  String errorMessage;

  Future<void> getStockHistory(String symbol) async {
    final String range = '1mo';
    final String interval = '1d';
    final String query =
        '$symbol?symbol=$symbol/&range=$range&interval=$interval';
    Map<String, dynamic> _rawHistory;
    final optionsScraper =
        WebScraper('https://query1.finance.yahoo.com/v8/finance/chart/');
    if (await optionsScraper.loadWebPage(query).timeout(Duration(seconds: 5),
        onTimeout: () {
      return false;
    })) {
      history = [];
      _rawHistory = jsonDecode(optionsScraper.getPageContent());
      for (int i = 0;
          i < _rawHistory['chart']['result'][0]['timestamp'].length;
          i++) {
        history.add(SecurityDataPoint(
          date: DateTime.fromMillisecondsSinceEpoch(
              _rawHistory['chart']['result'][0]['timestamp'][i] * 1000),
          open: _rawHistory['chart']['result'][0]['indicators']['quote'][0]
              ['open'][i],
          close: _rawHistory['chart']['result'][0]['indicators']['quote'][0]
              ['close'][i],
          high: _rawHistory['chart']['result'][0]['indicators']['quote'][0]
              ['high'][i],
          low: _rawHistory['chart']['result'][0]['indicators']['quote'][0]
              ['low'][i],
          volume: _rawHistory['chart']['result'][0]['indicators']['quote'][0]
              ['volume'][i],
        ));
      }
      error = false;
    } else {
      error = true;
      errorMessage = 'Request timed out';
    }
    notifyListeners();
  }
}
