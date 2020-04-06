import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  final String data;
  const PlaceHolder({@required this.data, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(this.data,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(color: Color(0xff48c6ef), fontFamily: "Schyler")),
    );
  }
}
