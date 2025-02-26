import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main(){
//   runApp(
//     MaterialApp(
//       home: ProdDetails(id: "PV0001",), // Replace with your widget name
//     ),
//   );
// }

class QuantitySelector extends StatefulWidget {
  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Wrap(

      // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Quantity : ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Container(

          decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          // color: Colors.white,
    ),
            child: Wrap(children: [
              // Minus Button
              IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 1) quantity--;
                  });
                },
                icon: Icon(Icons.remove),
                color: Colors.black,
                splashRadius: 7,
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
              ),
              // Quantity Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Text(
                  '$quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Plus Button
              IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: Icon(Icons.add),
                color: Colors.black,
                splashRadius: 7,
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
              ),
            ]),
          )
        ]
    );
  }
}

class ProdDetails extends StatelessWidget{
   final String id ;

   ProdDetails({
    required this.id,
    Key? key,
  }) : super(key: key);

   Future<List<Map<String, dynamic>>> fetchProductVarData() async {
     // print("https://modestgallery.pythonanywhere.com/filter/${id}/");
     final response = await http.get(Uri.parse("https://modestgallery.pythonanywhere.com/filter/${id}/"));

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
       throw Exception(Text("Data not loaded properly"));
     }

   }


  @override
  Widget build(BuildContext context) {
    print(id);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth2 = MediaQuery.of(context).size.width/2;
    print(screenWidth2);


    print(screenWidth);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('My First Flutter Application' )),

      ),

        body: MediaQuery.of(context).size.width <= 850 ?
        FutureBuilder(

        future: fetchProductVarData(),
    builder: (BuildContext context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text("Error: ${snapshot.error}"));
    }
    else if (snapshot.hasData) {
      List<Map<String, dynamic>> ProdVarData = snapshot.data!;

      print(ProdVarData);


      return ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Image.network(
              ProdVarData[0]["images"][0],
            ),
          ),
          SizedBox(height: 10,),
          Text(
              "Description:  ${ProdVarData[0]["product_description"]}", softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 20,),

          Text(
            "Price: ₹${ProdVarData[0]["Reduced_price"]}/-", // Price text
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Reduced font size
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis, // Ellipsis for overflow handling
          ),

          SizedBox(height: 10), // Add spacing between text


          // ),   1/12 +1/3  +1/6 +1/3 +1/12
          QuantitySelector(),
          SizedBox(height: 25,),
          Wrap(

            children: [
              SizedBox(width: screenWidth / 12),
              ElevatedButton(
                onPressed: () => { print('Wishlist')}, child: Text("Wishlist"),

                style:
                ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 3, 50),

                  backgroundColor: Colors.white54,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // Rounded corners
                  ),),
              ),
              SizedBox(width: screenWidth / 6),
              ElevatedButton(onPressed: () => { print('Cart')},
                child: Text("Add to Cart", style: TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,),
                style:
                ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 3, 50),

                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // Rounded corners
                  ),),
              ),
              SizedBox(width: screenWidth / 12),

            ],
          ),

        ],

      );
    }
    else{
      return Center(child: Text("No data available"));
    }
         } )



            :
        FutureBuilder(

            future: fetchProductVarData(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              else if (snapshot.hasData) {
                List<Map<String, dynamic>> ProdVarData = snapshot.data!;
                print(ProdVarData);



                return ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 50, left: 100),
                          height: 700,
                          child: Image.network(
                            ProdVarData[0]["images"][0],
                            fit: BoxFit.fitHeight,
                          ),

                        ),
                        // 30 , 12 3 12 3 12
                        SizedBox(width:screenWidth2/10 ,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 50),

                            height: 700,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description:  ${ProdVarData[0]["product_description"]}",softWrap: true,  style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 30)) ,
                                SizedBox(height: 20,),
                                Text(
                                  "Price: ₹${ProdVarData[0]["reduced_price"]}/-", // Price text
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20, // Reduced font size
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ellipsis for overflow handling
                                ),
                                SizedBox(height: 10), // Add spacing between text
                                QuantitySelector(),
                                // SizedBox(height: 50,),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 50),
                                    child: Row(
                                      children: [
                                        // SizedBox(width:screenWidth2/15),
                                        Expanded(
                                          child: ElevatedButton(onPressed: ()=>{ print('Wishlist')}, child: Text("Wishlist", overflow: TextOverflow.ellipsis, ) ,
                                            style:
                                            ElevatedButton.styleFrom(
                                              fixedSize: Size(screenWidth2/3, 50),
                                              backgroundColor: Colors.white54,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                // Rounded corners
                                              ),) ,
                                          ),
                                        ) ,
                                        SizedBox(width:screenWidth/12),
                                        Expanded(
                                          child: ElevatedButton(onPressed: ()=>{ print('Cart')}, child: Text("Add to Cart" , style: TextStyle(fontSize: 10 ), overflow: TextOverflow.ellipsis,) , style:
                                          ElevatedButton.styleFrom(
                                            fixedSize: Size(screenWidth2/3, 50),

                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              // Rounded corners
                                            ),) ,
                                          ),
                                        ),
                                        SizedBox(width:screenWidth2/12),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ],
                );
              }
              else{
                return Center(child: Text("No data available"));
              }
            } )




    );
  }

}