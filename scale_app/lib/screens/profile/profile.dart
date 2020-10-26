import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final ScrollController profileController;

  ProfileWidget({Key key, this.profileController,})
      : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello Profile Screen'),
      ),
    );
  }
}