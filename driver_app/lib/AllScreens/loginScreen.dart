import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/AllScreens/forgot_pw_screen.dart';
import 'package:driver_app/AllScreens/registrationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idscreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 810,
          margin: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/background.png'),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage("images/yatra_logo.png"),
                    width: 400.0,
                    height: 250.0,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Driver Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontFamily: "Brand-Bold",
                      letterSpacing: 8),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //for entering your mail
                    SizedBox(
                      height: 1.0,
                    ),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[500].withOpacity(0.5),
                        filled: true,

                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        //paxi add gareko
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),

                        ///yeta samma

                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 20.0),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    //for entering password
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[500].withOpacity(0.5),
                        filled: true,

                        //paxi add gareko
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),

                        ///yeta samma

                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              ForgotPassword.idscreen, (route) => false);
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(fontSize: 17, color: Colors.white,letterSpacing: 3),
                        )),

                    SizedBox(
                      height: 20.0,
                    ),

                    RaisedButton(
                        color: Colors.grey[500].withOpacity(0.5),
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          width: 150,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                letterSpacing: 3,
                                fontSize: 18.0,
                                fontFamily: "Brand-Bold",

                              ),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(14.0),
                        ),
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage("Email is not Valid ", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Password must be Provided", context);
                          } else {
                            loginAndAuthenticateUser(context);
                          }
                        }),
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        RegisterationScreen.idscreen, (route) => false);
                  },
                  child: Text(
                    "Do not have an Account ? Register Here",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating , please wait....",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;




    if (firebaseUser != null && firebaseUser.emailVerified) //user has been created
    {
      //saving user data to database
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idscreen, (route) => false);
          displayToastMessage("You have been logged in", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Invalid Email or password", context);
        }
      });
    } else {
      Navigator.pop(context);
      //if error display messages
      displayToastMessage("Something went wrong, can't Login", context);
    }
  }
}
