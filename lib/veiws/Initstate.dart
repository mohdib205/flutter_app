import 'package:flutter/material.dart';

// When we don't use await so it print the data
void main() {
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String data = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchData();
    print('data');
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 8)); // Simulate API call
    setState(() {
      data = 'Data loaded!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}
