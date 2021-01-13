import 'package:flutter/material.dart';
import 'package:scale_app/commons/sample.dart';

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
    Widget _menuItem(String title, Icon icon) {
      return GestureDetector(
        child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: icon,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0
                        ),
                      ),
                    ]
                ),
                Icon(Icons.arrow_forward_ios, size: 16.0),
              ],
            )
        ),
        onTap: () {
          Sample().showButtonPressDialog(title,context);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: ListView(
          children: [
            _menuItem("身体情報設定", Icon(Icons.person)),
            _menuItem("Push通知設定", Icon(Icons.notifications)),
            _menuItem("ロックパスワード", Icon(Icons.screen_lock_portrait)),
            _menuItem("問合せ", Icon(Icons.email)),
            _menuItem("FAQ", Icon(Icons.question_answer)),
            _menuItem("プライバシーポリシー", Icon(Icons.privacy_tip)),
            _menuItem("利用規約", Icon(Icons.policy)),
            _menuItem("削除", Icon(Icons.logout)),
            _logoutButton(),
          ]
      ),
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: _width,
        height: 50,
        child: RaisedButton(
          child: const Text(
              'ログアウト',
            style: TextStyle(
                color: Colors.white,
            ),
          ),
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