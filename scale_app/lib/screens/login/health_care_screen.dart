import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppState { DATA_NOT_FETCHED, FETCHING_DATA, DATA_READY, NO_DATA }

class HealthCareScreen extends StatelessWidget {
  final double _width = 350;

  @override
  Widget build(BuildContext context) {
    Widget _settingWidget() {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: _width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                    'ScaleAppではヘルスケアアプリと連携することで一日の消費カロリーを確認することができます。許可する場合は以下の設定を行ってください。'),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 72),
                child: Image.asset(
                  'assets/health_care_setting.png',
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
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
            child: const Text(
              '設定',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            shape: const StadiumBorder(),
            onPressed: () async {
              // HealthFactory health = HealthFactory();
              //
              // List<HealthDataType> types = [
              //   HealthDataType.STEPS,
              // ];
              //
              // DateTime startDate = DateTime.utc(2001, 01, 01);
              // DateTime endDate = DateTime.now();
              // bool granted = await health.requestAuthorization(types);
              // print('Health Care Data granted:$granted');
              // // TODO ホーム遷移前にローディング表示
              // if(granted){
              //   List<HealthDataPoint> healthData =
              //   await health.getHealthDataFromTypes(startDate, endDate, types);
              //   print(healthData);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isLogined", true);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false);
              // }else{
              //   print('error:Health Care Data is not allowed');
              // }
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
