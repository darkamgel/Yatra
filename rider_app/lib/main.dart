import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatra User App',
      theme: ThemeData(
         fontFamily: 'Brand-Bold',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterationScreen(),
      // debugShowCheckedModeBanner: false,
    );
  }
}

