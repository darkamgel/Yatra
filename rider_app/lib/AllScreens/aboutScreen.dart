import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';

class AboutScreen extends StatefulWidget {

  static const String idScreen = "about";

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage("images/background2.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: ListView(
          children: [
            Container(

              height: 220,
              child: Center(
                child: Image.asset('images/yatra_logo.png'),
              ),
            ),
            //app name + developer
            SizedBox(height: 100,),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 24, right: 24),
              child: Column(
                children: [

                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'This app is developed by CS 5th sem student,'
                    'The main motive of this app is to provide international level ride in lower price',
                    style: TextStyle(fontFamily: "cursive",fontSize: 20,color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2,)



                ],
              ),
            ),
            SizedBox(height: 40,),

            // go back button

            FlatButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, MainScreen.idscreen, (route) => false);
                },

                child:Text(
                  'Go back',style: TextStyle(fontSize: 18,color: Colors.white),

                ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),




            ),

          ],
        ),
      ),
    );
  }
}
