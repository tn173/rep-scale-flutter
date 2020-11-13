import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeasurementWidget extends StatefulWidget {
  final ScrollController measurementController;

  MeasurementWidget({Key key, this.measurementController,})
      : super(key: key);

  @override
  _MeasurementWidgetState createState() => _MeasurementWidgetState();
}

class _MeasurementWidgetState extends State<MeasurementWidget> {
  final double _width = 350;

  Widget _measurementWidget() {
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
              child: Text('体重を測定してください'),
            ),
//            Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('測定'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              tooltip: '測定',
              onPressed: () {
                _measure(context);
              },
            ),
          ],
        ),
        body: _measurementWidget(),
      );
  }

  _measure(BuildContext context) {
    print('測定する');

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: const Text('体重を測定する方法を選択してください。'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('体組成計連携'),
                  onPressed: () {
                    // TODO 体組成計連携
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('手動入力'),
                  onPressed: () {
                    // TODO 手動入力
                    Navigator.of(context).pop();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('キャンセル'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ));
        });
  }
}
