
import 'package:first_project/Authentication.dart';
import 'package:first_project/veiws/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ServerUrl.dart';

void main(){
  runApp(ProdStf());
}

class ProdStf extends StatefulWidget {
  const ProdStf({super.key});



  @override
  State<ProdStf> createState() => _ProdStfState();
}

class _ProdStfState extends State<ProdStf> {



  Future<List<Map<String, dynamic>>> fetchProductData() async {
    print(await getTokens());

    print(await getAccesstoken());
    String token = await getAccesstoken();
    String endpoint = BackendApi.endpoint("custom");

    print("Access Token: $token");
    print("API Endpoint: $endpoint");
    final response = await http.get(Uri.parse(BackendApi.endpoint("custom")),
      headers: {
        'Authorization': 'Bearer ${await getAccesstoken()}',
        'Content-Type': 'application/json',
      },

    );

    if (response.statusCode==200) {
      // final data = json.decode(response.body);
      List<dynamic> data = json.decode(response.body);


      return data.map((e) =>
      ({
        "product_id": e["product_id"],
        "category_name": e["category_name"],
        "sub_category_name": e["sub_category_name"],
        "product_description": e["product_description"],
        "availability": e["availability"],
        "price": e["price"],
        "stock": e["stock"],
        "product_variation_id": e["product_variation_id"],
        "variation_type": e["variation_type"],
        "variation_name": e["variation_name"],
        "discount_percent": e["discount_percent"],
        "discount_price": e["discount_price"],
        "reduced_price": e["Reduced_price"],
        "color_code": e["ColorCode"],
        "images": e["images"],
      })).toList();
    }
    else{
      print(await getAccesstoken());
      print(response.body);
      print(response.statusCode);
      throw Exception("Data not loaded properly");
    }

    }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2.5; // Divide screen into 2.5 cards
    double cardHeight = cardWidth * 1.5;
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Modest Hijab Store' )),
        elevation: 20,
        actions: [
          Icon(Icons.favorite),
          Icon(Icons.notifications),
          // Adds space at the end
        ],

      ) ,
      body:  Column(
          children: [
            SearchBar(),
            Wrap(

              children: [
                ElevatedButton(onPressed: ()=>{ print('filter')}, child: Text("Filter") ,

                  style:
                  ElevatedButton.styleFrom(
                    fixedSize: Size(screenWidth/2, 50),

                    // backgroundColor: Colors.blue,
                    // foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      // Rounded corners
                    ),) ,
                ) ,
                ElevatedButton(onPressed: ()=>{ print('Sort')}, child: Text("Sort") , style:
                ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth/2, 50),

                  // backgroundColor: Colors.blue,
                  // foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    // Rounded corners
                  ),) ,
                )

              ],
            ),
            Expanded(
                child: FutureBuilder(

                  future: fetchProductData(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.hasData){
                      List<Map<String, dynamic>> ProductData = snapshot.data!;


                      return GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        childAspectRatio: 0.33
                        ,
                      ),

                        itemCount: ProductData.length,

                        itemBuilder: (context, index){
                          return Container(
                              width: cardWidth,
                              height: cardHeight,

                              child: InkWell(
                                onTap: () {
    // print("Card tapped!"+ ProductData[index]["product_variation_id"] );

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>
    ProdDetails(
    id: ProductData[index]["product_variation_id"],)),
    ); // QuantitySelector();`
    },
                                  child:Card(

                                    elevation: 200,

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [

                                        Stack(
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 0.5,
                                                child: ProductData[index]["images"] !=
                                                    null &&
                                                    ProductData[index]["images"]
                                                        .isNotEmpty
                                                    ? Image.network(
                                                  ProductData[index]["images"][0],
                                                  fit: BoxFit
                                                      .cover, // in rounded rectangle.
                                                )
                                                    : Center(
                                                  child: Text(
                                                    "Image not available",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              Positioned(right: 0,
                                                top: 0,

                                                child: Icon(
                                                    Icons.favorite_outline),)
                                            ]
                                        ),
                                        SizedBox(height: 10,),


                                        Container(child: Flexible(child: Text(
                                          " ${ProductData[index]["product_description"]}",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),))),
                                        SizedBox(height: 10,),

                                        Flexible(child: Text(
                                            "Discount: ${ProductData[index]["discount_percent"]}%",
                                            overflow: TextOverflow.ellipsis)),
                                        SizedBox(height: 2,),

                                        Flexible(child: Text(
                                            "Actual Price: ${ProductData[index]["price"]}",
                                            overflow: TextOverflow.ellipsis)),
                                        SizedBox(height: 2,),

                                        Flexible(child: Text(
                                            "Reduced Price: ${ProductData[index]["Reduced_price"]}",
                                            overflow: TextOverflow.ellipsis)),


                                      ],
                                    ),
    ))

                              );


                        },);

                    }
                    else{
                      return Center(child: Text("No data available"));
                    }
                  },

                )
            )]
      ),

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



