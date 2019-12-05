import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/screens/Edit.dart';
import 'package:schedular/utils/Provider.dart';

class PlanCard extends StatefulWidget {
  final bool active;
  final String imageUrl;
  final PlanBloc planBloc;
  PlanCard(this.planBloc, this.active, this.imageUrl, {Key key})
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
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
                color: widget.active ? Colors.black : Colors.transparent,
                blurRadius: widget.active ? 30 : 0,
              ),
            ],
            image: DecorationImage(
                image: NetworkImage(widget.imageUrl), fit: BoxFit.cover)),
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
                    icon: Icon(LineIcons.pencil),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 800),
                              pageBuilder: (_, __, ___) =>
                                  Edit(widget.imageUrl, widget.planBloc)));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                  child: StreamBuilder<Object>(
                      stream: widget.planBloc.descriptionObservable,
                      initialData: "Describe this awsome task to me......",
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data == '' ? "Describe this awsome task to me......" : snapshot.data,
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
                          icon: Icon(
                              snapshot.data ? Icons.alarm : Icons.alarm_add),
                          onPressed: () {},
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
    );
  }
}
