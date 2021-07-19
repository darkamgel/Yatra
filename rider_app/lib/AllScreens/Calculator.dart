
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';






class BillSplitter extends StatefulWidget {
  @override
  _BillSplitterState createState() => _BillSplitterState();
}
class _BillSplitterState extends State<BillSplitter> {
  int _topPercentage=0;
  int _personCounter=1;
  double _billAmount = 0.0;

  Color _purple = Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Tip Calculator",style: TextStyle(fontFamily: "Signatra",fontSize: 30),),
          centerTitle: true,
        ),
        body:Container(



          alignment: Alignment.center,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.5),
            children: <Widget>[
              Container(
                width: 200,
                height:150,
                decoration: BoxDecoration(
                  //color: _purple.withOpacity(0.1),//Colors.purpleAccent.shade100,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(


                        padding: const EdgeInsets.all(18.0),
                        child: Text("Total per person",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                          // style: TextStyle(
                          // fontWeight: FontWeight.normal,
                          // fontSize: 15.0,
                          // color: _purple
                        ),
                      ),
                      Text("Rs. ${calculateTotalPerson( _billAmount, _personCounter,_topPercentage)}",style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.blueGrey.shade100,
                    style: BorderStyle .solid,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),

                        decoration: InputDecoration(
                            prefixText: "Total Fare : ",prefixStyle: TextStyle(fontSize: 20),
                            prefixIcon: Icon(Icons.attach_money,color: Colors.black,)
                        ),
                        onChanged: (String value){
                          try{
                            _billAmount = double.parse(value);

                          }
                          catch(exception){
                            _billAmount = 0.0;
                          }
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Split",style: TextStyle(color: Colors.black,fontSize: 20),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap:(){
                                setState(() {
                                  if(_personCounter>1){
                                    _personCounter--;
                                  }
                                  else{
                                    //do nothing
                                  }
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color:Colors.lightBlue
                                ),
                                child: Center(
                                  child: Text(
                                      "-",style: TextStyle(color: Colors.black,fontSize: 20),

                                  ),
                                ),
                              ),
                            ),
                            Text("$_personCounter",style: TextStyle(color: Colors.black,fontSize: 20),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  _personCounter++;
                                });
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(7.0)
                                ),
                                child: Center(
                                  child: Text("+"
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Tip",style: TextStyle(color: Colors.black,fontSize: 20),),
                        Text("Rs.${(calculateTotalTip(_billAmount, _personCounter, _topPercentage)).toStringAsFixed(2)}",style: TextStyle(color: Colors.black,fontSize: 20),
                        ),
                      ],

                    ),
                    SizedBox(height: 20,),
                    //slider from here
                    Column(
                      children: <Widget>[
                        Text("$_topPercentage %",style: TextStyle(color: Colors.black,fontSize: 20),
                        ),
                        Slider(
                            min: 0,
                            max: 100,
                            activeColor: _purple,
                            inactiveColor: Colors.grey,
                            //   divisions: 50,
                            value: _topPercentage.toDouble(),
                            onChanged: (double newValue){
                              setState(() {
                                _topPercentage=newValue.round();
                              });
                            })
                      ],
                    ),
                  ],
                ),

              ),
            ],
          ),
        )
    );
  }
  calculateTotalPerson(double billAmount ,int splitBy,int tippercentage){
    var totalperperson = (calculateTotalTip(billAmount, splitBy, tippercentage)+ billAmount)/splitBy;
    return totalperperson.toStringAsFixed(2);
  }
  calculateTotalTip(double billAmount , int splitBy ,int tippercentage){
    double totalTip = 0.0;
    if(_billAmount<0 || _billAmount.toString().isEmpty || billAmount==null){

    }
    else{
      totalTip=(billAmount *  tippercentage)/100;
    }
    return totalTip;
  }
}







