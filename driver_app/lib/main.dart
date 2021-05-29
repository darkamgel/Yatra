import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/AllScreens/registrationScreen.dart';

import 'AllScreens/carInfoScreen.dart';
import 'AllScreens/forgot_pw_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef =
      FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.reference().child("drivers")
          .child(currentfirebaseUser.uid).child("newRide");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Yatra Driver App',
        theme: ThemeData(

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // initialRoute: MainScreen.idscreen,
        //  initialRoute: MainScreen.idscreen,
        initialRoute: FirebaseAuth.instance.currentUser==null ? LoginScreen.idscreen : MainScreen.idscreen,
        routes: {
          RegisterationScreen.idscreen: (context) => RegisterationScreen(),
          LoginScreen.idscreen: (context) => LoginScreen(),
          MainScreen.idscreen: (context) => MainScreen(),
          ForgotPassword.idscreen:(context)=>ForgotPassword(),
          CarInfoScreen.idscreen:(context)=>CarInfoScreen(),

        },
        // debugShowCheckedModeBanner: false,
      ),
    );
  }
}
