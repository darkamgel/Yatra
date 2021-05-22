import 'package:flutter/cupertino.dart';
import 'package:driver_app/Models/address.dart';


class AppData extends ChangeNotifier
{
  Address pickUpLocation,dropOffLocation;

  void updatePickUpLocationAddress(Address pickupAddress)
  {
    pickUpLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

}