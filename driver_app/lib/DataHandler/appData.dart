import 'package:driver_app/Models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:driver_app/Models/address.dart';


class AppData extends ChangeNotifier
{
  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateEarnings(String updatedEarnings)
  {
    earnings = updatedEarnings;
    notifyListeners();
  }
  void updateTripsCounter(int tripCounter)
  {
    countTrips  = tripCounter;
    notifyListeners();
  }
  void updateTripKeys(List<String> newKeys)
  {
    tripHistoryKeys  = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachhistory)
  {
    tripHistoryDataList.add(eachhistory);
    notifyListeners();
  }




}

