import 'package:flutter/material.dart';
import 'package:schedular/screens/Edit2.dart';
import 'package:schedular/widgets/CCheckBox.dart';

class PlanTile extends StatefulWidget {
  final Icon leading;
  final String heading;
  final Icon trailing;
  final Icon trailingExpanded;
  const PlanTile(
      {Key key,
      this.leading,
      this.heading,
      this.trailing,
      this.trailingExpanded})
      : super(key: key);

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  bool isExpanded = true;

  Widget renderExpandedWidgets() {
    return Column(
      children: <Widget>[
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Task Description',
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          height: 20,
        ),
        this.renderBottom()
      ],
    );
  }

  Widget renderBottom() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            FlatButton(
                child: Text(
                  'Priority',
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () {}),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff70e698),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xfff5f887),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff8db8f5),
                  ),
                ),
              ],
            )
          ],
        ),
        Expanded(child: Container()),
        Column(
          children: <Widget>[
            FlatButton(
                child: Text(
                  'Rating',
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () {}),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff70e698),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xfff5f887),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff8db8f5),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff66a6ff)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        widget.leading ?? Container(),
                        Text(
                          widget.heading,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Expanded(child: Container()),
                        widget.trailing != null
                            ? IconButton(
                                icon: this.isExpanded
                                    ? widget.trailingExpanded ??
                                        Icon(Icons.keyboard_arrow_down)
                                    : widget.trailing ??
                                        Icon(Icons.keyboard_arrow_up),
                                onPressed: () {
                                  setState(() {
                                    this.isExpanded = !this.isExpanded;
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                    this.isExpanded ? renderExpandedWidgets() : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Edit()),
                  );
                },
              ),
              Container(
                height: 1,
                width: 10,
                color: Colors.black,
              ),

              CCheckBox(
                value: true,
                onTap: (){},
              ),

              Container(
                height: 1,
                width: 10,
                color: Colors.black,
              ),

              IconButton(
                icon: Icon(Icons.alarm_off,color: Colors.blue,),
                onPressed: (){},
              )

            ],
          ),
        )
      ],
    );
  }
}
