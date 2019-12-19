import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:schedular/widgets/Rating.dart';

class Edit extends StatefulWidget {
  final String imageUrl;
  final PlanBloc planBloc;
  final String date;
  Edit(this.imageUrl, this.planBloc, this.date, {Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _textController = new TextEditingController();
  bool _isBeingEdited = false;

  String _parseString(String date) {
    List<String> splitString = date.split('-');
    return ("${splitString[1]}/${splitString[2]}/${splitString[0]}");
  }

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
                      DateFormat.yMMMEd().format(DateFormat.yMd('en_US')
                          .parse(this._parseString(widget.date))),
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
                            style: Theme.of(context).textTheme.body2),
                        StreamBuilder<int>(
                          stream: widget.planBloc.ratingObservable,
                          initialData: 0,
                          builder: (context, snapshot) {
                            return Rating(
                              count: 5,
                              onPressed: (int index){
                                widget.planBloc.updateRating(index);
                              },
                              currentIndex: snapshot.data,
                            );
                          }
                        )
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
          style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
        ),
        StreamBuilder<DateTime>(
            stream: widget.planBloc.toTimeObservable,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      onChanged: (time) {}, onConfirm: (time) {
                    widget.planBloc.updateToTime(time);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Row(
                  children: <Widget>[
                    Text(DateFormat.jms().format(snapshot.data),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(fontSize: 18)),
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
          style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
        ),
        StreamBuilder<DateTime>(
            stream: widget.planBloc.fromTimeObservable,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      onChanged: (time) {}, onConfirm: (time) {
                    widget.planBloc.updateFromTime(time);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Row(
                  children: <Widget>[
                    Text(DateFormat.jms().format(snapshot.data),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(fontSize: 18)),
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
                        snapshot.data == '' ? "Description" : snapshot.data,
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
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(widget.imageUrl)),
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
                child: Icon(Icons.arrow_back_ios)),
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
          child: StreamBuilder<bool>(
              stream: widget.planBloc.isNotificationObservable,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: widget.planBloc.updateNotificationState,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                          snapshot.data ? Icons.alarm_on : Icons.alarm_off)),
                );
              }),
        ),
      ),
    );
  }
}
