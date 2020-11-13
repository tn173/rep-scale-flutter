import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  BuildContext _scaffoldContext;

  final double _width = 350;
  String _gender = '';
  String _genderText = '';
  int _selectedGenderIndex;
  List<String> _genderList = ['男性', '女性']; // その他も含めるかどうか
  String _birthText = '';
  String _height = '';
  String _heightText = '';
  int _selectedHeightIndex;
  List<String> _heightList;
  int _minHeight = 50;
  int _maxHeight = 250;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialize();
  }

  // TODO データから取得
  void _initialize() {
    _selectedGenderIndex = 0;
    _gender = _genderList[_selectedGenderIndex];

    _selectedHeightIndex = 120;
    _heightList = [];
    for (int i = _minHeight; i <= _maxHeight; i++) {
      _heightList.add('${i}cm');
    }
    _height = _heightList[_selectedHeightIndex];
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
            InkWell(
              onTap: () async {
                var gender = await _showGenderModal(context);
                setState(() {
                  _genderText = gender;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('性別'),
                  ),
                  Row(
                      children: <Widget>[
                        Text(_genderText),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios, size: 16.0),
                        ),
                      ]),
                ],
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime.now(),
                  onConfirm: (date) {
                    print('confirm $date');
                    setState(() {
                      _birthText = '${date.year}年${date.month}月${date.day}日';
                    });
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.jp,
                  theme: DatePickerTheme(
                    cancelStyle: const TextStyle(
                        color: Colors.blue, fontSize: 16),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('生年月日'),
                  ),
                  Row(
                      children: <Widget>[
                        Text(_birthText),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios, size: 16.0),
                        ),
                      ]),
                ],
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                var height = await _showHeightModal(context);
                setState(() {
                  _heightText = height;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('身長'),
                  ),
                  Row(
                      children: <Widget>[
                        Text(_heightText),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios, size: 16.0),
                        ),
                      ]),
                ],
              ),
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
            var s = '';
            if(_genderText == ''){
              s = '性別';
            }else if(_birthText == ''){
              s = '生年月日';
            }else if(_heightText == ''){
              s = '身長';
            }else{
              Navigator.of(context).pushNamed('/health');
            }
            if(s != '') _showAlert(s);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('基本設定'),
        ),
        body: Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[_settingWidget(), _nextButton()]),
          );
        })
    );
  }

  void _showAlert(String s) {
    final snackBar = SnackBar(
        content: Text("$sを入力してください。"),
        backgroundColor: Colors.brown,
        action: SnackBarAction(
          label: "OK",
          onPressed: (){},
        ));

    Scaffold.of(_scaffoldContext).showSnackBar(snackBar);
  }

  // 性別選択Modal
  Future<String> _showGenderModal(BuildContext context) async {
    var cancel = 'キャンセル';
    var text = '性別を選択してください';
    var next = '完了';
    var gender = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff999999),
                                width: 0.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                child: Text(
                                  cancel,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                              ),
                              Text(
                                text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              CupertinoButton(
                                child: Text(
                                  next,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  var text = '$_gender';
                                  Navigator.pop(context, text);
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: _bottomPicker(CupertinoPicker(
                              itemExtent: 30,
                              children: _genderListWidget(),
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  _gender = _genderList[index];
                                  _selectedGenderIndex = index;
                                });
                              },
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectedGenderIndex),
                            )),
                          ),
                        ]),
                      ]);
                }),
          );
        });

    return gender ?? '';
  }

  List<Widget> _genderListWidget() {
    List<Widget> list = [];
    _genderList.forEach((gender) {
      list.add(Text('$gender'));
    });
    return list;
  }

  // 身長選択Modal
  Future<String> _showHeightModal(BuildContext context) async {
    var cancel = 'キャンセル';
    var text = '身長を選択してください';
    var next = '完了';
    var height = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff999999),
                                width: 0.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CupertinoButton(
                                child: Text(
                                  cancel,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                              ),
                              Text(
                                text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              CupertinoButton(
                                child: Text(
                                  next,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  var text = '$_height';
                                  Navigator.pop(context, text);
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 5.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: _bottomPicker(CupertinoPicker(
                              itemExtent: 30,
                              children: _heightListWidget(),
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  _height = _heightList[index];
                                  _selectedHeightIndex = index;
                                });
                              },
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectedHeightIndex),
                            )),
                          ),
                        ]),
                      ]);
                }),
          );
        });

    return height ?? '';
  }

  List<Widget> _heightListWidget() {
    List<Widget> list = [];
    _heightList.forEach((height) {
      list.add(Text('$height'));
    });
    return list;
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

}
