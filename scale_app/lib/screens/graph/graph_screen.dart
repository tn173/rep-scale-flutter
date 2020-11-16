import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphWidget extends StatefulWidget {
  final List<TimeSeriesWeight> data;

  GraphWidget(this.data);

  factory GraphWidget.withSampleData() {
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

    return new GraphWidget(
      _sampleData,
    );
  }

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
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
    super.initState();
    _oneWeekAgo = _now.add(Duration(days: 7) * -1);
    _oneMonthAgo = new DateTime(_now.year, _now.month - 1, _now.day);
    _threeMonthAgo = new DateTime(_now.year, _now.month - 3, _now.day);
    _oneYearAgo = new DateTime(_now.year - 1, _now.month - 1, _now.day);

    _oneWeekList =
        widget.data.where((n) => n.time.isAfter(_oneWeekAgo)).toList();
    _oneMonthList =
        widget.data.where((n) => n.time.isAfter(_oneMonthAgo)).toList();
    _threeMonthList =
        widget.data.where((n) => n.time.isAfter(_threeMonthAgo)).toList();
    _oneYearList =
        widget.data.where((n) => n.time.isAfter(_oneYearAgo)).toList();
  }

  Widget _graphWidget(List<TimeSeriesWeight> data, DateTime start) {
    return Padding(
        padding: const EdgeInsets.all(24.0), child: sample(data, start));
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
          children: <Widget>[_graphWidget(_threeMonthList, _threeMonthAgo)],
        )));
  }

  Widget sample(List<TimeSeriesWeight> data, DateTime start) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');

    const base_number = 10;
    List<FlSpot> spot = [];
    List<double> weightList = [];
    data.forEach((element) {
      weightList.add(element.weight);
    });
    var maxX = _now.difference(start).inDays;
    // 少し大きい(小さい)10で割り切れる数を境界に設定
    var maxYValue = (weightList.reduce(max) / base_number).ceil() * base_number;
    var minYValue =
        (weightList.reduce(min) / base_number).floor() * base_number;
    data.forEach((element) {
      var x = element.time.difference(start).inDays.toDouble();
      var y = element.weight;
      spot.add(FlSpot(x, y));
    });

    print('maxX:$maxX');

    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return data == []
        ? Container()
        : LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX.toDouble(),
              minY: minYValue.toDouble(),
              maxY: maxYValue.toDouble(),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  interval: 1.0,
                  showTitles: true,
                  reservedSize: 35,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  getTitles: (value) {
                    if (value.toInt() == 0) {
                      return formatter.format(start);
                    } else if (value.toInt() == maxX) {
                      return formatter.format(_now);
                    }
                    return '';
                  },
                  margin: 8,
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff67727d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  getTitles: (value) {
                      if (value.toInt()%5 == 0 && value.toInt() !=minYValue && value.toInt() != maxYValue) {
                        return value.toInt().toString();
                      }
                    return '';
                  },
                  reservedSize: 35,
                  margin: 12,
                ),
              ),
              gridData: FlGridData(
                horizontalInterval: 1.0,
                verticalInterval: 1.0,
                show: true,
                drawVerticalLine: true,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spot,
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final FlSpot spot = barData.spots[spotIndex];
                      if (spot.x == 0 || spot.x == 6) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        FlLine(color: Colors.blue, strokeWidth: 4),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            if (index % 2 == 0) {
                              return FlDotCirclePainter(
                                  radius: 8,
                                  color: Colors.white,
                                  strokeWidth: 5,
                                  strokeColor: Colors.deepOrange);
                            } else {
                              return FlDotSquarePainter(
                                size: 16,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeColor: Colors.deepOrange,
                              );
                            }
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueAccent,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          
                          // TODO タップ時に日付と体重表示
                          return LineTooltipItem(
                            '${formatter.format(start.add(new Duration(days: flSpot.x.toInt())))} \n${flSpot.y} kg',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      }),
//                  touchCallback: (LineTouchResponse lineTouch) {
//                    if (lineTouch.lineBarSpots.length == 1 &&
//                        lineTouch.touchInput is! FlLongPressEnd &&
//                        lineTouch.touchInput is! FlPanEnd) {
//                      final value = lineTouch.lineBarSpots[0].x;
//
//                      if (value == 0 || value == 6) {
//                        setState(() {
//                          touchedValue = -1;
//                        });
//                        return null;
//                      }
//
//                      setState(() {
//                        touchedValue = value;
//                      });
//                    } else {
//                      setState(() {
//                        touchedValue = -1;
//                      });
//                    }
//                  }
                  ),
            ),
          );
  }
}

class TimeSeriesWeight {
  final DateTime time;
  final double weight;

  TimeSeriesWeight(this.time, this.weight);
}
