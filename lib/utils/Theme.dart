import 'package:flutter/material.dart';

ThemeData theme(){

  TextTheme _textTheme(TextTheme base){
    return base.copyWith(
      headline: base.headline.copyWith(
        fontSize: 22,
        color: Colors.white70
      ),
      title: base.title.copyWith(
        fontSize: 18,
        color: Colors.white
      ),
      body1: base.body1.copyWith(
        color: Colors.white,
        fontFamily: "Schyler",
        fontWeight: FontWeight.bold
      ),
      body2: base.body2.copyWith(
        color: Colors.black,
        fontFamily: "Schyler"
      )
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
    primaryColor: Color(0xff48c6ef),
    iconTheme: IconThemeData(color: Colors.white),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xff48c6ef)
    ),
  );
}