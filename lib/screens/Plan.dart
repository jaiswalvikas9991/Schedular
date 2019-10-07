import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/widgets/DayTray.dart';
import 'package:schedular/widgets/PlanTile.dart';

class Plan extends StatefulWidget {
  Plan({Key key}) : super(key: key);

  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  PlanListBloc _placListBloc = new PlanListBloc();

  List<Widget> renderPlan() {
    return [
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
      Container(height: 400, child: Text('Hello')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: BackPainter(),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.arrow_back),
                    Text('hello')
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                DayTray()
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: Colors.black,
          indent: 20,
          endIndent: 20,
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              PlanTile(heading: 'Heading',trailing: Icons.keyboard_arrow_down,trailingExpanded: Icons.keyboard_arrow_up,)
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _placListBloc.dispose();
  }
}

class BackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = Colors.red;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80,
        size.width * 0.15, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.45,
        size.width * 0.75, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = Color(0xffffaece);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.55,
        size.width * 0.22, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.30, size.height * 0.90,
        size.width * 0.40, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.50,
        size.width * 0.65, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = Color(0xffffaece);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
