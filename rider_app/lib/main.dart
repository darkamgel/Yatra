import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registrationScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}





DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

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
      initialRoute: LoginScreen.idscreen,
      routes: {
        RegisterationScreen.idscreen: (context) => RegisterationScreen(),
        LoginScreen.idscreen: (context) => LoginScreen(),
        MainScreen.idscreen: (context) => MainScreen(),
      },
      // debugShowCheckedModeBanner: false,
    );
  }
}
