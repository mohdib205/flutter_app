import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import 'ServerUrl.dart';

class HomeView extends StatelessWidget{


  @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        appBar: AppBar(
          title: Center(child: const Text('My First Flutter Application' )),
                actions: [
        Icon(Icons.favorite),
        Icon(Icons.notifications),
      // Adds space at the end
    ],
          elevation: 20,
          //we use actions to give list of Widgets to display in a row after the title widget.          //
    ),

    body: SingleChildScrollView(
      child: Column(
          children: [SearchBar() ,
              ImagesScrollBar(),
            ImageCarousal(),
            ImageText()
    ])
              )
     ,
      );
  }

}


class SearchBar  extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
            // width:
          )),
      margin:EdgeInsets.fromLTRB(100, 10, 50, 10) ,
      width: double.infinity,
      child: TextField(
          decoration: InputDecoration(
            hintText: 'Search forrrrr',


          )

      ),
    );
  }

}

class ImagesScrollBar extends StatelessWidget {
  // Function to fetch data from API
  Future<List<Map<String, dynamic>>> fetchCarouselData() async {
    final response = await http.get(Uri.parse(BackendApi.endpoint("carousal")));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => {
            "id":item["id"],
        "image": item["image_carousal"],
        "image_name": item["image_name"]
      })
          .toList();

    }
    else {
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCarouselData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<Map<String, dynamic>> carouselData = snapshot.data!;
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: carouselData.length,
              itemExtent: 120,
              itemBuilder: (context, index) {
                String? imageUrl = carouselData[index]["image"];
                String imageName = carouselData[index]["image_name"] ?? "Unknown";

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl) : AssetImage("assets/placeholder.png") as ImageProvider,
                    ),
                    Text(imageName),
                  ],
                );
              },
            ),
          );
        } else {

          return Center(child: Text("No data available"));
        }
      },
    );
  }
}




class ImageCarousal extends StatelessWidget{



  Future<List<Map<String, dynamic>>> fetchCollections() async {
    final response= await http.get(Uri.parse(BackendApi.endpoint("collections")));
    if (response.statusCode==200){
      final List<dynamic> data= json.decode(response.body);

      return data
          .map((item) => {
        "collection_id": item["collection_id"],
        "collection_image": item["collection_image"]
      })
          .toList();
    }
    else{
      throw Exception("failed ");
    }
  }

  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
     future: fetchCollections(),

     builder: (BuildContext context, snapshot) {
       if (snapshot.connectionState==ConnectionState.waiting){
         return Center(child: Text("Data is Loading"));
       }
       else if (snapshot.hasError){
         return  Center(child: Text("Error: ${snapshot.error}"));

         }
        else if (snapshot.hasData) {
          List<Map<String, dynamic>> CollectionData = snapshot.data!;


          return Container(
              margin: EdgeInsets.fromLTRB(50, 30, 50, 10),
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions(
                    // height: 500,
                    aspectRatio: 0.5,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 1000)
                ),
                items: CollectionData.map((item) =>
                    Center(
                        child:
                        ExcludeSemantics(
                          child: Image.network(item["collection_image"], fit: BoxFit.cover,
                              // height: 400,
                              width: double.infinity),
                        )),
                )
                    .toList(),
              ));
        }
       else {

         return Center(child: Text("No data available"));
       }
        },);
  }

}


class  ImageText extends StatelessWidget{
  Future<List<Map<String, dynamic>>> fetchCategories() async{
    final response =  await http.get(Uri.parse(BackendApi.endpoint("category")));

    if (response.statusCode==200){
      List<dynamic> data= json.decode(response.body);
      return data.map((e)=>{
        "category_id": e["category_id"],
        "category_name":e["category_name"],
        "category_image":e["category_image"]

      }).toList();
    }
    else{
      throw Exception(Text("data is not fetched"));
    }

  }


  @override
  Widget build(BuildContext context) {
    return   FutureBuilder(
      future: fetchCategories(),
      builder: ( context,  snapshot)
      {
        if (snapshot.connectionState==ConnectionState.waiting){
          return Center(child: Text("Data is getting load"));
        }
        else if (snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        else if (snapshot.hasData) {
          List<Map<String, dynamic>>? CategoryData= snapshot.data;
          return Column(

            children: CategoryData!.map((obj) {
              return ExcludeSemantics(
                child: Column(
                  children: [
                    Text(
                        obj["category_name"] ?? "no name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , fontStyle: FontStyle.italic)
                    ),
                    SizedBox(height: 4,),
                    Image.network(obj["category_image"]!),
                    SizedBox(height: 100,),
                  ],
                ),
              );
            }).toList(),

          );
        }
        else{
          return Center(child: Text("No data available"));
        }
        },

    );
  }


}

