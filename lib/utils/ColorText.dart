import 'package:flutter/material.dart';

RichText colorText(BuildContext context, {String text, TextStyle style}) {
  return RichText(
    text: TextSpan(text: text, style: style),
  );
}
