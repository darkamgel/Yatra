import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/AllScreens/searchScreen.dart';
import 'package:driver_app/AllWidgets/Divider.dart';
import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Models/directionDetails.dart';
import 'package:driver_app/configMaps.dart';

class MainScreen extends StatefulWidget {
  static const String idscreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController;

  static const colorizeColors = [Colors.green,Colors.purple,Colors.pink,Colors.blue,Colors.yellow,Colors.red];
  static const colorizeTextStyle = TextStyle(fontSize: 55.0,fontFamily: "Signatra");





  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DirectionDetails tripDirectionDetails;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight =0;
  double requestrideConatinerHeight =0;
  double searchContainerHeight= 300.0;

  bool drawerOpen = true;

  DatabaseReference rideRequestRef;

  @override
  void initState(){

    super.initState();
    AssistantMethods.getCureentOnlineUserInfo();
  }

  void saveRideRequest(){
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();

        var pickUp = Provider.of<AppData>(context,listen: false).pickUpLocation;
        var dropOff= Provider.of<AppData>(context,listen: false).dropOffLocation;

        Map pickUpLocMap = {
          "latitude":pickUp.latitude.toString(),
          "longitude":pickUp.longitude.toString(),

        };

    Map dropOffLocMap = {
      "latitude":dropOff.latitude.toString(),
      "longitude":dropOff.longitude.toString(),
    };

    Map riderinfoMap={
      "driver_id":"waiting",
      "payment_method":"cash",
      "pickup":pickUpLocMap,
      "dropoff":dropOffLocMap,
      "created_at":DateTime.now().toString(),
      "rider_name":userCurrentInfo.name,
      "rider_phone":userCurrentInfo.phone,
      "pickup_address":pickUp.placeName,
      "dropoff_address":dropOff.placeName,
    };


    rideRequestRef.set(riderinfoMap);


  }





  resetApp(){
    setState(() {
      drawerOpen =true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestrideConatinerHeight = 0;
      bottomPaddingofMap = 230.0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
    });
    locatePosition();
  }

  //canceling the ride

  void cancelRideRequest(){
    rideRequestRef.remove();

  }



  void displayRequestRideContainer(){
    setState(() {
      requestrideConatinerHeight=250.0;
      rideDetailsContainerHeight=0;
      bottomPaddingofMap=230.0;
      drawerOpen = true;

    });

    saveRideRequest();
  }






  void displayRideDetailsContainer()async{
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240;
      bottomPaddingofMap = 230.0;
      drawerOpen =false;

    });
  }





  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlatPosition, zoom: 14);

    newgoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This  is your address::" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Main Screen"),
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
      ),
      drawer: Container(
        color: Colors.grey,
        width: 255.0,
        child: Drawer(
          child: Container(
            color: Colors.blueGrey[600],
            child: ListView(
              children: [
                //header of drawer
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[600],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/user_icon.png",
                          height: 65.0,
                          width: 65.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Profile Name",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Brand-Bold",
                                  color: Colors.white,
                                  letterSpacing: 2),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              "Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 5.0,
                ),
                //Drawer body button

                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: Text(
                    "History",
                    style: TextStyle(
                        fontSize: 17.0, color: Colors.white, letterSpacing: 2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 17.0, color: Colors.white, letterSpacing: 2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(
                        fontSize: 17.0, color: Colors.white, letterSpacing: 2),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idscreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 17.0, color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingofMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newgoogleMapController = controller;

                setState(() {
                  bottomPaddingofMap = 300.0;
                });

                locatePosition();
              }),

          //hambergerButton drawer

          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if(drawerOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else{
                  resetApp();
                }

              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 8.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7)),
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerOpen) ? Icons.menu :Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),







        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "please wait...",
            ));

    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });


    Navigator.pop(context);
    print("This is Encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newgoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "my Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.purple,
        circleId: CircleId("dropOffId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}
