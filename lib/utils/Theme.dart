import 'package:flutter/material.dart';

ThemeData theme({Color primaryColor = const Color(0xff48c6ef), bool dark = false}) {
  final ThemeData base = dark ? ThemeData.dark() :ThemeData.light();

  TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
        headline5: base.headline5.copyWith(
            fontSize: 22, color: Colors.white70, fontFamily: "Schyler"),
        headline6: base.headline6.copyWith(fontSize: 18, color: Colors.white),
        bodyText1: base.bodyText1.copyWith(
            color: Colors.white,
            fontFamily: "Schyler",
            fontWeight: FontWeight.bold),
        bodyText2: base.bodyText2
            .copyWith(color: Colors.black, fontFamily: "Schyler"));
  }

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
    primaryColor: primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: base.floatingActionButtonTheme
        .copyWith(backgroundColor: Colors.white, foregroundColor: primaryColor),
  );
}
