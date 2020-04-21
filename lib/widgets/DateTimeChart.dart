//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:schedular/bloc/PlanBloc.dart';
// import 'package:charts_flutter/src/text_element.dart';
// import 'package:charts_flutter/src/text_style.dart' as style;

class DateTimeChart extends StatelessWidget {
  final List<PlanBloc> data;
  final List<MaterialColor> color = [
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.green
  ];

  DateTimeChart({@required this.data});

  List<charts.Series<PlanBloc, DateTime>> _getSeries(
      List<PlanBloc> planListBloc, BuildContext context) {
    //* Sorting the planbloc based on the start time
    List<PlanBloc> sortedList = new List<PlanBloc>();
    for (int i = 0; i < planListBloc.length; i++)
      if (planListBloc[i].getRating() != 0) sortedList.add(planListBloc[i]);
    sortedList.sort((PlanBloc arg1, PlanBloc arg2) {
      if (arg1.getFromTime().isBefore(arg2.getFromTime())) return (-1);
      return (1);
    });
    return [
      new charts.Series<PlanBloc, DateTime>(
          id: 'Statistics',
          data: sortedList,
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
          //* This is x-axis
          domainFn: (PlanBloc planBloc, _) => planBloc.getFromTime(),
          //* This is the y-axis
          measureFn: (PlanBloc planBloc, _) => planBloc.getRating(),
          fillColorFn: (PlanBloc planBloc, int _) =>
              charts.ColorUtil.fromDartColor(
                  this.color[planBloc.getRating() - 1])),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: charts.TimeSeriesChart(
      this._getSeries(this.data, context),
      animate: true,
      defaultRenderer:
          new charts.LineRendererConfig<DateTime>(includePoints: true),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.AxisSpec(showAxisLine: true),
      behaviors: [
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
        //LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      domainAxis: new charts.EndPointsTimeAxisSpec(),

      // selectionModels: [
      //   SelectionModelConfig(
      //     changedListener: (SelectionModel model) {
      //       if(model.hasDatumSelection)
      //         print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
      //     }
      //   )
      // ],
    ));
  }
}

// class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
//   @override
//   void paint(ChartCanvas canvas, Rectangle<num> bounds,
//       {List<int> dashPattern,
//       Color fillColor,
//       Color strokeColor,
//       double strokeWidthPx}) {
//     super.paint(canvas, bounds,
//         dashPattern: dashPattern,
//         fillColor: fillColor, //* This is the color that comes to the selected point
//         strokeColor: strokeColor,
//         strokeWidthPx: strokeWidthPx);
//     canvas.drawRect(Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
//             bounds.height + 10),
//         fill: Color.black);
//     var textStyle = style.TextStyle();
//     textStyle.color = Color.black;
//     textStyle.fontSize = 15;
//     canvas.drawText(TextElement("1", style: textStyle), (bounds.left).round(),
//         (bounds.top - 28).round());
//   }
// }
