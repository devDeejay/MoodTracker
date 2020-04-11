import 'package:flutter/material.dart';
import 'package:moodtracker/di/DependencyInjector.dart';
import 'package:moodtracker/ui/home/HomeScreen.dart';

void main() {
  setupDI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'moodtracker',
      theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Colors.white,
          accentColor: Colors.black,
          fontFamily: 'montserrat'),
      home: HomeScreen(),
    );
  }
}
