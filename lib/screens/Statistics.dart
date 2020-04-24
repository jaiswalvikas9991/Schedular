import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:schedular/utils/FromStream.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/utils/Constants.dart';
import 'package:schedular/widgets/DateTimeChart.dart';
import 'package:schedular/widgets/PlaceHolder.dart';

class Statistics extends StatelessWidget {
  bool _check(List<PlanBloc> planListBloc) {
    for (int i = 0; i < planListBloc.length; i++)
      if (planListBloc[i].getRating() != 0) return (true);
    return (false);
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
                  condition: (List<PlanBloc> data) => data.length != 0,
                  placeholder: PlaceHolder(
                      data:
                          "No data for ${DateFormat.yMMMEd().format(DateTime.now())} \n Go to Plan Tab and \n Click + to add a Plan"),
                  child: (List<PlanBloc> data) {
                    return this._check(data)
                        ? DateTimeChart(data: data)
                        : PlaceHolder(
                            data:
                                "No Ratings Given \n Go to Plan Tab and \n Rate your \n completed Plans.");
                  }),
            ),
            Text("Today", style: Theme.of(context).textTheme.body2),
            Expanded(
              child: FutureBuilder(
                  future: DBProvider.db
                      .getPlanWeek(dateTimeToString(DateTime.now())),
                  builder: (contex, snapshot) {
                    return snapshot.hasData && snapshot.data.length != 0
                        ? this._check(snapshot.data)
                            ? DateTimeChart(data: snapshot.data)
                            : PlaceHolder(data: "No Enough Data")
                        : PlaceHolder(data: "No Enough Data");
                  }),
            ),
            Text("Weekly", style: Theme.of(context).textTheme.body2),
            Expanded(
              child: FutureBuilder(
                  future: DBProvider.db
                      .getPlanMonth(dateTimeToString(DateTime.now())),
                  builder: (contex, snapshot) {
                    return snapshot.hasData && snapshot.data.length != 0
                        ? this._check(snapshot.data)
                            ? DateTimeChart(data: snapshot.data)
                            : PlaceHolder(data: "No Enough Data")
                        : PlaceHolder(data: "No Enough Data");
                  }),
            ),
            Text("Monthly", style: Theme.of(context).textTheme.body2),
          ],
        ),
      ),
    );
  }
}
