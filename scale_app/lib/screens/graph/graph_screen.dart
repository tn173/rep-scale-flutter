import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GraphWidget extends StatefulWidget {
//  final ScrollController graphController;
  final List<charts.Series> seriesList;
  final bool animate;

  GraphWidget(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory GraphWidget.withSampleData() {
    return new GraphWidget(
      _createSampleData(),
      animate: false,
    );
  }

  static List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesWeight(new DateTime(2019, 12, 12), 61),
      new TimeSeriesWeight(new DateTime(2019, 12, 26), 63),
      new TimeSeriesWeight(new DateTime(2020, 1, 12), 59),
      new TimeSeriesWeight(new DateTime(2020, 1, 26), 58),
      new TimeSeriesWeight(new DateTime(2020, 2, 12), 61),
      new TimeSeriesWeight(new DateTime(2020, 2, 26), 62),
      new TimeSeriesWeight(new DateTime(2020, 3, 12), 56),
      new TimeSeriesWeight(new DateTime(2020, 3, 26), 64),
      new TimeSeriesWeight(new DateTime(2020, 4, 12), 65),
      new TimeSeriesWeight(new DateTime(2020, 4, 26), 67),
      new TimeSeriesWeight(new DateTime(2020, 5, 12), 69),
      new TimeSeriesWeight(new DateTime(2020, 5, 26), 65),
      new TimeSeriesWeight(new DateTime(2020, 6, 12), 61),
      new TimeSeriesWeight(new DateTime(2020, 6, 26), 65),
      new TimeSeriesWeight(new DateTime(2020, 7, 12), 67),
      new TimeSeriesWeight(new DateTime(2020, 7, 26), 65),
      new TimeSeriesWeight(new DateTime(2020, 8, 12), 59),
      new TimeSeriesWeight(new DateTime(2020, 8, 26), 61),
      new TimeSeriesWeight(new DateTime(2020, 9, 12), 62),
      new TimeSeriesWeight(new DateTime(2020, 9, 26), 65),
      new TimeSeriesWeight(new DateTime(2020, 10, 3), 56),
      new TimeSeriesWeight(new DateTime(2020, 10, 10), 60),
    ];

    return [
      new charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.weight,
        data: data,
      )
    ];
  }

//  GraphWidget({Key key, this.graphController,})
//      : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final DateTime _now = DateTime.now();
  DateTime _oneWeekAgo;
  DateTime _oneMonthAgo;
  DateTime _threeMonthAgo;
  DateTime _oneYearAgo;
  List<charts.Series> _oneWeekList;
  List<charts.Series> _oneMonthList;
  List<charts.Series> _threeMonthList;
  List<charts.Series> _oneYearList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _oneWeekAgo = _now.add(Duration(days: 7) * -1);
    _oneMonthAgo = new DateTime(_now.year, _now.month - 1, _now.day);
    _threeMonthAgo = new DateTime(_now.year, _now.month - 3, _now.day);
    _oneYearAgo = new DateTime(_now.year-1, _now.month - 1, _now.day);

    // TODO 条件に合うデータの抽出
//    _oneWeekList = widget.seriesList.where((n) => n.data)

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('グラフ'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            domainAxis: new charts.DateTimeAxisSpec(
                tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                    day: new charts.TimeFormatterSpec(
                        format: 'd', transitionFormat: 'MM/dd/yyyy'))),
            primaryMeasureAxis: new charts.NumericAxisSpec(
                tickProviderSpec:
                    new charts.BasicNumericTickProviderSpec(zeroBound: false)),
          ),
        ));
  }
}

class TimeSeriesWeight {
  final DateTime time;
  final int weight;

  TimeSeriesWeight(this.time, this.weight);
}
