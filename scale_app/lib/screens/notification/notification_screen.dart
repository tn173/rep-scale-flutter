import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  final ScrollController notificationController;

  NotificationWidget({Key key, this.notificationController,})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello Notification Screen'),
      ),
    );
  }
}