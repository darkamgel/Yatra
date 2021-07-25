

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/Models/allUsers.dart';

String mapKey = "Your Api key";


User firebaseUser;

Users userCurrentInfo;

int driverRequestTimeOut = 30;

String statusRide = "";
String rideStatus = "Driver on The Way";
String carDetailsDriver="";
String driverName="";
String driverphone="";

double starCounter = 0.0;
String title ="";
String carRideType = "";


String serverToken = "key=AAAAXhCTTEk:APA91bEr0FzC1-S8-O4cHBWsLV1ZuIhh6g2td_5T3-tZenygczf8BrbKyQwbcmtHQp9YrfChIcWyd3-jZ9krRadIk6o8x5tNvpeWKFBnBcS2dtZG7wpiZm-C6PxKfVJr6CrLdjkktN4z";