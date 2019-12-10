import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/PlanListBloc.dart';
import 'package:schedular/utils/Provider.dart';

class DateTimeChart extends StatelessWidget {
  List<charts.Series<PlanBloc, DateTime>> _getSeries(
      List<PlanBloc> planListBloc) {
    return [
      new charts.Series<PlanBloc, DateTime>(
        id: 'Statistics',
        data: planListBloc,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PlanBloc planBloc, _) => planBloc.getFromTime(),
        measureFn: (PlanBloc planBloc, _) => planBloc.getRating(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Scaffold(
      body: StreamBuilder<List<PlanBloc>>(
          stream: _planListBloc.allPlanObservable,
          builder: (context, AsyncSnapshot<List<PlanBloc>> snapshot) {
            return (snapshot.hasData
                ? charts.TimeSeriesChart(
                    this._getSeries(snapshot.data),
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    primaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
                    secondaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
                  )
                : Container());
          }),
    );
  }
}
