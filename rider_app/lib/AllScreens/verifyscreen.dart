import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dailoghumma extends StatelessWidget {
  static const String idscreen = "Dailog";
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          // color:Color(0xFFB6D7BE),
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
                spreadRadius: 0.5,
                blurRadius: 16.0,
                color: Colors.black54,
                offset: Offset(0.7, 0.7)),
          ],
        ),
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Driver on the way",textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0,fontFamily: "rand-Bold"),),
                ],
              ),
              SizedBox(height: 22.0,),

              Divider(height: 2.0,thickness: 2.0,),

              Text("MadRed-Ferari grotto",style: TextStyle(color: Colors.grey),),

              Text("Sandeep Kshetri",style: TextStyle(fontSize: 20.0),),

              SizedBox(height: 22.0,),

              Divider(),

              SizedBox(height: 22.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                          border: Border.all(width: 2.0,color: Colors.grey),
                        ),
                        child:Icon(
                          Icons.call,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Call"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                          border: Border.all(width: 2.0,color: Colors.grey),
                        ),
                        child:Icon(
                          Icons.list,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Call"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                          border: Border.all(width: 2.0,color: Colors.grey),
                        ),
                        child:Icon(
                          Icons.call,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Call"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(26.0)),
                          border: Border.all(width: 2.0,color: Colors.grey),
                        ),
                        child:Icon(
                          Icons.close,
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Cancel"),
                    ],
                  )
                ],

              ),


            ],
          ),
        ),
      ),
    );
  }
}
