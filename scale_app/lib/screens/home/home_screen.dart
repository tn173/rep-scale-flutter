import 'package:flutter/material.dart';
import 'package:scale_app/screens/graph/graph_screen.dart';
import 'package:scale_app/screens/measurement/measurement_screen.dart';
import 'package:scale_app/screens/notification/notification_screen.dart';
import 'package:scale_app/screens/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _measurementController = ScrollController();
  final ScrollController _graphController = ScrollController();
  final ScrollController _profileController = ScrollController();
  final ScrollController _notificationController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MeasurementWidget(measurementController: _measurementController),
          GraphWidget.withSampleData(),
          ProfileWidget(profileController: _profileController),
          NotificationWidget(notificationController: _notificationController,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Image.asset("assets/scale.png", color: Colors.grey,),
              activeIcon: Image.asset("assets/scale.png", color: Colors.blue,),
              label: '測定',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/graph.png", color: Colors.grey,),
            activeIcon: Image.asset("assets/graph.png", color: Colors.blue,),
            label: 'グラフ',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/profile.png", color: Colors.grey,),
            activeIcon: Image.asset("assets/profile.png", color: Colors.blue,),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/notify.png", color: Colors.grey,),
            activeIcon: Image.asset("assets/notify.png", color: Colors.blue,),
            label: 'お知らせ',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blueAccent,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          var _scrollController;
          switch (index) {
            case 0:
              _scrollController = _measurementController;
              break;
            case 1:
              _scrollController = _graphController;
              break;
            case 2:
              _scrollController = _profileController;
              break;
            case 3:
              _scrollController = _notificationController;
              break;
          }
          // IconTap時に一番上に戻す
//          if (index == _selectedIndex) {
//            _scrollController.animateTo(
//              0.0,
//              curve: Curves.easeOut,
//              duration: const Duration(milliseconds: 300),
//            );
//          }
          setState(
                () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}