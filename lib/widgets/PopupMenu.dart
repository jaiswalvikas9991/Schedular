import 'package:flutter/material.dart';

class PopupMenu extends StatefulWidget {
  PopupMenu({Key key}) : super(key: key);

  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 100,
        width: 100,
        child: PopupMenuButton(
          child: FlutterLogo(),
          itemBuilder: (context) {
            return <PopupMenuItem>[new PopupMenuItem(child: Text('Delete'))];
          },
        ),
      )
    ;
  }
}
