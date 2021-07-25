import 'package:flutter/material.dart';

//input textfield haru ko lagi like email password and so .om

class inputTextField extends StatelessWidget {
  inputTextField(
      {@required this.Controller,
        @required this.Icons,
          @required this.text,

            });

  final TextEditingController Controller;
  final IconData Icons;
  String text;




  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: Controller,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,



      decoration: InputDecoration(
        fillColor: Colors.grey[500].withOpacity(0.5),
        filled: true,
        prefixIcon: Icon(
          Icons,
          //Icons.email
          color: Colors.white,
          size: 30,
        ),
        //paxi add gareko
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),

        ///yeta samma

        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        hintStyle: TextStyle(color: Colors.grey, fontSize: 20.0),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }
}

//input text like forgot password ,donot have a account and so.on
class flattyButton extends StatelessWidget {
  flattyButton({@required this.onpressed, @required this.text});

  Function onpressed;
  String text;




  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onpressed,
        child: Text(
          text,

           // style: textStyle,
             style: TextStyle(fontSize: 19.0,color: Colors.blue,letterSpacing:0),
        ));
  }
}



