import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingUI extends StatelessWidget {
  const RatingUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text("Driver Rating"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Rating...',style: TextStyle(fontSize: 20.0),),
            RatingBar.builder(
              itemCount: 5,
              initialRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating){
                print(rating);
              },
            ),
          ],
        ),
      ),
    );
  }
}
