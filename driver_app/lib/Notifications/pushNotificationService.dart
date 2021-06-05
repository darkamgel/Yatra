

import 'package:driver_app/Models/ridedDetails.dart';
import 'package:driver_app/Notifications/NotificationDialog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize(context) async {
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      retrieveRideRequestInfo(getRideRequestId(message),context);
    }, onLaunch: (Map<String, dynamic> message) async {
      retrieveRideRequestInfo(getRideRequestId(message),context);
    }, onResume: (Map<String, dynamic> message) async {
      retrieveRideRequestInfo(getRideRequestId(message),context);
    });
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("This is token");
    print(token);
    driversRef.child(currentfirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message['data']['ride_request_id'];
    } else {
      rideRequestId = message['ride_request_id'];
    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestsRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double pickUpLocationLat =
            double.parse(dataSnapshot.value['pickup']['latitude'].toString());
        double pickUpLocationLng =
            double.parse(dataSnapshot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickup_address'].toString();

        double dropOffLocationLat =
            double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng =
            double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
        String dropOffAddress =
            dataSnapshot.value['dropoff_address'].toString();

        String paymentMethod = dataSnapshot.value['payment_method'].toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLat);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;

        print("information::");

        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(
                  rideDetails: rideDetails,
                ),
        );
      }
    });
  }
}
