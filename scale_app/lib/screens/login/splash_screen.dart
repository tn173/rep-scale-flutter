import 'package:flutter/material.dart';
import 'package:scale_app/screens/home/home_screen.dart';

import 'setting_screen.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInitialized = false;
  bool isLogined = false; // 初回ログインをしたか
  bool showAlert = false;

  Future<bool> _checkInitialized() async {
    try{
      await new Future.delayed(new Duration(seconds: 3));
      // TODO 初期化設定

      return true;
    }catch(e){
      showAlert = true;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _splash = Scaffold(
        body: Center(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  LinearProgressIndicator(),
                  CircularProgressIndicator()
                ],
              ),
            )));

    return FutureBuilder(
      future: _checkInitialized(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        var hasData = snapshot.hasData;
        print("hasData:$hasData");
        if (hasData == false) {
          // データがない場合
          return _splash;
        } else {
          // データが存在
          // アプリの初期化状態を取得
          isInitialized = snapshot.data;
          print("isInitialized:$isInitialized");
          if (isInitialized) {
            return isLogined == true
                ? new HomeScreen()
                : new SettingScreen();
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (showAlert) {
                _showAlert(context);
              }
            });
            return _splash;
          }
        }
      },
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("エラー"),
              content: Text("接続できませんでした。"),
              actions: <Widget>[
                FlatButton(
                  child: Text("リトライ"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      showAlert = false;
                    });
                  },
                ),
              ],
            ));
  }
}
