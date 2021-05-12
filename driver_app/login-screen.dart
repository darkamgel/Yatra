import 'package:driver_app/pallete.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/done.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            )),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      'Yatra',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        letterSpacing: 15,
                      ),
                    ),

                  ),

                ),
                 Flexible(child:Text(
                     'Driver login',
                     style: TextStyle(
                       color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 25,
                         letterSpacing: 8,
                     )

                 ),
                 ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          hintText: 'Email',
                         hintStyle: TextStyle(color: Colors.white,fontSize: 20),
                          labelStyle: TextStyle(color: Colors.white),

                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,

                      ),
                    ),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white,fontSize: 20),
                          labelStyle: TextStyle(color: Colors.white),

                        ),
                        obscureText: true,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,

                      ),
                    ),

                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Forgot Password',
                    style:TextStyle(
                    color: Colors.white,
                      fontSize: 20

                    ),
                    ),

                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 70,
               width: 200,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
                 color: Colors.teal.shade800,
               ),
               child: FlatButton(
               onPressed: (){},
                 child: Text(
                   'Login',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 20,
                     letterSpacing: 3,
                     fontWeight: FontWeight.bold,

                   ),
                 ),

                  ),

                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text('Create New Account',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    letterSpacing: 3,
    fontWeight: FontWeight.bold,

    ),

                  ),
                  decoration: BoxDecoration(border:
                  Border(
                    bottom: BorderSide(width: 2,color: Colors.white)
                  ),
                  ),
                ),

              ],

            ),


          ),

        ),
      ],
    );
  }
}
