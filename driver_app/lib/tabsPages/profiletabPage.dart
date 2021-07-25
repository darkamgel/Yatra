import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA2C5AC),
      body: SafeArea(
        child: Column(



          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Text(
              driversInformation.name.toUpperCase(),
              style: TextStyle(
                fontSize: 65.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: 'Signatra',
              ),
            ),
            Text(
             title +  " Driver",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Brand-Regular'
              ),
            ),

            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),

            SizedBox(height: 40.0,),

            InfoCard(
              text: driversInformation.phone,
              icon: Icons.phone,
              onPressed: () async {
                print("this is phone");
            },
            ),
            InfoCard(
              text: driversInformation.email,
              icon: Icons.email,
              onPressed: ()async{
                print("this is Email");

              },
            ),
            InfoCard(
              text: driversInformation.car_color + " | " + driversInformation.car_model + " | " + driversInformation.car_number,
              icon: Icons.car_repair,
              onPressed: ()async{
                print("this is Car");
              },
            ),

            SizedBox(height: 20,),





            RaisedButton(
                 color: Colors.grey[500].withOpacity(0.5),
                textColor: Colors.white,
                child: Container(
                  height: 50.0,
                  width: 150,
                  child: Center(
                    child: Text(
                      "Sign Out",
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
                  Geofire.removeLocation(currentfirebaseUser.uid);
                  rideRequestRef.onDisconnect();
                  rideRequestRef.remove();
                  rideRequestRef = null;

                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idscreen, (route) => false);
                }),












            

          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {

  final String text;
  final IconData icon;
  Function onPressed;


  InfoCard({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
         color: Colors.grey[500].withOpacity(0.5),
        margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: 'Brand-Bold'
            ),
          ),
        ),
      ),
    );
  }
}

