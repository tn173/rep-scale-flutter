import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {

  SettingScreen({Key key,})
      : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final double _width = 350;
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  List<String> _titleList = [
    '性別', '生年月日', '身長'
  ];

  List<String> _contentList = [
    '', '', ''
  ];

  // 期間指定
  int _startYear = 1900;
  int _endYear;
  int _nowMonth;
  List<int> _yearList = [];
  List<int> _monthList = [];
  List<Widget> yearListWidget() {
    List<Widget> list = [];
    _yearList.forEach((year) {
      list.add(Text('$year年'));
    });
    return list;
  }
  List<Widget> monthListWidget() {
    List<Widget> list = [];
    _monthList.forEach((month) {
      list.add(Text('$month月'));
    });
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  // TODO データから取得
  void _initialize() {
    _endYear = DateTime.now().year;
    _nowMonth = DateTime.now().month;

    for (int i = _startYear; i <= _endYear; i++) {
      _yearList.add(i);
    }
    for (int i = 1; i <= 12; i++) {
      _monthList.add(i);
    }
  }

  List<String> _optionList(int mode){

  }

  List<Widget> _optionWidgetList(int mode){

  }

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
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              child: GestureDetector(
                onTap:() async {
//                  var gender = await _showModal(context,0);
//                  setState(() {
//                    _genderController.text = gender;
//                  });
                },
                child: TextField(
                  readOnly: true,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '性別',
                    labelText: '性別',
                  ),
                  controller: _genderController,
                ),
              ),
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

  Widget _bottomPicker(Widget picker) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: Color(0xffffffff),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  // 選択Modal mode 0:性別、1:生年月日、2:身長
//  Future<String> _showModal(BuildContext context, int mode) async {
//    var cancel = 'キャンセル';
//    var text = '${_titleList[mode]}を選択してください';
//    var next = '完了';
//    var language = await showCupertinoModalPopup(
//        context: context,
//        builder: (BuildContext context) {
//          return Container(
//            child: StatefulBuilder(
//                builder: (BuildContext context, StateSetter stateSetter) {
//                  return Column(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Container(
//                          decoration: BoxDecoration(
//                            color: Color(0xffffffff),
//                            border: Border(
//                              bottom: BorderSide(
//                                color: Color(0xff999999),
//                                width: 0.0,
//                              ),
//                            ),
//                          ),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              CupertinoButton(
//                                child: Text(
//                                  cancel,
//                                  style: TextStyle(
//                                    fontSize: 15,
//                                  ),
//                                ),
//                                onPressed: () {
//                                  Navigator.pop(context);
//                                },
//                                padding: const EdgeInsets.symmetric(
//                                  horizontal: 16.0,
//                                  vertical: 5.0,
//                                ),
//                              ),
//                              Text(
//                                text,
//                                style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 15,
//                                  color: Colors.black,
//                                  decoration: TextDecoration.none,
//                                ),
//                              ),
//                              CupertinoButton(
//                                child: Text(
//                                  next,
//                                  style: TextStyle(
//                                    fontSize: 15,
//                                  ),
//                                ),
//                                onPressed: () {
//                                  var text = '${_contentList[mode]}';
//                                  Navigator.pop(context, text);
//                                },
//                                padding: const EdgeInsets.symmetric(
//                                  horizontal: 16.0,
//                                  vertical: 5.0,
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                        Row(children: <Widget>[
//                          Expanded(
//                            child: _bottomPicker(CupertinoPicker(
//                              itemExtent: 30,
//                              children: _optionWidgetList(mode),
//                              onSelectedItemChanged: (int index) {
//                                setState(() {
//                                  _contentList[mode] = _optionList(mode)[index];
//                                  _selectedIndexList[mode] = index;
//                                });
//                              },
//                              scrollController: FixedExtentScrollController(
//                                  initialItem: _selectedIndexList[mode]),
//                            )),
//                          ),
//                        ]),
//                      ]);
//                }),
//          );
//        });
//
//    return language;
//  }

  @override
  Widget build(BuildContext context) {

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
