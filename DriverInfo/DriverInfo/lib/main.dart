import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/suman.jpg')  ,
              ),
              Text(
                'Suman Pokharel',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 40.0,
                color: Colors.white,
              ),),
               Text(
                 'YATRA MEMBER',
               style:TextStyle(
                   fontFamily:'Source Sans Pro',
                   color: Colors.teal.shade100,
                   fontSize: 20.0,
                   letterSpacing: 2.5,

               )

               ),
               SizedBox(
                 height: 20.0,
                 width: 150.0,
                 child: Divider(
                   color: Colors.teal.shade100,
                 ),
               ),
               Card(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  title:Text('+977 984 523 014',
                    style: TextStyle(
                      color: Colors.teal.shade900,

                    ),) ,
                )
              ),
               Card(
                 margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                 child: ListTile(
                   leading: Icon(
                     Icons.email,
                     color: Colors.teal,
                   ),
                   title: Text(
                     'nxxir@gmail.com',
                     style: TextStyle(
                       color: Colors.teal.shade900,
                     ),
                 ),


               )
               ),
            ],
          ),
        ),
      ),
    );
  }
}
