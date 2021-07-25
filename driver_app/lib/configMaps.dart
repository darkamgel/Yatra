

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "Your Api key";

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