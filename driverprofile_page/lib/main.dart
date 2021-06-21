import 'package:flutter/material.dart';
import 'profile_page.dart';

void main() => runApp(Profilepage());

class Profilepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyInfo(),
    );
  }
}
