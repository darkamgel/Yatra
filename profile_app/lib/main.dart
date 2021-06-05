// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'carview.dart';

void main() => runApp(ProfilePage());

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatedPage(),
    );
  }
}

class CalculatedPage extends StatefulWidget {
  @override
  _CalculatedPageState createState() => _CalculatedPageState();
}

class _CalculatedPageState extends State<CalculatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue[600],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    " Driver\'s Profile",
                    style: TextStyle(
                      fontSize: 28,
                      color: CupertinoColors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                  child: RichText(
                    text: TextSpan(
                      text: 'Driver Info Page  ',
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Yatra Driver',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                              fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: CupertinoColors.activeBlue.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset: Offset(5, 5)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CarView(),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
