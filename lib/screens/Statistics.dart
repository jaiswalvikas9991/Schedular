import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/widgets/DateTimeChart.dart';

class Statistics extends StatelessWidget {
  //* This checks if there is atleast on rating which is nonzero and can be displayed
  bool _check(List<PlanBloc> planListBloc) {
    for (int i = 0; i < planListBloc.length; i++)
      if (planListBloc[i].getRating() != 0) return (true);
    return (false);
  }

  Widget _renderBlur(BuildContext context, {String string}) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text("No Data",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: FromStream<List<PlanBloc>>(
                  stream: _planListBloc.allPlanObservable,
                  initialData: <PlanBloc>[],
                  child: (List<PlanBloc> data) {
                    return Stack(
                      children: <Widget>[
                        DateTimeChart(data: this._check(data) ? data : []),
                        !this._check(data)
                            ? this._renderBlur(context)
                            : SizedBox.shrink()
                      ],
                    );
                  }),
            ),
            Text("Today", style: Theme.of(context).textTheme.bodyText2),
            Expanded(
              child: FutureBuilder(
                  future: DBProvider.db
                      .getPlanWeek(new DateTime.now()),
                  builder: (contex, snapshot) {
                    return Stack(
                      children: <Widget>[
                        DateTimeChart(
                            data: snapshot.hasData && this._check(snapshot.data)
                                ? snapshot.data
                                : []),
                        snapshot.hasData && !this._check(snapshot.data)
                            ? this._renderBlur(context)
                            : SizedBox.shrink()
                      ],
                    );
                  }),
            ),
            Text("Weekly", style: Theme.of(context).textTheme.bodyText2),
            Expanded(
              child: FutureBuilder(
                  future: DBProvider.db
                      .getPlanMonth(new DateTime.now()),
                  builder: (contex, snapshot) {
                    return Stack(
                      children: <Widget>[
                        DateTimeChart(
                            data: snapshot.hasData && this._check(snapshot.data)
                                ? snapshot.data
                                : []),
                        snapshot.hasData && !this._check(snapshot.data)
                            ? this._renderBlur(context)
                            : SizedBox.shrink()
                      ],
                    );
                  }),
            ),
            Text("Monthly", style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}
