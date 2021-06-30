import 'package:flutter/material.dart';
import 'RatingUI.dart';
void main() => runApp(RatingAppUI());

class RatingAppUI extends StatelessWidget {
  const RatingAppUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RatingUI(),
    );
  }
}
