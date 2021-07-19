import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/Models/allUsers.dart';

User firebaseUser;

Users userCurrentInfo;

int driverRequestTimeOut = 30;

String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver="";
String driverName="";
String driverphone="";

double starCounter = 0.0;
String title ="";
String carRideType = "";

String serverToken = "key=Your token from firebase"