import 'dart:async';

import 'package:driver_app/Models/ridedDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;

  NewRideScreen({this.rideDetails});


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newRideGoogleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: NewRideScreen._kGooglePlex,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newRideGoogleMapController = controller;
                }),

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),
                      topRight:Radius.circular(16.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    )
                  ],
                ),
                height: 270.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                  child: Column(
                    children: [
                      Text(
                        "10 mins",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand-Bold",
                        color: Colors.deepPurple
                        ),
                      ),
                      Divider(color: Colors.grey,),

                      SizedBox(height: 6.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sandeep kshetri",style: TextStyle(
                            fontFamily: "Brand-Bold",
                            fontSize: 24.0
                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.call),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Row(
                        children: [
                          Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                          SizedBox(width: 18.0,),
                          Expanded(
                            child: Container(
                              child: Text(
                                "street 66 paris,france",
                                style: TextStyle(fontSize: 18.0),
                                overflow:TextOverflow.ellipsis ,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Row(
                        children: [
                          Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
                          SizedBox(width: 18.0,),
                          Expanded(
                            child: Container(
                              child: Text(
                                "street 77 paris,france",
                                style: TextStyle(fontSize: 18.0),
                                overflow:TextOverflow.ellipsis ,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:26.0,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: (){},
                          // color: Theme.of(context).accentColor,
                          color:Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Arrived",style: TextStyle(
                                    fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                ),
                                Icon(Icons.directions_car,color: Colors.white,size: 26.0,),

                              ],
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),




          ],
        ),
      ),
       );
  }
}
