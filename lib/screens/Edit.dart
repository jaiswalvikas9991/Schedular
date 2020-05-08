import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:intl/intl.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/widgets/Rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Edit extends StatefulWidget {
  final String imageUrl;
  final PlanBloc planBloc;
  final DateTime date;
  Edit(this.imageUrl, this.planBloc, this.date, {Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _textController;
  bool _isBeingEdited = false;
  List<String> _buckets = new List<String>();

  _EditState() {
    this._textController = new TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    final String bucketKey = "keys";
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      this._buckets = prefs.getStringList(bucketKey) ?? [];
    });
  }

  List<PopupMenuItem<String>> _getPopupMenuItems() {
    List<PopupMenuItem<String>> list = new List<PopupMenuItem<String>>();
    for (int i = 0; i < this._buckets.length; i++)
      list.add(PopupMenuItem(
          value: this._buckets[i],
          child: ListTile(title: Text(this._buckets[i]))));
    return (list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              this._renderImage(context),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FromStream<String>(
                            stream: widget.planBloc.bucketObservable,
                            initialData: "Select a Task Type",
                            child: (String data) {
                              return Text(
                                data.isEmpty ? "Select a Task Type" : data,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              );
                            }),
                        PopupMenuButton(
                          icon: Icon(LineIcons.list,
                              color: Theme.of(context).primaryColor),
                          itemBuilder: (BuildContext context) =>
                              this._getPopupMenuItems(),
                          onSelected: (String bucket) {
                            widget.planBloc.updateBucketState(bucket);
                          },
                        )
                      ],
                    ),
                    Text(
                      DateFormat.yMMMEd('en_US').format(widget.date),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Rating",
                            style: Theme.of(context).textTheme.bodyText2),
                        FromStream<int>(
                            stream: widget.planBloc.ratingObservable,
                            initialData: 0,
                            child: (int data) {
                              return Row(
                                children: <Widget>[
                                  Rating(
                                    count: 5,
                                    onPressed: (int index) {
                                      widget.planBloc.updateRating(index + 1);
                                    },
                                    currentIndex: data,
                                  ),
                                  IconButton(
                                      icon: Icon(LineIcons.close,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        widget.planBloc.updateRating(0);
                                      })
                                ],
                              );
                            })
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          _renderBack(),
          _renderNotificationIcon()
        ],
      ),
    );
  }

  Row _renderEndTime(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "End   : ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
        ),
        FromStream<DateTime>(
            stream: widget.planBloc.toTimeObservable,
            initialData: DateTime.now(),
            child: (DateTime data) {
              return GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: (context) => Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                    height: MediaQuery.of(context).size.height / 3,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (DateTime time){
                        if(time != null) widget.planBloc.updateToTime(time);
                      },
                    ),
                  ));
                },
                child: Row(
                  children: <Widget>[
                    Text(DateFormat.jms().format(data),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 18)),
                    SizedBox(width: 10),
                    Icon(
                      LineIcons.pencil,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              );
            })
      ],
    );
  }

  Row _renderStartTime(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "Start : ",
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
        ),
        FromStream<DateTime>(
            stream: widget.planBloc.fromTimeObservable,
            initialData: new DateTime.now(),
            child: (DateTime data) {
              return GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: (context) => Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                    height: MediaQuery.of(context).size.height / 3,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (DateTime time){
                        if(time != null) widget.planBloc.updateFromTime(time);
                      },
                    ),
                  ));
                },
                child: Row(
                  children: <Widget>[
                    Text(DateFormat.jms().format(data),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 18)),
                    SizedBox(width: 10),
                    Icon(LineIcons.pencil,
                        color: Theme.of(context).primaryColor)
                  ],
                ),
              );
            })
      ],
    );
  }

  Row _renderTextField(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: FromStream<String>(
              stream: widget.planBloc.descriptionObservable,
              initialData: "Description",
              child: (String data) {
                //this._textController.text = snapshot.data;
                return this._isBeingEdited
                    ? TextField(
                        style: TextStyle(
                            fontFamily:
                                Theme.of(context).textTheme.bodyText1.fontFamily),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Enter Desciption...",
                        ),
                        controller: this._textController,
                      )
                    : Text(
                        data == ''
                            ? "Describe this awsome task to me......"
                            : data,
                        style: TextStyle(
                            fontFamily: "Schyler",
                            color: Colors.black),
                      );
              }),
        ),
        IconButton(
          icon: Icon(
            this._isBeingEdited ? LineIcons.save : LineIcons.pencil,
            color: Theme.of(context).primaryColor,
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

  Widget _renderImage(BuildContext context) {
    return Hero(
      tag: widget.planBloc.id,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(widget.imageUrl)),
            borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(MediaQuery.of(context).size.width * 0.5)),
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
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ),
      ),
    );
  }

  Positioned _renderNotificationIcon() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FromStream<bool>(
              stream: widget.planBloc.isNotificationObservable,
              initialData: true,
              child: (bool data) {
                return GestureDetector(
                  onTap: widget.planBloc.updateNotificationState,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        data ? Icons.alarm_on : Icons.alarm_off,
                        color: Theme.of(context).primaryColor,
                      )),
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    this._textController.clear();
    this._textController.dispose();
    super.dispose();
  }
}
