import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/screens/Edit.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:intl/intl.dart';

class PlanCard extends StatefulWidget {
  final bool active;
  final String imageUrl;
  final PlanBloc planBloc;
  final DateTime date;
  PlanCard(this.planBloc, this.active, this.imageUrl, this.date, {Key key})
      : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
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
                  color: widget.active
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
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
                    FromStream<String>(
                        stream: widget.planBloc.bucketObservable,
                        child: (String bucket) {
                          return FromStream<int>(
                              stream: widget.planBloc.ratingObservable,
                              child: (int rating) {
                                return Text(
                                    DateFormat.yMMMEd('en_US')
                                            .format(widget.date) +
                                        "\n" +
                                        "Task type : " +
                                        (bucket == '' ? 'Not Added' : bucket) +
                                        '\n' +
                                        'Rating : ' +
                                        (rating == 0 ? "Not Rated" : rating.toString()),
                                    style:
                                        Theme.of(context).textTheme.bodyText1);
                              });
                        }),
                    IconButton(
                      icon: Icon(LineIcons.pencil),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Edit(widget.imageUrl,
                                    widget.planBloc, widget.date)));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                    child: FromStream<String>(
                        stream: widget.planBloc.descriptionObservable,
                        initialData: "Describe this awesome task to me...",
                        child: (String data) {
                          return Text(
                            data == ''
                                ? "Describe this awesome task to me..."
                                : data,
                            style: Theme.of(context).textTheme.bodyText1,
                          );
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FromStream<bool>(
                        stream: widget.planBloc.isNotificationObservable,
                        initialData: false,
                        child: (bool data) {
                          return IconButton(
                            icon: Icon(data ? Icons.alarm_on : Icons.alarm_off),
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
