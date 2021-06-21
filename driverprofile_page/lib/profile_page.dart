import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyInfo extends StatefulWidget {
  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  bool _isopen = false;
  PanelController _panelController = PanelController();
  var _imageList = [
    'images/car1.png',
    'images/car1.png',
    'images/car1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/car1.png'), fit: BoxFit.contain),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.72,
            body: GestureDetector(
                onTap: () => _panelController.close(),
                child: Container(color: Colors.transparent)),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isopen) {
                  setState(() {
                    _isopen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isopen = false;
              });
            },
          )
        ],
      ),
    );
  }

  SingleChildScrollView _panelBody(ScrollController controller) {
    double hpadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: hpadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _titleSection(),
                _infoSection(),
                _actionSection(),
              ],
            ),
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(_imageList[index]),
                      fit: BoxFit.contain)),
            ),
          ),
        ],
      ),
    );
  }

  Row _actionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: !_isopen,
          child: Expanded(
            child: OutlineButton(
              onPressed: () => _panelController.open(),
              borderSide: BorderSide(color: Colors.blueAccent.shade400),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'Car View',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isopen,
          child: SizedBox(
            width: 12,
          ),
        ),
        Expanded(
          child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blueAccent.shade100,
            textColor: Colors.white,
            onPressed: () => print('tapped!'),
            child: Text(
              'Rate Me',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCell(title: 'Rides', value: '130+'),
        Container(
          width: 1,
          height: 40,
          color: Colors.black12,
        ),
        _infoCell(title: 'Number', value: 'Ba 5 Cha 1234'),
        Container(
          width: 1,
          height: 40,
          color: Colors.black12,
        ),
        _infoCell(title: 'Location', value: 'Pokhara'),
        Container(
          width: 1,
          height: 40,
          color: Colors.black12,
        ),
      ],
    );
  }

  Column _infoCell({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              fontSize: 13,
              letterSpacing: 1),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1),
        ),
      ],
    );
  }

  Column _titleSection() {
    return Column(
      children: [
        Text(
          'Yatra Driver',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: 1),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          'Regular',
          style:
              TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 2),
        ),
      ],
    );
  }
}
