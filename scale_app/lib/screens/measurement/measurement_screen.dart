import 'package:flutter/material.dart';

class MeasurementWidget extends StatefulWidget {
  final ScrollController measurementController;

  MeasurementWidget({Key key, this.measurementController,})
      : super(key: key);

  @override
  _MeasurementWidgetState createState() => _MeasurementWidgetState();
}

class _MeasurementWidgetState extends State<MeasurementWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text('Hello Measurement Screen'),
        ),
      );
  }
}
