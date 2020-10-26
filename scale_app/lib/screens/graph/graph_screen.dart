import 'package:flutter/material.dart';

class GraphWidget extends StatefulWidget {
  final ScrollController graphController;

  GraphWidget({Key key, this.graphController,})
      : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グラフ'),
      ),
      body: Center(
        child: Text('Hello Graph Screen'),
      ),
    );
  }
}
