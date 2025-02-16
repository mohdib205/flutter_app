
import 'package:flutter/material.dart';

void main(){
  runApp( MyPage());
}

class MyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

   return  MaterialApp(
     title: 'MY Table',
     home: MyTable(),
     theme:  ThemeData(primarySwatch: Colors.green),

   );
  }

}

class MyTable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   
    return Stack(
      children: [Positioned(
        width: 200,
        child: Container(
          padding: EdgeInsets.all(10),

          // height: 100,
          // width: 200,

          // color: Colors.green,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10) ,
            color: Colors.deepOrange[50 ]
          ),
          child: Text("Home"),
        ),
      ) ,
        Positioned(
          left: 175,
          top: 0,
          width: 200,
          child: Container(
            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10) ,
                color: Colors.deepOrange[50]
            ),
            child: Text("Insert"),

          ),
        ),
        Positioned(
          left: 360,
          top: 0,
          width: 200,
          child: Container(
            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10) ,
                color: Colors.deepOrange[50]
            ),
            child: Text("About"),

          ),
        )


    ],
    );

}}