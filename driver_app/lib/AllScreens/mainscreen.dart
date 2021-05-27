import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:driver_app/tabsPages/earningsTabPage.dart';
import 'package:driver_app/tabsPages/homeTabPage.dart';
import 'package:driver_app/tabsPages/profiletabPage.dart';
import 'package:driver_app/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String idscreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{


  TabController tabController;
  int selectedIndex = 0;


  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningsTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.credit_card),
      //       label: "Earnings",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: "Ratings",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "Account",
      //     ),
      //   ],
      //   unselectedItemColor: Colors.black54,
      //   selectedItemColor: Colors.yellow,
      //   type: BottomNavigationBarType.fixed,
      //   selectedLabelStyle: TextStyle(fontSize: 12.0),
      //   showUnselectedLabels: true,
      //   currentIndex: selectedIndex,
      //   onTap: onItemClicked,
      // ),

      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        color: Colors.blue.shade600,
        backgroundColor: Color(0xFFB6D7BE),
        buttonBackgroundColor: Color(0xFFA2C5AC),
        items: <Widget>[

          Icon(Icons.home,size: 25,color: Colors.black,),
          Icon(Icons.credit_card,size: 25,color: Colors.black,),
          Icon(Icons.star,size: 25,color: Colors.black,),
          Icon(Icons.person,size: 25,color: Colors.black,),

        ],
        animationDuration: Duration(
          milliseconds: 200,
        ),
        animationCurve: Curves.bounceInOut,

        onTap: onItemClicked,
      ),
    );
  }
}
