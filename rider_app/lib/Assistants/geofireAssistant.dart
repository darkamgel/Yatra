import 'dart:math';

import 'package:rider_app/Models/nearbyAvailableDrivers.dart';

class GeoFireAssistant{

  //****************************case-i****************************/
  static List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];


//****************************case-ii****************************/
  static void removeDriverFromList(String key)
  {
    int index = nearbyAvailableDriversList.indexWhere(
            (element) => element.key == key);
    nearbyAvailableDriversList.removeAt(index);
  }

//****************************case-iii****************************/

static void updateDriverNearbyLocation(NearbyAvailableDrivers driver)
{
  int index = nearbyAvailableDriversList.indexWhere(
          (element) => element.key == driver.key);
  nearbyAvailableDriversList[index].latitude = driver.latitude;
  nearbyAvailableDriversList[index].longitude = driver.longitude;


}



}


