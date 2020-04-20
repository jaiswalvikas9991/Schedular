import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/screens/Edit.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:intl/intl.dart';

class PlanCard extends StatefulWidget {
  final bool active;
  final String imageUrl;
  final PlanBloc planBloc;
  final String date;
  PlanCard(this.planBloc, this.active, this.imageUrl, this.date, {Key key})
      : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  String _parseString(String date) {
    List<String> splitString = date.split('-');
    return ("${splitString[1]}/${splitString[2]}/${splitString[0]}");
  }

  @override
  Widget build(BuildContext context) {
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Hero(
      tag: widget.planBloc.id,
      child: Material(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(
              top: widget.active
                  ? MediaQuery.of(context).size.height * 0.05
                  : MediaQuery.of(context).size.height * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.08,
              right: MediaQuery.of(context).size.height * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: widget.active ? Theme.of(context).primaryColor : Colors.transparent,
                  blurRadius: widget.active ? 0 : 0,
                ),
              ],
              image: DecorationImage(
                  image: AssetImage(widget.imageUrl), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(DateFormat.yMMMEd().format(DateFormat.yMd('en_US')
                            .parse(this._parseString(widget.date))) +
                        "\n" +
                        "Task type : " +
                        widget.planBloc.getBucket()),
                    IconButton(
                      icon: Icon(LineIcons.pencil),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => Edit(
                                    widget.imageUrl,
                                    widget.planBloc,
                                    widget.date)));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                    child: StreamBuilder<String>(
                        stream: widget.planBloc.descriptionObservable,
                        initialData: "Describe this awsome task to me...",
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data == ''
                                ? "Describe this awsome task to me..."
                                : snapshot.data,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          );
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    StreamBuilder<bool>(
                        stream: widget.planBloc.isNotificationObservable,
                        initialData: false,
                        builder: (context, snapshot) {
                          return IconButton(
                            icon: Icon(snapshot.data
                                ? Icons.alarm_on
                                : Icons.alarm_off),
                            onPressed: widget.planBloc.updateNotificationState,
                          );
                        }),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _planListBloc.deletePlan(widget.planBloc.id);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
