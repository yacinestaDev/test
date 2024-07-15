import 'package:amir_diet/utils/app_constants.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../extensions/extension_util/context_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/graph_response.dart';
import '../utils/app_colors.dart';

enum ChartType { CHART1, CHART2, CHART3 }

class HorizontalBarChart extends StatelessWidget {
  final List<GraphModel>? seriesList;

  HorizontalBarChart(this.seriesList);

  final List<GraphModel> data = [];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      series: getDefaultData3(),
      backgroundColor: context.cardColor,
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        maximumZoomLevel: 0.85,
      ),
      selectionType: SelectionType.series,
      primaryXAxis: CategoryAxis(
          interval: 1,
          isInversed: true,
          axisLine: AxisLine(
              color:
                  userStore.gender == MALE ? scaffoldColorDark : primaryColor)),
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<CartesianSeries> getDefaultData3() {
    // List<ChartSeries> getDefaultData3() {
    final List<GraphModel> chartData = [];
    seriesList!.forEach((element) {
      chartData.add(GraphModel(date: element.date, value: element.value));
    });
    return <CartesianSeries<dynamic, String>>[
      SplineAreaSeries<GraphModel, String>(
          dataSource: chartData,
          enableTooltip: true,
          isVisibleInLegend: false,
          borderWidth: 2,
          gradient: LinearGradient(
            colors: <Color>[
              appStore.isDarkMode == true
                  ? scaffoldBackgroundColor
                  : Colors.white,
              primaryColor
            ],
            stops: <double>[0.03, 0.9],
            end: Alignment.topCenter,
            begin: Alignment.bottomCenter,
          ),
          borderColor:
              userStore.gender == MALE ? scaffoldColorDark : primaryColor,
          borderDrawMode: BorderDrawMode.excludeBottom,
          animationDuration: 1000,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside),
          markerSettings: MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
              shape: DataMarkerType.circle,
              borderWidth: 2,
              borderColor:
                  userStore.gender == MALE ? scaffoldColorDark : primaryColor),
          xValueMapper: (GraphModel data, _) => data.date.toString(),
          yValueMapper: (GraphModel data, _) =>
              double.parse(data.value.toString()),
          emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average))
    ];
  }
}
