// @dart=2.9
import 'dart:async';
import 'package:splashscreen/splashscreen.dart';

import 'package:flutter/material.dart';

void main()=> runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int _value = 6;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen2(),
    );
  }
}

class SplashScreen1 extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initstate(){
    super.initState();
    Timer(
      Duration(seconds: 4),()=>
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage())),//NAVIGATE LOGINPAGE
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('images/logo.png'),
    );
  }
}
//NAVIGATE LOGINPAGE INSTEAD OF HOME PAGE
class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Just Example Navigation Navigate to Login')),
    );
  }
}

class SplashScreen2 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(), //NAVIGATE LOGINPAGE
      title: Text('Yatra A Ride-Sharing Platform',
      style: TextStyle(
      fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
       
      ),
      ),
      image: Image.asset('images/logo.png'),
      photoSize: 100,
      loadingText: Text('Loading'),
      loaderColor: Colors.blueAccent,
    );
  }
}

