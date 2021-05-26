import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/AllScreens/registrationScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CarInfoScreen extends StatelessWidget {

  static const String idscreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 760,
          margin: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  AssetImage('images/background.png'),
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),//lighten is good
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset('images/yatra_logo.png',
                width: 400.0,
                height: 250.0,),
              Padding(padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Text("Enter Car Details",style: TextStyle(
                        fontFamily: "Brand-Bold",
                        fontSize: 30.0,
                        color: Colors.white,
                    ),),
                    SizedBox(height: 26.0,),

                    TextField(
                      controller: carModelTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.car_rental,color: Colors.white,size: 30,),
                        fillColor: Colors.grey[500].withOpacity(0.5),
                        filled: true,
                        //paxi add gareko
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        ///yeta samma
                        labelText: "Car Model",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 20.0,color: Colors.white),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: carNumberTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.confirmation_number,color: Colors.white,size: 30,),
                        fillColor: Colors.grey[500].withOpacity(0.5),
                        filled: true,
                        //paxi add gareko
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        ///yeta samma
                        labelText: "Car Number",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 20.0,color: Colors.white),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: carColorTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.border_color,color: Colors.white,size: 30,),
                        fillColor: Colors.grey[500].withOpacity(0.5),
                        filled: true,
                        //paxi add gareko
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide( width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        ///yeta samma
                        labelText: "Car Color",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 20.0,color: Colors.white),
                    ),

                    SizedBox(height: 20.0,),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                          color: Colors.grey[500].withOpacity(0.5),
                          textColor: Colors.white,
                          child: Container(
                            height: 50.0,
                            width: 150,
                            child: Center(
                              child: Text(
                                "Next",
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
                          onPressed: () {
                            if(carModelTextEditingController.text.isEmpty){
                              displayToastMessage("Please Enter Valid Car Model", context);
                            }
                            else if(carNumberTextEditingController.text.isEmpty){
                              displayToastMessage("Please Enter Valid Car Number", context);
                            }else if(carColorTextEditingController.text.isEmpty){
                              displayToastMessage("Please Enter Valid Car Color", context);
                            }else{
                              saveDriverCarInfo(context);
                            }


                          }
                          ),
                    ),












                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context) async {
    String userId = currentfirebaseUser.uid;

    // await FirebaseAuth.instance.currentUser.sendEmailVerification();

    Map carInfoMap = {
      "car_color":carColorTextEditingController.text,
      "car_number":carNumberTextEditingController.text,
      "car_model":carModelTextEditingController.text,
    };

    
    driversRef.child(userId).child("car_details").set(carInfoMap);

    displayToastMessage("Your Details hasbeen added , please login through Login Screen", context);
    
    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idscreen, (route) => false);

  }
}
