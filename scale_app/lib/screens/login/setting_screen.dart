import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  final double _width = 350;
  @override
  Widget build(BuildContext context) {
    Widget _settingWidget() {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          height: 400,
          width: _width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text('基本情報を設定してください'),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('性別'),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('生年月日'),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('身長'),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('※これらのデータは、適正な体重を計算するために用いられます。'),
              ),
            ],
          ),
        ),
      );
    }

    Widget _nextButton() {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: _width,
          height: 50,
          child: RaisedButton(
            child: const Text('設定'),
            color: Colors.blue,
            shape: const StadiumBorder(),
            onPressed: () {
              Navigator.of(context).pushNamed('/health');
            },
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('基本設定'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[_settingWidget(), _nextButton()]),
        ));
  }
}
