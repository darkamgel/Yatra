import 'dart:async';

import 'package:driver_app/AllScreens/registrationScreen.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:driver_app/Notifications/pushNotificationService.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  var geoLocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online";
  Color driverStatusColor = Colors.blueGrey[400];
  bool isDriverAvailable = false;

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newgoogleMapController;

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

  /*************************************push notification service*****************/

  void getCurrentDriverInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapshot){

      if(dataSnapshot.value != null)
        {
          driversInformation = Drivers.fromSnapshot(dataSnapshot);

        }


    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: HomeTabPage._kGooglePlex,
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
          top: -10.0,
          left: 0.0,
          right: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(17.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),

                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.blueGrey;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });

                      displayToastMessage("You are online Now", context);
                    } else {
                      setState(() {
                        driverStatusColor = Colors.blueGrey;
                        driverStatusText = "Offline Now - Go Online";
                        isDriverAvailable = false;
                      });
                      makeDriverOfflineNow();
                      displayToastMessage("Going Offline now", context);
                    }
                  },
                  // color: Colors.blueGrey[400],
                  color: driverStatusColor,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        driverStatusText,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 26.0,
                      ),
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

  /*******************Geofiree package used****************************/
  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
    
    rideRequestRef.set("searching");

    rideRequestRef.onValue.listen((event) {});
  }

  getRatings(){
    //retrieve ratings
    driversRef.child(currentfirebaseUser.uid).child("ratings").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        double ratings = double.parse(dataSnapshot.value.toString());
        setState(() {
          starCounter = ratings;
        });

        if(starCounter <= 1.5)
        {

          setState(() {
            title = "Very Bad";
          });
          return;

        }
        if(starCounter <= 2.5)
        {

          setState(() {
            title = "Bad";
          });
          return;

        }
        if(starCounter <= 3.5)
        {

          setState(() {
            title = "Good";
          });
          return;

        }
        if(starCounter <= 4.5)
        {

          setState(() {
            title = "Very Good";
          });
          return;

        }
        if(starCounter <= 5.0)
        {

          setState(() {
            title = "Excellent";
          });
          return;

        }

      }
    });


  }


  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newgoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  /****************************Go offline function***********************************/ //
  void makeDriverOfflineNow() async {
    await Geofire.removeLocation(currentfirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
  }

// void makeDriverOfflineNow() {
//    Geofire.removeLocation(currentfirebaseUser.uid);
//   rideRequestRef.onDisconnect();
//   rideRequestRef.remove();
//   rideRequestRef = null;
// }
}
