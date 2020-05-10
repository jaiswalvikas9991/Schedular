import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  final String data;
  final double fontSize;
  const PlaceHolder({@required this.data, this.fontSize, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(this.data,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Theme.of(context).primaryColor, fontFamily: "Schyler", fontSize: this.fontSize)),
    );
  }
}
