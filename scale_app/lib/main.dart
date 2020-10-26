import 'package:flutter/material.dart';
import 'package:scale_app/screens/login/health_care_screen.dart';
import 'package:scale_app/screens/home/home_screen.dart';
import 'package:scale_app/screens/login/setting_screen.dart';
import 'package:scale_app/screens/login/splash_screen.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scale app',
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (_) => new SplashScreen(),
        '/setting': (_) => new SettingScreen(),
        '/health': (_) => new HealthCareScreen(),
        '/screens.home': (_) => new HomeScreen(),
      },
    );
  }
}
