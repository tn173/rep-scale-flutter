import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GraphOldWidget extends StatefulWidget {
  final List<TimeSeriesWeight> data;
  final bool animate;

  GraphOldWidget(this.data, {this.animate});

  factory GraphOldWidget.withSampleData() {
    final _sampleData = [
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

    return new GraphOldWidget(
      _sampleData,
      animate: false,
    );
  }

  @override
  _GraphOldWidgetState createState() => _GraphOldWidgetState();
}

class _GraphOldWidgetState extends State<GraphOldWidget> {
  final double _width = 350;

  final DateTime _now = DateTime.now();
  DateTime _oneWeekAgo;
  DateTime _oneMonthAgo;
  DateTime _threeMonthAgo;
  DateTime _oneYearAgo;
  List<TimeSeriesWeight> _oneWeekList;
  List<TimeSeriesWeight> _oneMonthList;
  List<TimeSeriesWeight> _threeMonthList;
  List<TimeSeriesWeight> _oneYearList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _oneWeekAgo = _now.add(Duration(days: 7) * -1);
    _oneMonthAgo = new DateTime(_now.year, _now.month - 1, _now.day);
    _threeMonthAgo = new DateTime(_now.year, _now.month - 3, _now.day);
    _oneYearAgo = new DateTime(_now.year - 1, _now.month - 1, _now.day);

    // TODO 条件に合うデータの抽出 うまくできていない
    _oneWeekList =
        widget.data.where((n) => n.time.isAfter(_oneWeekAgo)).toList();
    _oneMonthList =
        widget.data.where((n) => n.time.isAfter(_oneMonthAgo)).toList();
    _threeMonthList =
        widget.data.where((n) => n.time.isAfter(_threeMonthAgo)).toList();
    _oneYearList =
        widget.data.where((n) => n.time.isAfter(_oneYearAgo)).toList();
  }

  List<charts.Series<TimeSeriesWeight, DateTime>> _createData(
      List<TimeSeriesWeight> data) {
    return [
      new charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight weight, _) => weight.time,
        measureFn: (TimeSeriesWeight weight, _) => weight.weight,
        data: data,
      )
    ];
  }

  Widget _graphWidget() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 400,
        width: _width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: charts.TimeSeriesChart(
            _createData(_oneYearList),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('グラフ'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_graphWidget()],
        )));
  }
}

class TimeSeriesWeight {
  final DateTime time;
  final int weight;

  TimeSeriesWeight(this.time, this.weight);
}
