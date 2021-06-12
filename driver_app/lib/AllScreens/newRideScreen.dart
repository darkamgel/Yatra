import 'dart:async';

import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';


import 'package:driver_app/Models/riderDetails.dart';
import 'package:driver_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../configMaps.dart';

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

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polylineCorOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation
  );
  BitmapDescriptor animatingMarkerIcon;
  Position myPosition;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car-android.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }
  void getRideLiveLocationUpdates()
  {
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          currentPosition = position;
          myPosition = position;
          LatLng mPosition = LatLng(position.latitude, position.longitude);
          Marker animatingMarker = Marker(
              markerId:MarkerId("animating"),
            position:mPosition,
            icon: animatingMarkerIcon,
            infoWindow: InfoWindow(title: "Current Location"),
          );
          setState(() {
            CameraPosition cameraPosition = new CameraPosition(target: mPosition,zoom: 17);
            newRideGoogleMapController.animateCamera(
                CameraUpdate.newCameraPosition(cameraPosition));
            
            markersSet.removeWhere((marker)=>marker.markerId.value == "animating");
            markersSet.add(animatingMarker);

          });
          
        });

  }













  @override
  Widget build(BuildContext context) {
     createIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,

            markers: markersSet,
            circles: circleSet,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) async{
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;


              // setState(() {
              //   mapPaddingFromBottom = 265.0;

              // });


              var currentLatLng = LatLng(
                  currentPosition.latitude, currentPosition.longitude);
              var pickUpLatLng = widget.rideDetails.pickup;

               await getPlaceDirection(currentLatLng, pickUpLatLng);
                getRideLiveLocationUpdates();
            },
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              height: 270.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
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
                        Text("Sandeep kshetri", style: TextStyle(
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
                        Image.asset(
                          "images/pickicon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              "street 66 paris,france",
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Image.asset(
                          "images/desticon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              "street 77 paris,france",
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 26.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {},
                        // color: Theme.of(context).accentColor,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Arrived", style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              ),
                              Icon(Icons.directions_car, color: Colors.white,
                                size: 26.0,),

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
    );
  }

//***********************************Direction Details*****************************************//

  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async {


    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "please wait...",
        ));

    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);


    Navigator.pop(context);
    print("This is Encoded Points::");
    print(details.encodedPoints);

    //************************************polyline drawing system ***********************************//

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
    polylinePoints.decodePolyline(details.encodedPoints);

    polylineCorOrdinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCorOrdinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCorOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLineSet.add(polyline);
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

    newRideGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),

      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }


  void acceptRideRequest()
  {
    String rideRequestId = widget.rideDetails.ride_request_id;
    newRequestsRef.child(rideRequestId).child("status").set("accepted");
    newRequestsRef.child(rideRequestId).child("driver_name").set(driversInformation.name);
    newRequestsRef.child(rideRequestId).child("driver_phone").set(driversInformation.phone);
    newRequestsRef.child(rideRequestId).child("driver_id").set(driversInformation.id);
    newRequestsRef.child(rideRequestId).child("car_details")
        .set('${driversInformation.car_color} - ${driversInformation.car_model} - ${driversInformation.car_number}');

    Map locMap={
      "latitude":currentPosition.latitude.toString(),
      "longitude":currentPosition.longitude.toString(),

    };

    newRequestsRef.child(rideRequestId).child("driver_location").set(locMap);
  }



}
