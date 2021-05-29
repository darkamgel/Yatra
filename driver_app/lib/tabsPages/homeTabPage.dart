import 'dart:async';

import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeTabPage extends StatelessWidget {


  Position currentPosition;
  var geoLocator = Geolocator();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

/*******************************give current user locatio *****************/
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latlatPosition, zoom: 14);

    newgoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print("This  is your address::" + address);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(

            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller;

              locatePosition();



            }),
        //*******************************Go online / offline button*******************************/
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(200.0),bottomRight:Radius.circular(200.0) ),
                color: Colors.black54,
              ),
              height: 100.0,
              width: 0,


            ),

        Positioned(
          top: 15.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(17.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

                    onPressed:() {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                    },
                    color: Colors.blueGrey[400],
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Offline - Online",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,letterSpacing: 2),),
                        Icon(Icons.phone_android, color:Colors.white,size: 26.0,),
                      ],
                    ),
                  ),

              ),
            ],
          ),
        ),
      ],
    );

  }
/******************************live location update and saving to Database at Real Time **********/
  /*******************Geofiree package used****************************/
  void makeDriverOnlineNow() async{

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
  
  Geofire.initialize("availableDrivers");
  Geofire.setLocation(
      currentfirebaseUser.uid,
      currentPosition.latitude,
      currentPosition.longitude
  );

  rideRequestRef.onValue.listen((event) {

  });


  }

  void getLocationLiveUpdates(){

    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          currentPosition = position;
          Geofire.setLocation(
              currentfirebaseUser.uid,
              position.latitude,
              position.longitude);
          LatLng latLng = LatLng(position.latitude,position.longitude);
          newgoogleMapController.animateCamera(
              CameraUpdate.newLatLng(latLng));

        });
  }
}
