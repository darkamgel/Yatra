import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/%20DataHandler/appData.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/ratingScreen.dart';
import 'package:rider_app/AllScreens/searchScreen.dart';
import 'package:rider_app/AllWidgets/CollectFareDialog.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/AllWidgets/noAvailableDialog.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Assistants/assistantMethods.dart';
import 'package:rider_app/Assistants/geofireAssistant.dart';
import 'package:rider_app/Models/directionDetails.dart';
import 'package:rider_app/Models/nearbyAvailableDrivers.dart';
import 'package:rider_app/configMaps.dart';
import 'package:rider_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const String idscreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  //***************************************USING GOOGLE MAPS API********************************************/

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController;

  static const colorizeColors = [
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.blue,
    Colors.yellow,
    Colors.red
  ];
  static const colorizeTextStyle =
      TextStyle(fontSize: 55.0, fontFamily: "Signatra");

  DataSnapshot dataSnapshot;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DirectionDetails tripDirectionDetails;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double requestrideConatinerHeight = 0;
  double searchContainerHeight = 300.0;
  double driverDetailsContainerHeight=0;

  bool drawerOpen = true;
  DatabaseReference rideRequestRef;
  bool nearbyAvailableDriverKeysLoaded = false;

  BitmapDescriptor nearByIcon;

  List<NearbyAvailableDrivers> availableDrivers;

  String state = "normal";

  StreamSubscription<Event> ridestreamSubscription;

  bool isRequestingPositionDetails = false;

  @override
  void initState() {
    super.initState();
    AssistantMethods.getCureentOnlineUserInfo();
  }

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    //******************************************rider request or decline ************************************//

    Map riderinfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo.name,
      "rider_phone": userCurrentInfo.phone,
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
    };
    rideRequestRef.set(riderinfoMap);
    
    ridestreamSubscription = rideRequestRef.onValue.listen((event) async{
      if(event.snapshot.value == null)
        {
          return;
        }
      if(event.snapshot.value["car_details"]!=null)
      {
        setState(() {
          carDetailsDriver=event.snapshot.value["car_details"].toString();
        });
      }
      if(event.snapshot.value["driver_name"]!=null)
      {
        setState(() {
          driverName=event.snapshot.value["driver_name"].toString();
        });
      }
      if(event.snapshot.value["driver_phone"]!=null)
      {
        setState(() {
          driverphone=event.snapshot.value["driver_phone"].toString();
        });
      }
      if(event.snapshot.value["driver_location"]!=null)
      {

          double driverLat=double.parse(event.snapshot.value["driver_location"]["latitude"].toString());
          double driverLng=double.parse(event.snapshot.value["driver_location"]["longitude"].toString());
          LatLng driverCurrentLocation = LatLng(driverLat,driverLng);
          if(statusRide == "accepted")
            {
              updateRideTimeToPickUpLoc(driverCurrentLocation);
            }
          else if(statusRide == "onride")
          {
            updateRideTimeToDropOffLoc(driverCurrentLocation);
          }
          else if(statusRide == "arrived")
          {
            setState(() {
              rideStatus = "Driver has Arrived. ";
            });

          }


      }
      if(event.snapshot.value["status"]!=null)
        {
          statusRide=event.snapshot.value["status"].toString();
        }
      if(statusRide == "accepted")
        {
          displayDriverDetailsContainer();
          Geofire.stopListener();
          deleteGeofireMarkers();
        }

      /******************************************************Pay Dialog Function**********************************************************************/
      if(statusRide == "ended")
      {
        if(event.snapshot.value["fares"] != null)
          {
            int fare =int.parse(event.snapshot.value["fares"].toString());
            var res = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>CollectFareDialog(paymentMethod:"cash",fareAmount: fare,),
            );

            String driverId = "";

            if(res == "close")
              {
                if(event.snapshot.value["driver_id"]!=null)
                  {
                    driverId = event.snapshot.value["driver_id"].toString();

                  }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RatingScreen(driverId:driverId)));



                rideRequestRef.onDisconnect();
                rideRequestRef = null;
                ridestreamSubscription.cancel();
                ridestreamSubscription=null;
                resetApp();
              }
          }
      }

    });
  }

  void deleteGeofireMarkers()
  {
    setState(() {
      markersSet.removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }




  /**************************************************************Driver to pickup location time*************************************************/
  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async
  {
    if(isRequestingPositionDetails==false)
      {
        isRequestingPositionDetails=true;

        var positionUserLatLng =  LatLng(currentPosition.latitude,currentPosition.longitude);
        var details = await AssistantMethods
            .obtainDirectionDetails(driverCurrentLocation ,positionUserLatLng);
        if(details == null){
          return;
        }
        setState(() {
          rideStatus = "Driver on The Way - " + details.durationText;
        });
      }
    isRequestingPositionDetails=false;

  }
  /**************************************************************Driver to dropoff location time*************************************************/
  void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async
  {
    if(isRequestingPositionDetails==false)
    {
      isRequestingPositionDetails=true;

      var dropOff =  Provider.of<AppData>(context,listen: false ).dropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff.latitude,dropOff.longitude );



      var details = await AssistantMethods
          .obtainDirectionDetails(driverCurrentLocation ,dropOffUserLatLng);
      if(details == null){
        return;
      }
      setState(() {
        rideStatus = "Reaching Destination - " + details.durationText;
      });
    }
    isRequestingPositionDetails=false;

  }




//*********************reseting app after user click cancel button *******************************/
  resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestrideConatinerHeight = 0;
      bottomPaddingofMap = 230.0;
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();

      statusRide = "";
      driverName="";
      driverphone="";
      carDetailsDriver="";
      rideStatus = "Driver on The Way";
      driverDetailsContainerHeight = 0.0;



    });
    locatePosition();
  }

  //canceling the ride

  void cancelRideRequest() {
    rideRequestRef.remove();

    setState(() {
      state = "normal";
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestrideConatinerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingofMap = 230.0;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240;
      bottomPaddingofMap = 230.0;
      drawerOpen = false;
    });
  }

  void displayDriverDetailsContainer(){
    setState(() {
      requestrideConatinerHeight=0.0;
      rideDetailsContainerHeight=0.0;
      bottomPaddingofMap = 270.0;
      driverDetailsContainerHeight=300.0;
    });
  }

//************************place api bata place ligegko*****************************//
  //*************************finding the position of the user******************************//

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

    initGeoFireListner();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
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
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              "images/user_icon.png",
                            ),
                            radius: 50,
                            child: Padding(
                              padding: EdgeInsets.only(top: 70, left: 70),
                              child: FloatingActionButton(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  print("edioss");
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // " ${userCurrentInfo.name}",
                                "Name",
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
                    onTap: () {
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
                            fontSize: 17.0,
                            color: Colors.white,
                            letterSpacing: 2),
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
                  if (drawerOpen) {
                    scaffoldKey.currentState.openDrawer();
                  } else {
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
                      (drawerOpen) ? Icons.menu : Icons.close,
                      color: Colors.black,
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),

            //**********************************hi there , where to home location wala container ****************************//

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: Duration(milliseconds: 160),
                child: Container(
                  height: searchContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(15.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                        colors: [
                          // backgroundColor: Color(0xFFB6D7BE),
                          Color(0xFFB6D7BE),
                          Colors.red,

                          Colors.blue,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20)),
                      // color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.0),
                          Text(
                            "Hi There",
                            // "hi ${userCurrentInfo.name ?? "There"}",

                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Brand-Bold",
                                color: Colors.black,
                                letterSpacing: 3),
                          ),
                          Text(
                            "Where to ?",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Brand-Bold",
                                color: Colors.black),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ),
                              );
                              if (res == "obtainDirection") {
                                displayRideDetailsContainer();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Search Drop off",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Provider.of<AppData>(context)
                                                .pickUpLocation !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .pickUpLocation
                                            .placeName
                                        : "Add Home",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Home Location",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          DividerWidget(),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.work,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add Work",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Office Location",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //*****************************************request ride wala*******************************************//

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: Duration(milliseconds: 160),
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.blueGrey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/taxi.png",
                                  height: 70.0,
                                  width: 80.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Car",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "Brand-Bold",
                                          color: Colors.white,
                                          letterSpacing: 2),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Brand-Bold",
                                          color: Colors.white,
                                          letterSpacing: 2),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  ((tripDirectionDetails != null)
                                      ? 'Rs.${AssistantMethods.calculatefares(tripDirectionDetails)}'
                                      : ''),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Brand-Bold",
                                      color: Colors.white,
                                      letterSpacing: 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.moneyCheckAlt,
                                size: 18.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Cash",
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 1),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                state = "requesting";
                              });

                              displayRequestRideContainer();
                              availableDrivers =
                                  GeoFireAssistant.nearbyAvailableDriversList;
                              searchNearestDriver();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(14.0),
                            ),
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.taxi,
                                    color: Colors.white,
                                    size: 26.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //*********************************************Animated Text kit container and Request cancel ui*********************************//

            Positioned(
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
                height: requestrideConatinerHeight,
                //USING PACKAGE ANIMATED TEXT KIT
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText("Requesting a Ride",
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors),
                              ColorizeAnimatedText("Please wait ...",
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors),
                              ColorizeAnimatedText(
                                "Finding a Driver...",
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                            ],
                            isRepeatingAnimation: true,
                            totalRepeatCount: 1000,
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRideRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(26.0),
                            border: Border.all(width: 2.0, color: Colors.red),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 26.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel Ride",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /**************************************************View Driver Deatils*******************************************/
            Positioned(
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
                   color: Colors.white,
                  // color: Color(0xFFB6D7BE),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7)),
                  ],
                ),
                height: driverDetailsContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(rideStatus,textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0,fontFamily: "Band-Bold",fontWeight: FontWeight.w700,letterSpacing: 2,color: Colors.black),),
                        ],
                      ),
                      SizedBox(height: 22.0,),

                      Divider(height: 2.0,thickness: 2.0,),
                      SizedBox(height: 10.0,),


                      Row(
                        children: [
                          Icon(FontAwesomeIcons.car,color: Colors.blueGrey,size: 25,),
                          SizedBox(width: 20,),
                          Text(carDetailsDriver,style: TextStyle(color: Colors.black,fontSize: 20,letterSpacing: 1,fontStyle: FontStyle.italic),),
                        ],
                      ),
                      SizedBox(height: 10.0,),

                      Row(
                        children: [
                          Icon(Icons.person_outline,color: Colors.blueGrey,size: 30,),
                          SizedBox(width: 20,),
                          Text(driverName,style: TextStyle(fontSize: 20.0,color: Colors.black,letterSpacing: 1,fontWeight: FontWeight.bold),),
                        ],
                      ),

                      SizedBox(height: 10.0,),

                      Divider(height: 2.0,thickness: 2.0,),

                      SizedBox(height: 30.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // call button addition

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onPressed: ()async{

                                launch(('tel://${driverphone}'));


                              },
                              color: Colors.green,
                              child: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Call Driver",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.call, color:Colors.white, size:26.0),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ],

                      ),


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

  //***********************give place direction , place prediction  ***************************//

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

    //************************************polyline drawing system ***********************************//

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

    //************************************polyline drawing system from rider to driver***********************************//

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

  /******************************Display nearby drivers***************************/
  void initGeoFireListner() {
    Geofire.initialize("availableDrivers");

    //comment
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 200)
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearbyAvailableDriversList
                .add(nearbyAvailableDrivers);

            if (nearbyAvailableDriverKeysLoaded == true) {
              updateAvailableDriversOnMap();
            }

            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();

            break;
        }
      }

      setState(() {});
    });
    //comment
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearbyAvailableDriversList) {
      LatLng driverAvailablePosition =
          LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvailablePosition,
        icon: nearByIcon,
        rotation: AssistantMethods.createRandomNumber(360),
      );

      tMakers.add(marker);
    }
    setState(() {
      markersSet = tMakers;
    });
  }

  /******************car icon dekhaune code**********************/
  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog());
  }

  void searchNearestDriver() {
    if (availableDrivers.length == 0) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }
    var driver = availableDrivers[0];
    notifyDriver(driver);
    availableDrivers.removeAt(0);
  }

  /**************************************************PUSH NOTIFICATION AUTOMATIC*****************************************/

  void notifyDriver(NearbyAvailableDrivers driver) {
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);
    driversRef
        .child(driver.key)
        .child("token")
        .once()
        .then((DataSnapshot snap) {
      if (snap.value != null) {
        String token = snap.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, rideRequestRef.key, context);
      } else {
        return;
      }

      /***********************************Ride Request Timeout*******************************/

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.key).child("newRide").set("cancelled");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 30;
          timer.cancel();
        }

        driverRequestTimeOut =
            driverRequestTimeOut - 1; //30-1=29-1=28 and so.on

        driversRef.child(driver.key).child("newRide").onValue.listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.key).child("newRide").onDisconnect();
            driverRequestTimeOut = 30;
            timer.cancel();
          }
        });

        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.key).child("newRide").set("timeout");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 30;
          timer.cancel();

          searchNearestDriver();
        }
      });
    });
  }
}
