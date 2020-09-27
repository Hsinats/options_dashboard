import 'package:flutter/material.dart';
import 'package:options_dashboard/routes.dart';

void main() {
//  SyncfusionLicense.registerLicense(
//      'NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmgjMiY/fSAnMj06IDsTND4yOj99MDw+');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Color(0xff000066);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Options Dashboard',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            headline2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            subtitle1: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            bodyText2: TextStyle(fontSize: 16),
          ),
          iconTheme: IconThemeData(
            size: 16,
          )),
      initialRoute: '/dashboard',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
