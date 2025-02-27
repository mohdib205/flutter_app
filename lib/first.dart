
import 'package:first_project/SIgnUpForm.dart';
import 'package:first_project/veiws/Griidd.dart';
import 'package:first_project/veiws/app1.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding

import 'package:http/http.dart' as http;

String ur="https://modestgallery.pythonanywhere.com";
void main(){
  runApp(MyApp());
}
Future<String> getData() async {
  http.Response res = await http.get(Uri.parse("https://modestgallery.pythonanywhere.com/carousal/"));
      return res.body;
  }



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentidx = 0;

  // List of pages to display
  final List<Widget> _pages = [
    HomeView(),
    SignUpForm(),
    ProdStf(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentidx = index; // updating
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "Flutter App",
// routes: ,
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: _pages[_currentidx], // display  the  page of current index fromm pages
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentidx, //   selected item
          onTap: _onItemTapped, //  navigation
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home
              ,
                  color: _currentidx == 0 ? Colors.red : Colors.black),
              label: "Home",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person ,
                color: _currentidx == 1 ? Colors.red : Colors.black,),
              label: "Account",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop ,
                  color: _currentidx == 2 ? Colors.red : Colors.black),
              label: "Products",
            ),
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//
//     return MaterialApp(
//       title: "Flutter App",
//         initialRoute: "/",
//         routes: {
//           '/products': (context) => MyGrids(),
//           '/account': (context) => SignUpForm(),
//           "/":(context)=> HomeView() ,
//           '/home': (context) => HomeView(),
//         },
//
//         // debugShowCheckedModeBanner: false,
//       // home: HomeView()
//     );
//   }
// }



// void main(){
//   print("Hello WOrld");
//
//   runApp(Container( color: Colors.blue) );
//
// }