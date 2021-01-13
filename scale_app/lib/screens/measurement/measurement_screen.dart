import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasurementWidget extends StatefulWidget {
  final ScrollController measurementController;

  MeasurementWidget({
    Key key,
    this.measurementController,
  }) : super(key: key);

  @override
  _MeasurementWidgetState createState() => _MeasurementWidgetState();
}

class _MeasurementWidgetState extends State<MeasurementWidget> {
  final double _width = 350;
  static const platform = const MethodChannel('sample/ble');
  String _status = 'fail';
  String _weight;
  String _BMI;
  String _BodyfatPercentage;
  String _MuscleKg;
  String _WaterPercentage;
  String _VFAL;
  String _BoneKg;
  String _BMR;
  String _ProteinPercentage;
  String _VFPercentage;
  String _LoseFatWeightKg;
  String _Bodystandard;

  _toPlatformScreen() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await platform.invokeMethod(
        'toPlatformScreen',
        <String, dynamic>{
          "gender": prefs.getString('gender') ?? '',
          "age": prefs.getInt('age').toString() ?? '',
          "height": prefs.getInt('height').toString() ?? '',
        },
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case "onClosed":
          var map = call.arguments.cast<String, String>();
          print("onClosed!!");
          print(map);
          if (map["status"] == "success") {
            setState(() {
              _status = map["status"];
              _weight = map["weight"];
              _BMI = map["BMI"];
              _BodyfatPercentage = map["BodyfatPercentage"];
              _MuscleKg = map["MuscleKg"];
              _VFAL = map["VFAL"];
              _BoneKg = map["BoneKg"];
              _WaterPercentage = map["WaterPercentage"];
              _BMR = map["BMR"];
              _ProteinPercentage = map["ProteinPercentage"];
              _VFPercentage = map["VFPercentage"];
              _LoseFatWeightKg = map["LoseFatWeightKg"];
              _Bodystandard = map["Bodystandard"];
            });
          } else {
            setState(() {
              _status = map["status"];
              _weight = null;
              _BMI = null;
              _BodyfatPercentage = null;
              _MuscleKg = null;
              _VFAL = null;
              _BoneKg = null;
              _WaterPercentage = null;
              _BMR = null;
              _ProteinPercentage = null;
              _VFPercentage = null;
              _LoseFatWeightKg = null;
              _Bodystandard = null;
            });
          }
          break;
      }
      return;
    });
  }

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
            children: _status == 'fail'
                ? <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text('体重を測定してください'),
                    )
                  ]
                : <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('ステータス：$_status'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('体重： $_weight'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('BMI： $_BMI'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('体脂肪率： $_BodyfatPercentage'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('筋肉量： $_MuscleKg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('体水分率： $_WaterPercentage'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('内臓脂肪： $_VFAL'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('骨量： $_BoneKg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('基礎代謝： $_BMR'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('タンパク質： $_ProteinPercentage'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('皮下脂肪率： $_VFPercentage'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('除脂肪体重： $_LoseFatWeightKg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('標準体重： $_Bodystandard'),
                    ),
                  ]),
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
                  onPressed: () async {
                    // TODO 体組成計連携
                    // await _bindingDevice();
                    Navigator.of(context).pop();
                    _toPlatformScreen();
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

// Future<void> _bindingDevice() async {
//
//     String weight;
//     try {
//       print('_bindingDevice start!');
//       final String result = await platform.invokeMethod('binding');
//       weight = '$result';
//       print(result);
//     } on PlatformException catch (e) {
//       print('_bindingDevice failed!');
//       weight = "Failed to get weight: '${e.message}'";
//     }
//
//     setState(() {
//       _weight = weight;
//     });
//   }
}
