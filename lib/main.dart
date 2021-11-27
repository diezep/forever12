import 'package:flutter/material.dart';
import 'package:forever12/pages/home_cashier.dart';
import 'package:forever12/pages/home_client.dart';
import 'package:forever12/pages/home_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLIENTE',
      home: HomeManagerScreen(),
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16))),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            primary: Colors.black,
          )),
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.black,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.orange,
                    // secondary will be the textColor, when the textTheme is set to accent
                    secondary: Colors.white,
                  ))),
    );
  }
}
