import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanBloc.dart';

class DateTimeChart extends StatelessWidget {
  final List<PlanBloc> data;

  DateTimeChart({@required this.data});

  List<charts.Series<PlanBloc, DateTime>> _getSeries(
      List<PlanBloc> planListBloc) {
    //* Sorting the planbloc based on the start time
    List<PlanBloc> sortedList = planListBloc.map((element) => element).toList();
    sortedList.sort((PlanBloc arg1, PlanBloc arg2) {
      if (arg1.getFromTime().isBefore(arg2.getFromTime())) return (-1);
      return (1);
    });
    return [
      new charts.Series<PlanBloc, DateTime>(
        id: 'Statistics',
        data: sortedList,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        //* This is x-axis
        domainFn: (PlanBloc planBloc, _) => planBloc.getFromTime(),
        //* This is the y-axis
        measureFn: (PlanBloc planBloc, _) => planBloc.getRating(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: charts.TimeSeriesChart(
      this._getSeries(this.data),
      animate: true,
      defaultRenderer:
          new charts.LineRendererConfig<DateTime>(includePoints: true),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
      behaviors: [
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
      ],
    ));
  }
}
