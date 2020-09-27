// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:options_dashboard/data/option_data.dart';
// import 'package:options_dashboard/data/trade_info.dart';
// import 'package:options_dashboard/functions/get_option_info.dart';

// import 'functions/option_expiry_value.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Options Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final symbolInputController = TextEditingController();
//   Map<int, Map<double, OptionData>> optionDataRaw;

//   bool _lookingUpSymbol = false;
//   String stockSymbol;
//   List<int> expiryDatesList;
//   int expiryDateChosen;
//   List<double> strikePriceList;
//   double strikePriceChosen;
//   List<TradeInfo> tradeList;
//   double sliderValue = 2;
//   double strategyValue;

//   Row buildSymbolInput() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           height: 50,
//           width: 300,
//           child: TextField(
//             controller: symbolInputController,
//           ),
//         ),
//         Container(
//           child: IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () async {
//               setState(() {
//                 _lookingUpSymbol = true;
//                 stockSymbol = symbolInputController.text.toUpperCase();
//                 tradeList = [];
//                 expiryDatesList = [];
//               });
//               optionDataRaw = await optionLookup(stockSymbol);
//               optionDataRaw.forEach((key, value) {
//                 expiryDatesList.add(key);
//               });
//               strikePriceList =
//                   determineStrikePrices(optionDataRaw[expiryDatesList.first]);
//               tradeList.add(TradeInfo(
//                 expiryDate: expiryDatesList.first,
//                 strikePrice: strikePriceList.first,
//                 optionChainFull: optionDataRaw,
//               ));
//               print(tradeList);
//               setState(() {
//                 strategyValue = tradeList[0].quantity *
//                     getOptionExpiryValue(
//                       call: tradeList[0].tradeType == 'Call',
//                       bought: tradeList[0].buyOrSell == 'Buy',
//                       stockPrice: sliderValue,
//                       strikePrice: tradeList[0].strikePrice,
//                       premium: tradeList[0]
//                           .optionChainFull[tradeList[0].expiryDate]
//                               [tradeList[0].strikePrice]
//                           .callPrice,
//                     );
//                 _lookingUpSymbol = false;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   List<double> determineStrikePrices(Map<double, OptionData> optionData) {
//     List<double> strikePriceList = [];
//     optionData.forEach((key, value) {
//       strikePriceList.add(key);
//     });
//     strikePriceList.sort();
//     return strikePriceList;
//   }

//   Container buildTradeRow(
//       TradeInfo tradeInformation, List<int> expiryDatesList) {
//     List<double> strikePriceList = determineStrikePrices(
//         tradeInformation.optionChainFull[tradeInformation.expiryDate]);
//     return Container(
//       padding: EdgeInsets.only(left: 10.0),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               DropdownButton<String>(
//                 value: tradeInformation.buyOrSell,
//                 onChanged: (String newTransactionType) {
//                   setState(() {
//                     tradeInformation.buyOrSell = newTransactionType;
//                   });
//                 },
//                 items: tradeInformation.buySellList
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                       value: value, child: Text(value));
//                 }).toList(),
//               ),
//               DropdownButton<int>(
//                 value: tradeInformation.quantity,
//                 onChanged: (int newQuantity) {
//                   setState(() {
//                     tradeInformation.quantity = newQuantity;
//                   });
//                 },
//                 items: tradeInformation.quantityList.map((int element) {
//                   return new DropdownMenuItem(
//                     value: element,
//                     child: new Text(tradeInformation.tradeType == 'Stock'
//                         ? (element * 100).toString()
//                         : element.toString()), // add a days until
//                   );
//                 }).toList(),
//               ),
//               DropdownButton<String>(
//                 value: tradeInformation.tradeType,
//                 onChanged: (String newTransactionType) {
//                   setState(() {
//                     tradeInformation.tradeType = newTransactionType;
//                   });
//                 },
//                 items: tradeInformation.tradeTypeList
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                       value: value, child: Text(value));
//                 }).toList(),
//               ),
//               DropdownButton<int>(
//                 value: tradeInformation.expiryDate,
//                 onChanged: (int newExipryDate) {
//                   setState(() {
//                     expiryDateChosen = newExipryDate;
//                   });
//                 },
//                 items: expiryDatesList.map((int element) {
//                   return new DropdownMenuItem(
//                     value: element,
//                     child: new Text(
//                         '${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(element * 1000))} (${((element * 1000) - DateTime.now().millisecondsSinceEpoch) ~/ 86400000})'),
//                   );
//                 }).toList(),
//               ),
//               IconButton(
//                 icon: Icon(Icons.remove_circle),
//                 onPressed: () => null,
//               ),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               SizedBox(
//                 width: 20.0,
//               ),
//               DropdownButton(
//                 value: tradeInformation.strikePrice,
//                 onChanged: (double newChosenStrikePrice) {
//                   setState(() {
//                     tradeInformation.strikePrice = newChosenStrikePrice;
//                   });
//                 },
//                 items: strikePriceList.map<DropdownMenuItem<double>>((element) {
//                   return DropdownMenuItem<double>(
//                     child: Text('\$ ${element.toStringAsFixed(2)}'),
//                     value: element,
//                   );
//                 }).toList(),
//               ),
//               Text(tradeInformation.tradeType == "Stock"
//                   ? '\$ 4.20'
//                   : tradeInformation.tradeType == "Call"
//                       ? '\$ ${tradeInformation.optionChainFull[tradeInformation.expiryDate][tradeInformation.strikePrice].callPrice.toStringAsFixed(2)}'
//                       : '\$ ${tradeInformation.optionChainFull[tradeInformation.expiryDate][tradeInformation.strikePrice].putPrice.toStringAsFixed(2)}'),
//               Text(tradeInformation.tradeType == "Stock"
//                   ? '\$ ${(4.20 * tradeInformation.quantity).toStringAsFixed(2)}'
//                   : tradeInformation.tradeType == "Call"
//                       ? '\$ ${(tradeInformation.optionChainFull[tradeInformation.expiryDate][tradeInformation.strikePrice].callPrice * tradeInformation.quantity).toStringAsFixed(2)}'
//                       : '\$ ${(tradeInformation.optionChainFull[tradeInformation.expiryDate][tradeInformation.strikePrice].putPrice * tradeInformation.quantity).toStringAsFixed(2)}'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildOptionInfoOverview() {
//     return Container(
//       padding: EdgeInsets.all(12.0),
//       child: Row(
//         children: <Widget>[
//           Text('${stockSymbol.toUpperCase()}'),
//           SizedBox(
//             width: 5.0,
//           ),
//           Text('STOCK PRICE'),
//           SizedBox(width: 12.0),
//           Text(
//               '\$ ${sliderValue.toStringAsFixed(2)} => Strategy returns \$ ${strategyValue.toStringAsFixed(2)}'), // TODO
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           buildSymbolInput(),
//           !_lookingUpSymbol
//               ? tradeList != null
//                   ? Column(
//                       children: <Widget>[
//                         buildOptionInfoOverview(),
//                         Slider(
//                             value: sliderValue,
//                             max: 250,
//                             min: 0,
//                             onChanged: (newValue) {
//                               strategyValue = 0.0;
//                               tradeList.forEach((element) {
//                                 strategyValue += element.quantity *
//                                     getOptionExpiryValue(
//                                       call: element.tradeType == 'Call',
//                                       bought: element.buyOrSell == 'Buy',
//                                       stockPrice: newValue,
//                                       strikePrice: element.strikePrice,
//                                       premium: element
//                                           .optionChainFull[element.expiryDate]
//                                               [element.strikePrice]
//                                           .callPrice,
//                                     );
//                               });
//                               setState(() {
//                                 sliderValue = newValue;
//                               });
//                             }),
//                         for (TradeInfo trade in tradeList)
//                           buildTradeRow(trade, expiryDatesList),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               tradeList.add(TradeInfo(
//                                 buyOrSell: tradeList.last.buyOrSell,
//                                 tradeType: tradeList.last.tradeType,
//                                 expiryDate: tradeList.last.expiryDate,
//                                 strikePrice: tradeList.last.strikePrice,
//                                 optionChainFull: tradeList.last.optionChainFull,
//                               ));
//                             });
//                           },
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(Icons.add_circle),
//                                 Text('Add a new trade!')
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   : Text('Choose a stock')
//               : LinearProgressIndicator(),
//         ],
//       ),
//     );
//   }
// }
