
import 'package:flutter/material.dart';

void main(){

  print("Hello World");
  runApp(SignUpForm());
}

class SignUpForm extends StatelessWidget{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fname_c= TextEditingController();
  TextEditingController lname_c= TextEditingController();
  TextEditingController email_c= TextEditingController();
  TextEditingController uname_c= TextEditingController();
  TextEditingController phone_c= TextEditingController();
  TextEditingController pass_c= TextEditingController();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  MaterialApp(
      theme:  ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar:AppBar(
          title: Center(child: Text('Sign Up Form')),
        ),
        body: SingleChildScrollView(

          child: Column(

            children: [ Text("Sign Up "  , style: TextStyle(color: Colors.red , fontSize: 20 , fontWeight: FontWeight.bold),) ,
              SizedBox(height: 10,),
              Center(
                child: Form(
                    key: _formKey,
                    child: Column(

                  // mainAxisAlignment: mainAxisAlignment.cw,
                children: [   SizedBox(

                  width: MediaQuery.of(context).size.width > 600
                      ? 500 : MediaQuery.of(context).size.width * 0.9, 

                  child: TextFormField(
                    controller: fname_c,
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(

                      hintText: 'First Name' ,
                      label: Text('First Name'),
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                               icon: Icon(Icons.person) ,
                      border: OutlineInputBorder(),
                    ),
                  ),
                )  ,
                            SizedBox(height: 20),

                            SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? 500 : MediaQuery.of(context).size.width * 0.9, 
                child: TextFormField(
                  controller: lname_c,
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(

                      hintText: 'Last Name' ,
                      label: Text('Last Name'),
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                      icon: Icon(Icons.person_outlined) ,
                      border: OutlineInputBorder(),


                    )),
                            ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600
                        ? 500 : MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(

                      keyboardType: TextInputType.emailAddress,
                        controller: email_c,
                        decoration: InputDecoration(

                            hintText: 'Email Address' ,
                            label: Text('Email'),
                            contentPadding:
                            EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                            icon: Icon(Icons.email),
                          border: OutlineInputBorder(),

                        )),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                      width: MediaQuery.of(context).size.width > 600
                      ? 500 : MediaQuery.of(context).size.width * 0.9, 
                    child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phone_c,

                        decoration: InputDecoration(
                            hintText: 'Phone Number' ,
                            label: Text('Phone number'),
                            contentPadding:
                            EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                            icon: Icon(Icons.phone) ,
                          border: OutlineInputBorder(),

                        )),
                  ),
                  SizedBox(height: 20),

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
                        keyboardType: TextInputType.phone,
                        controller: pass_c,

                        decoration: InputDecoration(
                          hintText: 'Password' ,
                          label: Text('Password'),
                          contentPadding:
                          EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                          icon: Icon(Icons.phone) ,
                          border: OutlineInputBorder(),

                        )),
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
                          Map<String, dynamic> data= {'first_name':fname_c.text ,'last_name':lname_c.text  , 'email':email_c.text , 'contact': phone_c.text , 'username':uname_c.text };
                          print(data);
                        fname_c.clear();
                        lname_c.clear();
                        email_c.clear();
                        phone_c.clear();
                        uname_c.clear();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),

                ],
                            )),
              )],
          ),
        ),
      ),
    );
  }


}

// class MyBottomBar extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       // color: Colors.red,
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(onPressed: ()=>{
//     print(Navigator.of(context)),
//     Navigator.pushReplacementNamed(context, "/home")
//           }, icon: Icon(Icons.home ) ,   )  ,
//           IconButton(onPressed: ()=>{
//             Navigator.pushReplacementNamed(context, "/account")
//
//
//           }, icon: Icon(Icons.person) ,color: Colors.red,) ,
//           IconButton(onPressed: ()=>{
//             Navigator.pushReplacementNamed(context, "/products")
//
//           }, icon: Icon(Icons.shop) ,) ,
//
//
//         ],
//       ),
//     );
//   }


// }
