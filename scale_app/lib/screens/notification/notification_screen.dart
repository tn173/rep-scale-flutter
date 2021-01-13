import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  final ScrollController notificationController;

  NotificationWidget({
    Key key,
    this.notificationController,
  }) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お知らせ'),
      ),
      body: ListView(children: [
        _container,
        _container,
        _container,
      ]),
    );
  }

  Widget _container = Container(
    height: 200,
    color: Colors.blue,
    margin: EdgeInsets.symmetric(vertical: 3),
    child: Center(
      child: Text(
        '広告',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  );
}
