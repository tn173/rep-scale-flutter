import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sample {
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void showButtonPressDialog(String provider, BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("タイトル"),
          content: Text('$provider'),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget container = Container(
    height: 200,
    color: Colors.blue,
    margin: EdgeInsets.symmetric(vertical: 3),
  );

  Widget titleWidget(String title, double fontSize){
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 3.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
      ),
    ]);
  }

}