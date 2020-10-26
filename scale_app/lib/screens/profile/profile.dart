import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final ScrollController profileController;

  ProfileWidget({Key key, this.profileController,})
      : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final double _width = 350;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logoutButton(),
            ]),
      )
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: _width,
        height: 50,
        child: RaisedButton(
          child: const Text('ログアウト'),
          color: Colors.blue,
          shape: const StadiumBorder(),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/setting', (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }
}