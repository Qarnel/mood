import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    backgroundColor: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    brightness: Brightness.light,
    cardTheme: CardTheme(
        color: Colors.blueGrey.shade300,
        elevation: 2.0,
        margin: const EdgeInsetsDirectional.all(3)),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blueGrey.shade300),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.blueGrey.shade300),
            foregroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.grey.shade200))),
    appBarTheme: AppBarTheme(elevation: 3, color: Colors.blueGrey.shade400),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.blueGrey.shade800,
        indicatorSize: TabBarIndicatorSize.tab),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 30,
            color: Colors.blueGrey.shade800,
            overflow: TextOverflow.fade),
        button: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade800,
            overflow: TextOverflow.fade)),
    iconTheme: IconThemeData(color: Colors.blueGrey.shade800),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 3,
        backgroundColor: Colors.blueGrey.shade400,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey.shade700),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey.shade400,
        foregroundColor: Colors.black));

var darkThemeData = ThemeData(
    backgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    brightness: Brightness.dark,
    cardTheme: CardTheme(
        color: Colors.blueGrey.shade600,
        elevation: 2.0,
        margin: const EdgeInsetsDirectional.all(3)),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blueGrey.shade600),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.blueGrey.shade600),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white))),
    appBarTheme: AppBarTheme(elevation: 3, color: Colors.blueGrey.shade800),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.grey.shade200,
        indicatorSize: TabBarIndicatorSize.label),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 30,
            color: Colors.blueGrey.shade200,
            overflow: TextOverflow.fade),
        button: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey.shade200,
            overflow: TextOverflow.fade)),
    iconTheme: IconThemeData(color: Colors.grey.shade200),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 3,
        backgroundColor: Colors.blueGrey.shade700,
        selectedItemColor: Colors.blueAccent.shade200,
        unselectedItemColor: Colors.grey.shade200),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.grey.shade200));
