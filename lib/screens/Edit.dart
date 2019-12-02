import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanBloc.dart';

class Edit extends StatefulWidget {
  final String imageUrl;
  final PlanBloc planBloc;
  Edit(this.imageUrl, this.planBloc, {Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _textController = new TextEditingController();
  bool _isBeingEdited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              this._renderImage(context),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "30 TH Novemeber",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _renderStartTime(context),
                    SizedBox(
                      height: 5,
                    ),
                    _renderEndTime(context),
                    SizedBox(
                      height: 10,
                    ),
                    _renderTextField(context),
                    Row(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.alarm,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Rating",
                            style: Theme.of(context).textTheme.body2),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                LineIcons.star_o,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.star_o,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.star_o,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.star_o,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.star_o,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          _renderBack(),
        ],
      ),
    );
  }

  Row _renderEndTime(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "End : ",
          style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: <Widget>[
              Text("time",
                  style:
                      Theme.of(context).textTheme.body2.copyWith(fontSize: 18)),
              Icon(
                LineIcons.pencil,
                color: Colors.black,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _renderStartTime(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "Start : ",
          style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: <Widget>[
              Text("time",
                  style:
                      Theme.of(context).textTheme.body2.copyWith(fontSize: 18)),
              Icon(
                LineIcons.pencil,
                color: Colors.black,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _renderTextField(BuildContext context) {
    return Row(
      children: <Widget>[
        StreamBuilder<String>(
            stream: widget.planBloc.descriptionObservable,
            initialData: "Description",
            builder: (context, snapshot) {
              this._textController.text = snapshot.data;
              return Expanded(
                child: this._isBeingEdited
                    ? TextField(
                        style: TextStyle(fontFamily: "Schyler", fontSize: 35),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _textController,
                      )
                    : Text(
                        snapshot.data,
                        style: TextStyle(
                            fontFamily: "Schyler",
                            fontSize: 35,
                            color: Colors.black),
                      ),
              );
            }),
        IconButton(
          icon: Icon(
            this._isBeingEdited ? LineIcons.save : LineIcons.pencil,
            color: Color(0xff48c6ef),
          ),
          onPressed: () {
            this.setState(() {
              if (this._isBeingEdited == true &&
                  this._textController.text != '') {
                widget.planBloc.updateDescription(this._textController.text);
              }
              setState(() {
                this._isBeingEdited = !this._isBeingEdited;
              });
            });
          },
        )
      ],
    );
  }

  Hero _renderImage(BuildContext context) {
    return Hero(
      tag: widget.planBloc.id,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          transform: Matrix4.translationValues(
              MediaQuery.of(context).size.width * -0.2,
              MediaQuery.of(context).size.height * -0.1,
              0),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(widget.imageUrl)),
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width)),
            color: Colors.redAccent,
          )),
    );
  }

  Positioned _renderBack() {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back_ios)),
          ),
        ),
      ),
    );
  }
}
