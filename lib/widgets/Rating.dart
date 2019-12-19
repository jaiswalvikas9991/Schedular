import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Rating extends StatelessWidget {
  final IconData activeIcon;
  final IconData inActiveIcon;
  final Color activeColor;
  final Color inActiveColor;
  final int count;
  final int currentIndex;
  final Function onPressed;

  Rating(
      {Key key,
      this.activeIcon,
      this.inActiveIcon,
      this.activeColor,
      this.inActiveColor,
      @required this.count,
      @required this.onPressed,
      @required this.currentIndex})
      : super(key: key);

  List<IconButton> _renderIcons(int count, BuildContext context) {
    List<IconButton> returnList = [];
    int currentIndex = this.currentIndex ?? 0;
    for (int i = 0; i < count; i++) {
      returnList.add(IconButton(
        icon: Icon(
          currentIndex >= i ? this.activeIcon ?? LineIcons.star : this.inActiveIcon ?? LineIcons.star_o,
          color: currentIndex >= i ? this.activeColor ?? Theme.of(context).primaryColor : this.inActiveColor ?? Colors.black,
        ),
        onPressed: () {
          this.onPressed(i);
        },
      ));
    }
    return (returnList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: this._renderIcons(this.count, context),
    ));
  }
}
