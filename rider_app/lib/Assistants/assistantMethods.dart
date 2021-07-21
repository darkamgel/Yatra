import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/%20DataHandler/appData.dart';
import 'package:rider_app/Assistants/resquestAssitant.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/allUsers.dart';
import 'package:rider_app/Models/directionDetails.dart';
import 'package:rider_app/Models/history.dart';
import 'package:rider_app/configMaps.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app/main.dart';

class AssistantMethods {
  ///**************************************afno location dine wala **************************************///

  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=your key";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      // placeAddress = response['results'][0]['formatted_address'];
      st1 = response["results"][0]["address_components"][0]
          ["long_name"]; //society
      st2 = response["results"][0]["address_components"][1]
          ["long_name"]; //society
      st3 = response["results"][0]["address_components"][5]
          ["long_name"]; //society
      st4 = response["results"][0]["address_components"][6]
          ["long_name"]; //society

      placeAddress = st1 + ", " + st2 + ", " + st3; //concating

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  //*************************************Direction api used *****************************************//

  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude} &key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  //**********************************fare calculation per km ****************************//

  static int calculatefares(DirectionDetails directionDetails) {
    //interms of USD//for each minute we are charging $.20
    double timeTraveledfare = (directionDetails.durationValue / 60) * 0.10;
    //per km $.10
    double distanceTraveledfare =
        (directionDetails.distanceValue / 1000) * 0.10;

    double totalFareAmount = timeTraveledfare + distanceTraveledfare;

    //1$ = 120

    double totalLocalAmount = totalFareAmount * 120;

    return totalLocalAmount.truncate();
  }

  //getting current user inforamtion

  static void getCureentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }

  ////rotation ma haleko///
  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  /**************************notification sending FUnction*************************/
  //build context paxxi add gareko

  static sendNotificationToDriver(
      String token, String ride_request_id, BuildContext context) async {
    var destionation =
        Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap = {
      'body': 'DropOff Address, ${destionation.placeName}',
      'title': 'New Ride Request'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': ride_request_id,
    };

    Map SendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: headerMap, body: jsonEncode(SendNotificationMap));
  }

  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }

  static void retrieveHistoryInfo(context)
  {


    /***********************************************retrieve and display Trip History************************************************/
    //retrieve and display Trip History
    newRequestsRef.orderByChild("rider_name").once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        //update total number of trip counts to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
    {
      newRequestsRef.child(key).once().then((DataSnapshot snapshot) {
        if(snapshot.value != null)
        {
          newRequestsRef.child(key).child("rider_name").once().then((DataSnapshot dsnap)
          {
            String name = dsnap.value.toString();
            if(name == userCurrentInfo.name)
              {
                var history = History.fromSnapshot(snapshot);
                Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);

              }



          });

        }
      });
    }
  }
}
