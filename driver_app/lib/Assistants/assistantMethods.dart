import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/Assistants/resquestAssitant.dart';
import 'package:driver_app/Models/directionDetails.dart';
import 'package:driver_app/configMaps.dart';

class AssistantMethods {


  static Future<DirectionDetails> obtainDirectionDetails(LatLng initialPosition ,LatLng finalPosition)async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude} &key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];


    return directionDetails;




  }

  static int calculatefares(DirectionDetails directionDetails){
    //interms of USD//for each minute we are charging $.20
    double timeTraveledfare = (directionDetails.durationValue/60) * 0.10;
    //per km $.20
    double distanceTraveledfare = (directionDetails.distanceValue/1000) * 0.10;

    double totalFareAmount = timeTraveledfare + distanceTraveledfare;


    //1$ = 120

   double totalLocalAmount =  totalFareAmount * 120;

   return totalLocalAmount.truncate();

  }


  /***************Ride Request accept garepaxxi driver ko diable ani enable method******************/

  static void disablehomeTabliveLocationUpdates()
  {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentfirebaseUser.uid);
  }

  static void enablehomeTabliveLocationUpdates()
  {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

  }






}
