import 'package:flutter/material.dart';

class CCheckBox extends StatefulWidget {
  final Function onTap;
  final Color activeColor;
  final Color notActiveColor;
  final bool value;
  CCheckBox({Key key, @required this.onTap,this.activeColor,this.notActiveColor, @required this.value}) : super(key: key);

  _CCheckBoxState createState() => _CCheckBoxState();
}

class _CCheckBoxState extends State<CCheckBox> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
          child: InkWell(
        onTap: widget.onTap ?? (){},
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.value
                ? Icon(
                    Icons.check_circle,
                    size: 22.0,
                    color: widget.activeColor ?? Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.check_circle_outline,
                    size:22.0,
                    color: widget.notActiveColor ?? Theme.of(context).primaryColor,
                  ),
          ),
        
      ));
  }
}