import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driver_app/AllScreens/registrationScreen.dart';

import 'loginScreen.dart';

class ForgotPassword extends StatelessWidget {
  static const String idscreen = "forgotpassword";
  String email;
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
            shaderCallback: (rect)=>LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black,Colors.transparent],
            ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              )
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.idscreen, (route) => false);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text('Password Reset',
            style: TextStyle(fontSize: 22,color: Colors.white,letterSpacing: 2),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                children: [
                  Container(
                    width:400,
                    child: Text('Please Enter your Register Email to Reset your Password',
                    style: TextStyle(
                      fontSize:20,
                      color: Colors.white,
                    ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: TextField(
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
                          TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color:Colors.teal.shade800,
                    ),
                    child: RaisedButton(
                        color: Colors.grey[500].withOpacity(0.5),
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          width: 70,
                          child: Center(
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                letterSpacing: 4,
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
                          }
                          else {
                            resetPassword(email);
                            displayToastMessage("Description to reset your password hasbeen send to your desired Email", context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, LoginScreen.idscreen, (route) => false);
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        )
      ],

    );
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email:emailTextEditingController.text);
  }
}