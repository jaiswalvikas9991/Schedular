import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:schedular/widgets/CCheckBox.dart';

class Edit extends StatefulWidget {
  Edit({Key key}) : super(key: key);

  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _headingController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CustomPaint(
              painter: BackPainter(),
              child: SizedBox(
                height: 200,
                width: double.infinity,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Give a Heading to out Task',
                          ),
                          controller: _headingController,
                        ),
                      ),
                      Card(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Describe me your Task',
                          ),
                          controller: _descriptionController,
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'Start Time',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              onPressed: () {
                                DatePicker.showTimePicker(context, showTitleActions: true,
                                    onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                            ),
                            Expanded(
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                'End Time',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              onPressed: () {
                                DatePicker.showTimePicker(context, showTitleActions: true,
                                    onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Priority',
                              style: Theme.of(context).textTheme.body2,
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Rating',
                              style: Theme.of(context).textTheme.body2,
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Alarm',
                              style: Theme.of(context).textTheme.body2,
                            ),
                            Expanded(
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                'Time Here',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Notification',
                              style: Theme.of(context).textTheme.body2,
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            CCheckBox(
                              onTap: () {},
                              value: false,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

    paint.color = Color(0xff89f7fe);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
