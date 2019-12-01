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
        color: Colors.white
      ),
      body2: base.body2.copyWith(
        color: Colors.black,
      )
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
    primaryColor: Color(0xff0085FF),
    iconTheme: IconThemeData(color: Colors.white),
  );
}