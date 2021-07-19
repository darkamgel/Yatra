

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';

String mapKey = "your key";

StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> rideStreamSubscription;

User firebaseUser;
User currentfirebaseUser;

Users userCurrentInfo;
final assetsAudioPlayer = AssetsAudioPlayer();
Position currentPosition;

Drivers driversInformation;

String title = "";
double starCounter = 0.0;
String rideType = "";