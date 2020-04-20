import 'dart:async';

import 'package:flutter/material.dart';

class Animate extends StatefulWidget {
  final Widget child;
  final Duration time;
  final Curve curve;
  Animate(
      {@required this.child,
      @required this.time,
      Key key,
      @required this.curve})
      : super(key: key);

  @override
  _AnimateState createState() => _AnimateState();
}

class _AnimateState extends State<Animate> with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    this.animationController =
        AnimationController(duration: Duration(milliseconds: 290), vsync: this);
    this.animation =
        CurvedAnimation(parent: animationController, curve: widget.curve);
    this.timer = Timer(widget.time, animationController.forward);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - animation.value) * 20),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    this.timer.cancel();
    this.animationController.dispose();
  }
}

class Animator extends StatelessWidget {
  final Widget child;
  final Curve curve;
  final int duration;
  Animator({@required this.child, this.curve, this.duration});

  Duration wait() {
    Timer timer;
    Duration duration = Duration();
    if (timer == null || !timer.isActive) {
      timer = Timer(Duration(microseconds: 120), () {
        duration = Duration();
      });
    }
    duration += Duration(milliseconds: this.duration ?? 120);
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Animate(child: child, time: wait(), curve: curve ?? Curves.easeIn);
  }
}
