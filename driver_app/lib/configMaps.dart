

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';

String mapKey = "your key";

User firebaseUser;
User currentfirebaseUser;
StreamSubscription<Position> homeTabPageStreamSubscription;

Users userCurrentInfo;
final assetsAudioPlayer = AssetsAudioPlayer();
Position currentPosition;