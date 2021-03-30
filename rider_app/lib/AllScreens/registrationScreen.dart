import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/main.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idscreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image(
                  image: AssetImage("images/yatra_logo.png"),
                  width: 400.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Register as Rider",
                  style: TextStyle(fontSize: 32.0, fontFamily: "Brand-Bold"),
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
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "UserName",
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    //for entering your mail

                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    //for entering password
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    RaisedButton(
                        color: Colors.yellow,
                        textColor: Colors.blue,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "SignIn",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand-Bold",
                              ),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (nameTextEditingController.text.length < 4) {
                             displayToastMessage(
                                 "Username Must be atleast 3 characters",
                                 context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMessage("Email is not Valid ", context);
                          } else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Phone number is mandatory", context);
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
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idscreen, (route) => false);
                  },
                  child: Text("Already have an Account ? Login Here",style: TextStyle(fontSize: 16),)),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg){
              displayToastMessage("Error:"+errMsg.toString(), context);

    }))
        .user;

    if (firebaseUser != null) //user has been created
    {
      //saving user data to database


      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Welcome to Yatra. Book ride as you like", context);

      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idscreen, (route) => false);

    } else {
      //if error display messages
      displayToastMessage("UserAccount hasn't been Created", context);

    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
