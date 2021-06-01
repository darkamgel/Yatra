// @dart=2.9
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:profile_app/imagescreen.dart';


class CarView extends StatelessWidget {

  final List<Imagepage> availableList = [
    Imagepage(

      name:'Car View', image: 'images/car1.png',

    ), Imagepage(

      name:'Car View', image: 'images/car2.png',

    ), Imagepage(

      name:'Car View', image: 'images/car3.png',

    ), Imagepage(

      name:'Car View', image: 'images/car4.png',

    ),Imagepage(

      name:'Car View', image: 'images/car5.png',

    ),


  ];


  @override
  Widget build(BuildContext context) {
    return Container(
padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 300,
child: Swiper(
  itemCount: availableList.length,
  itemBuilder: (BuildContext context,  int index){
    return Container(
height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70,width: 2),
borderRadius: BorderRadius.circular(20),

        ),
        elevation: 10,
        child: Column(
         children: [
           Text(
             availableList[index].name,
             style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: 20,
             ),
           ),
      Container(
        height: 130,
        child:  Image.asset(availableList[index].image,fit: BoxFit.contain,height: 50,),
      )

         ],
        ),

      ),
    );
  },
  autoplay: false,
  scale: 0.5,
  viewportFraction: 0.6,

),
    );
  }
}

