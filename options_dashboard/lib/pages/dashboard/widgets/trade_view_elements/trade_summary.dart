import 'package:flutter/material.dart';
import 'package:options_dashboard/functions/black_scholes.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/widgets/widgets.dart';

class TradeSummaryMobile extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;
  final TradeInfo trade;

  TradeSummaryMobile({
    @required this.strategy,
    @required this.quote,
    @required this.trade,
  });

  @override
  Widget build(BuildContext context) {
    final double _term =
        trade.expiryDate.difference(DateTime.now()).inMinutes / (365 * 24 * 60);
    final _delta = trade.buyOrSell == BuyOrSell.buy
        ? delta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -delta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _gamma = trade.buyOrSell == BuyOrSell.buy
        ? gamma(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -gamma(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _vega = trade.buyOrSell == BuyOrSell.buy
        ? vega(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -vega(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _theta = trade.buyOrSell == BuyOrSell.buy
        ? theta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -theta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _rho = trade.buyOrSell == BuyOrSell.buy
        ? rho(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -rho(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Table(
        children: [
          buildFourColumnTableRow(
            'delta',
            '${_delta.toStringAsFixed(4)}',
            'gamma',
            '${_gamma.toStringAsFixed(4)}',
          ),
          buildFourColumnTableRow(
            'vega',
            '${_vega.toStringAsFixed(4)}',
            'theta',
            '${_theta.toStringAsFixed(4)}',
          ),
          buildFourColumnTableRow(
            'rho',
            '${_rho.toStringAsFixed(4)}',
            'I.V.',
            '\%${(trade.impliedVolatility * 100).toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class TradeSummaryTablet extends StatelessWidget {
  final Strategy strategy;
  final Quote quote;
  final TradeInfo trade;

  TradeSummaryTablet({
    @required this.strategy,
    @required this.quote,
    @required this.trade,
  });

  @override
  Widget build(BuildContext context) {
    final double _term =
        trade.expiryDate.difference(DateTime.now()).inMinutes / (365 * 24 * 60);
    final _delta = trade.buyOrSell == BuyOrSell.buy
        ? delta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -delta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _gamma = trade.buyOrSell == BuyOrSell.buy
        ? gamma(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -gamma(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _vega = trade.buyOrSell == BuyOrSell.buy
        ? vega(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -vega(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _theta = trade.buyOrSell == BuyOrSell.buy
        ? theta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -theta(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    final _rho = trade.buyOrSell == BuyOrSell.buy
        ? rho(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          )
        : -rho(
            stockPrice: quote.stockPrice,
            strikePrice: trade.strikePrice,
            volatility: trade.impliedVolatility,
            interest: quote.interest,
            term: _term,
            tradeType: trade.tradeType,
          );
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Table(
        children: [
          buildSixColumnTableRow(
            'delta',
            '${_delta.toStringAsFixed(4)}',
            'gamma',
            '${_gamma.toStringAsFixed(4)}',
            'theta',
            '${_theta.toStringAsFixed(4)}',
          ),
          buildSixColumnTableRow(
            'vega',
            '${_vega.toStringAsFixed(4)}',
            'rho',
            '${_rho.toStringAsFixed(4)}',
            'I.V.',
            '\%${(trade.impliedVolatility * 100).toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}
