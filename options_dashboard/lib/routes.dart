import 'package:flutter/material.dart';
import 'package:options_dashboard/home_page.dart';
import 'package:options_dashboard/models/data_structures.dart';
import 'package:options_dashboard/pages/dashboard/dashboard.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';
import 'package:options_dashboard/pages/faq/faq.dart';
import 'package:options_dashboard/pages/playbook/playbook.dart';
import 'package:options_dashboard/pages/playbook/playbook_state.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
        break;
      case '/faq':
        return MaterialPageRoute(builder: (_) => FAQ());
        break;
      case '/playbook':
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<PlaybookState>(
                create: (context) => PlaybookState(index: args ?? 0),
                child: Playbook()));
        break;
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider<DashboardState>(
                  create: (context) => DashboardState()),
              ChangeNotifierProvider<Quote>(create: (context) => Quote()),
              ChangeNotifierProvider<Strategy>(create: (context) => Strategy()),
              ChangeNotifierProvider<StockHistory>(
                  create: (context) => StockHistory()),
            ],
            child: Dashboard(
              passedStrategy: args,
            ),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}

// List<SingleChildWidget> _dashboardProviders = [
//   ChangeNotifierProvider<DashboardState>(create: (context) => DashboardState()),
//   ChangeNotifierProvider<Quote>(create: (context) => Quote()),
//   ChangeNotifierProvider<Strategy>(create: (context) => Strategy()),
//   ChangeNotifierProvider<StockHistory>(create: (context) => StockHistory()),
//   ChangeNotifierProvider<Session>(create: (context) => Session()),
// ];
