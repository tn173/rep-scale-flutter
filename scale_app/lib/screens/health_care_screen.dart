import 'package:flutter/material.dart';

class HealthCareScreen extends StatelessWidget {
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
                padding: const EdgeInsets.all(24.0),
                child: Text('ScaleAppではヘルスケアアプリと連携することで一日の消費カロリーを確認することができます。許可する場合は以下のように設定を行ってください。'),
              ),
              Divider(),

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
            child: const Text('次へ'),
            color: Colors.blue,
            shape: const StadiumBorder(),
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('ヘルスケアアプリ連携'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[_settingWidget(), _nextButton()]),
        ));
  }
}
