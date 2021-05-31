import 'package:flutter/material.dart';

void main()=>runApp(TipPage());

class TipPage extends StatefulWidget {


  @override
  _TipPageState createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: CalculatedPage(),
    );
  }
}
class CalculatedPage extends StatefulWidget {


  @override
  _CalculatedPageState createState() => _CalculatedPageState();
}

class _CalculatedPageState extends State<CalculatedPage> {


  double totalBill = 0.0,  rider = 1, totalAmount = 0,tipAmount=0,tipPercentage=5;

  void tipAdd(){
   setState(() {
     tipPercentage ++;
   });
  }
  void tipMinus(){
    setState(() {
      tipPercentage --;
    });
  }

  void riderAdd(){
   setState(() {
     rider ++;
   });
  }
  void riderMinus(){
   setState(() {
     rider --;
   });
  }



  void calculate(){
 if(rider==1){
   setState(() {
     tipAmount = totalBill * (tipPercentage/100);
     totalAmount = totalBill + tipAmount;
   });
 }
 else
   {
     setState(() {
       tipAmount = totalBill * (tipPercentage/100);
       totalAmount = totalBill + tipAmount;
       tipAmount = tipAmount/rider;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blue,
        
        title:Center(child: Text('Driver Tip Calculator',style: TextStyle(fontSize: 15),)),
      ),
      drawer: Drawer(
        elevation: 7,
        child: ListView(
          children: [
            ListTile(
              onTap: (){},
leading: Icon(Icons.home),
              title:Text('Home'),
            ),
          ],
        ),
      ),
      body: Container(

        margin: EdgeInsets.all(30),
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(

          border: Border.all(color:Colors.black,width: 5),
              borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              offset: Offset(0,3),
              blurRadius: 4,
              spreadRadius: 3,
            ),
          ],
              
        ),
        child: SingleChildScrollView(
          child: Column(

           mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                
                onChanged: (val){
                  totalBill = double.parse(val);
                },
                decoration: InputDecoration(

                  hintText: 'Your Bill Amount',

                ),
                keyboardType: TextInputType.number,

              ),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tip %'),
                  SizedBox(width: 20,),

                  GestureDetector(
                    onTap: (){
                      tipMinus();
                    },
                    child: Icon(Icons.remove_circle),
                  ),
                  SizedBox(width: 10,),
                  Text('${tipPercentage}%'),
                  SizedBox(width: 1,),
                  GestureDetector(
                    onTap: (){
                      tipAdd();
                    },
                    child: Icon(Icons.add_circle),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Rider'),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      riderMinus();
                    },
                    child: Icon(Icons.remove_circle),
                  ),
                  SizedBox(width: 10,),
                  Text('$rider'),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      riderAdd();
                    },
                    child: Icon(Icons.add_circle),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  if(totalBill>0){
                    calculate();
                  }

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 17),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(20)
                  ),
                 child: Text('Calculate',style: TextStyle(
                   fontSize: 17,
                   color: Colors.white

                 ),),
                ),
              ),
             SizedBox(
               height: 10,
             ),
             tipAmount !=0 ? Text('Tip : $tipAmount') : Container(),
              SizedBox(height: 10,),
             totalAmount !=0 ? Text('Total Amount : $totalAmount') : Container(),

            ],
          ),
        ),

      ),
      //Delete this navigation bar //TODO
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          
        ],
      ) ,
    );
  }
}

