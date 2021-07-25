import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/verifyscreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Refractor/refractor_1.dart';
import 'package:rider_app/main.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idscreen = "register";
  Timer timer;
  User user;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 690,
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
                height: 20.0,
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
                  "Register as Rider",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontFamily: "Brand-Bold",
                      letterSpacing: 3),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),

                    inputTextField(
                        Controller: nameTextEditingController,
                        Icons: Icons.person,
                        text: "UserName"),

                    //for entering your mail

                    SizedBox(
                      height: 10.0,
                    ),

                    inputTextField(
                        Controller: emailTextEditingController,
                        Icons: Icons.email,
                        text: "Email"),

                    SizedBox(
                      height: 10.0,
                    ),
                    inputTextField(
                        Controller: phoneTextEditingController,
                        Icons: Icons.contact_phone,
                        text: "Phone"),

                    //for entering password
                    SizedBox(
                      height: 10.0,
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
                      height: 10.0,
                    ),

                    RaisedButton(
                        color: Colors.grey[500].withOpacity(0.5),
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          width: 150,
                          child: Center(
                            child: Text(
                              "SignIn",
                              style: TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 3,
                                fontFamily: "Brand-Bold",
                              ),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(14.0),
                        ),
                        onPressed: () async {
                          if (nameTextEditingController.text.length < 4) {
                            displayToastMessage(
                                "Username Must be atleast 4 characters",
                                context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMessage("Email is not Valid ", context);
                          } else if ((phoneTextEditingController.text.length <
                              10)) {
                            displayToastMessage(
                                "Invalid Phone number  ", context);
                          } else if (passwordTextEditingController.text.length <
                              7) {
                            displayToastMessage(
                                "Password must be 6 characters long", context);
                          } else {
                            registerNewUser(context);
                          }
                        }),
                  ],
                ),
              ),
              flattyButton(
                onpressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idscreen, (route) => false);
                },
                text: "Already have an Account ? Login Here",
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Signining In , please wait....",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    await _firebaseAuth.currentUser.sendEmailVerification();

    if (firebaseUser != null) //user has been created
    {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);

      // await firebaseUser.sendEmailVerification();

      // if(user.emailVerified){
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idscreen, (route) => false);
      //
      displayToastMessage("Welcome to Yatra. Book ride as you like", context);
      //
      // }

      // await handleUserEmailVerification(context, user: firebaseUser);

    } else {
      Navigator.pop(context);
      //if error display messages
      displayToastMessage("UserAccount hasn't been Created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
