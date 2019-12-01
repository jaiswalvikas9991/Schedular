import 'package:flutter/material.dart';
import 'package:schedular/screens/Edit.dart';

class PlanCard extends StatefulWidget {
  final bool active;
  PlanCard(this.active, {Key key}) : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOut,
      margin:
          EdgeInsets.only(top: widget.active ? 50 : 200, bottom: 50, right: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: widget.active ? Colors.black : Colors.transparent,
              blurRadius: widget.active ? 30 : 0,
            ),
          ],
          image: DecorationImage(
              image: NetworkImage(
                  "https://images.pexels.com/photos/259698/pexels-photo-259698.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"),
              fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[Text("25TH"), Text("November")],
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Edit()));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(child: Text("Description about the task")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.alarm),
                Icon(Icons.alarm),
              ],
            )
          ],
        ),
      ),
    );
  }
}
