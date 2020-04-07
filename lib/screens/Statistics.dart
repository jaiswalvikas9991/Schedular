import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/utils/Provider.dart';
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
      body: StreamBuilder<List<PlanBloc>>(
          stream: _planListBloc.allPlanObservable,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data.length != 0
                ? this._check(snapshot.data)
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DateTimeChart(data: snapshot.data),
                      )
                    : PlaceHolder(
                        data:
                            "No Ratings Given \n Go to Plan Tab and \n Rate your \n completed Plans.")
                : PlaceHolder(
                    data:
                        "No data for ${DateFormat.yMMMEd().format(DateTime.now())} \n Go to Plan Tab and \n Click + to add a Plan");
          }),
    );
  }
}
