import 'dart:convert';
import 'package:first_project/SIgnUpForm.dart';
import 'package:first_project/veiws/ServerUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'first.dart';




final storage = FlutterSecureStorage();


void main(){


  runApp(LoginForm());
}

class LoginForm extends StatelessWidget{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TextEditingController uname_c= TextEditingController();
  TextEditingController pass_c= TextEditingController();



  @override
  Widget build(BuildContext context) {
  // TODO: implement build
  return  MaterialApp(
  theme:  ThemeData(primarySwatch: Colors.green),
  home: Scaffold(
  appBar:AppBar(
  title: Center(child: Text('Log In Form')),
  ),
  body: SingleChildScrollView(

  child: Column(

  children: [ Text("Log In "  , style: TextStyle(color: Colors.red , fontSize: 20 , fontWeight: FontWeight.bold),) ,
  SizedBox(height: 10,),
  Center(
  child: Form(
  key: _formKey,
  child: Column(

  // mainAxisAlignment: mainAxisAlignment.cw,
  children: [

  SizedBox(
  width: MediaQuery.of(context).size.width > 600
  ? 500 : MediaQuery.of(context).size.width * 0.9,
  child: TextFormField(
  keyboardType: TextInputType.text,
  controller: uname_c,
  decoration: InputDecoration(

  hintText: 'Username' ,
  label: Text('Enter username'),
  contentPadding:
  EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
  icon: Icon(Icons.account_box) ,
  border: OutlineInputBorder(),

  ),
  ),

  ),
  SizedBox(height: 20,),
    SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? 500 : MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: pass_c,
        decoration: InputDecoration(

          hintText: 'Password' ,
          label: Text('Enter Password'),
          contentPadding:
          EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
          icon: Icon(Icons.account_box) ,
          border: OutlineInputBorder(),

        ),
      ),

    ),
    SizedBox(height: 20,),


  Container(

  width: MediaQuery.of(context).size.width > 600
  ? 250 : MediaQuery.of(context).size.width * 0.5,
  height: 50,
  margin: EdgeInsets.only(left: 40.0 ),

  child: ElevatedButton(
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  ),

  onPressed: () {
  if (_formKey.currentState!.validate()) {
  Map<String, dynamic> data= { 'username':uname_c.text , 'password':pass_c.text};
  print(data);
  login(uname_c.text, pass_c.text).then((tokens) {
    print(tokens['access']);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(tokens['access']!);
      print(JwtDecoder.isExpired(tokens['access']!));
      print(decodedToken);

    print(tokens['refresh']);
    storeTokens(tokens);
  }).catchError((e) {
    print('Error: $e');
  });


  // uname_c.clear();
  // pass_c.clear();
  }
  },
  child: Text('Log In'),

  ),
  ),
SizedBox(height: 10,),
Container(
  child: Wrap(
    children: [
      Text("Register Account    " , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),),
      ElevatedButton(onPressed: () {
        // print("Card tapped!"+ ProductData[index]["product_variation_id"] );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              MyApp(custom: 0,))); // QuantitySelector();
      },child: Text("Sign Up")
      , style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Rectangular border
            )

      ))
    ],
  ),
)
  ],
  )),
  )],
  ),
  ),
  ),
  );
  }


  }


Future<Map<String,String>> login(String username, String password) async {
  final response = await http.post(
    Uri.parse(BackendApi.endpoint("login")),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return {
    'access':jsonDecode(response.body)['access'],
      'refresh':jsonDecode(response.body)['refresh']
  };
  } else {
    print(response.statusCode);
    throw Exception(' login failedd');
  }
}

Future<void> storeTokens(Map<String,String> token) async {
  await storage.write(key: 'access', value: token["access"]);
  await storage.write(key: 'refresh', value: token["refresh"]);
}

Future<Map<String,String?>> getTokens() async {
  return {'access':  await storage.read(key: 'access'),
    'refresh':await storage.read(key: 'refresh')
  };
}

Future<String> getAccesstoken() async {
  String? currentAccess= await storage.read(key: 'access');
  String? refreshToken = await storage.read(key: 'refresh');
  if (refreshToken == null 	|| JwtDecoder.isExpired(refreshToken) ) {
    print("No refresh token found or expired");
    return "u needs to log in again";
  }

  if (JwtDecoder.isExpired(currentAccess!)){
    final res= await http.post(Uri.parse(BackendApi.endpoint("refreshtoken")),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },

      body: jsonEncode(<String, String>{
        'refresh': refreshToken,
      }),
    );
    if (res.statusCode==200){
      final Map<String, dynamic> response = jsonDecode(res.body);
      String acc= response["access"];

      print("accc  ${acc}");
      storage.write(key: 'access', value: acc);
      return acc;
    }
    else{
      print(res.statusCode);
      return "Error Occured";
    }

    // storage.write(key: 'access' , value: res.);

  }

   else{
     return currentAccess;
  };
}

