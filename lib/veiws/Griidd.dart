
import 'package:first_project/veiws/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(ProdStf());
}

class ProdStf extends StatefulWidget {
  const ProdStf({super.key});



  @override
  State<ProdStf> createState() => _ProdStfState();
}

class _ProdStfState extends State<ProdStf> {

  @override
  void initState() {
    super.initState();
    // Fetch product data and store it in the Future
    var _productDataFuture = fetchProductData();
  }

  Future<List<Map<String, dynamic>>> fetchProductData() async {
    final response = await http.get(Uri.parse("https://b0g6wnld-8000.inc1.devtunnels.ms/custom/"));

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
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2.5; // Divide screen into 2.5 cards
    double cardHeight = cardWidth * 1.5;
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('My First Flutter Application' )),
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
                          maxCrossAxisExtent: 200, // Maximum width for each card
                          mainAxisSpacing: 10,    // Vertical spacing between cards
                          crossAxisSpacing: 10,   // Horizontal spacing between cards
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
                                  ); // QuantitySelector();

                                  child:
                                  Card(

                                    elevation: 200,

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      // Aligns child widgets to the left
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
                                                      .cover, // Ensures the image fills the rounded rectangle.
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
                                  );
                                }
                              ));


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



// class MyGrids extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: "These are Grid's items",
//       debugShowCheckedModeBanner: false,
//       home: MyPage(),
//     );
//   }
//
//
// }
// class MyPage extends StatelessWidget {
//
//   Future<List<Map<String, dynamic>>> fetchProductData() async {
//     final response = await http.get(Uri.parse("https://b0g6wnld-8000.inc1.devtunnels.ms/custom/"));
//
//     if (response.statusCode==200) {
//       // final data = json.decode(response.body);
//       List<dynamic> data = json.decode(response.body);
//
//       return data.map((e) =>
//       ({
//         "product_id": e["product_id"],
//         "category_name": e["category_name"],
//         "sub_category_name": e["sub_category_name"],
//         "product_description": e["product_description"],
//         "availability": e["availability"],
//         "price": e["price"],
//         "stock": e["stock"],
//         "product_variation_id": e["product_variation_id"],
//         "variation_type": e["variation_type"],
//         "variation_name": e["variation_name"],
//         "discount_percent": e["discount_percent"],
//         "discount_price": e["discount_price"],
//         "reduced_price": e["Reduced_price"],
//         "color_code": e["ColorCode"],
//         "images": e["images"],
//       })).toList();
//     }
//     else{
//       throw Exception(Text("Data not loaded properly"));
//     }
//
//
//   }
//
//
//   List<String>  arr2 = [
//     "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
//     "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
//     "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
//     "https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg" ,
//     "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
//     "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
//     "https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg",
//
//
//   ];
//   List<String> names=["THis iss name 11 of ss jss ddd dd wqa ak " , "THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss" ];
//   List<double> nums=[100, 200,300,400 , 200,300,400];
//   List<int> price=[2222,3344,4433,2222,3344,4433,2222];
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double cardWidth = screenWidth / 2.5; // Divide screen into 2.5 cards
//     double cardHeight = cardWidth * 1.5; // Maintain aspect ratio (e.g., 1.5)
//
//
//     return   Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('My First Flutter Application' )),
//         elevation: 20,
//         actions: [
//           Icon(Icons.favorite),
//           Icon(Icons.notifications),
//           // Adds space at the end
//         ],
//
//       ) ,
//       body:  Column(
//           children: [
//             SearchBar(),
//             Wrap(
//
//               children: [
//                 ElevatedButton(onPressed: ()=>{ print('filter')}, child: Text("Filter") ,
//
//                   style:
//                   ElevatedButton.styleFrom(
//                     fixedSize: Size(screenWidth/2, 50),
//
//                     // backgroundColor: Colors.blue,
//                     // foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                       // Rounded corners
//                     ),) ,
//                 ) ,
//                 ElevatedButton(onPressed: ()=>{ print('Sort')}, child: Text("Sort") , style:
//                 ElevatedButton.styleFrom(
//                   fixedSize: Size(screenWidth/2, 50),
//
//                   // backgroundColor: Colors.blue,
//                   // foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                     // Rounded corners
//                   ),) ,
//                 )
//
//               ],
//             ),
//             Expanded(
//                 child: FutureBuilder(
//
//                   future: fetchProductData(),
//                   builder: (BuildContext context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text("Error: ${snapshot.error}"));
//                     }
//                     if (snapshot.hasData){
//                       List<Map<String, dynamic>> ProductData = snapshot.data!;
//
//
//                       return GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                           maxCrossAxisExtent: 200, // Maximum width for each card
//                           mainAxisSpacing: 10,    // Vertical spacing between cards
//                           crossAxisSpacing: 10,   // Horizontal spacing between cards
//                           childAspectRatio: 2 / 3
//
//                       ),
//
//                         itemCount: ProductData.length,
//
//                         itemBuilder: (context, index){
//                           return Container(
//                               width: cardWidth,
//                               height: cardHeight,
//
//                               child: Card(
//
//                                 elevation: 200,
//
//                                 child: Padding(
//
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       // Aligns child widgets to the left
//
//                                       // mainAxisSize: MainAxisSize.min,
//                                       children: [
//
//                                         Stack(
//                                             children: [
//                                               AspectRatio(
//                                                 aspectRatio: 1.5,
//                                                 child: ProductData[index]["images"] != null &&
//                                                     ProductData[index]["images"].isNotEmpty
//                                                     ? Image.network(
//                                                   ProductData[index]["images"][0],
//                                                   fit: BoxFit.cover, // Ensures the image fills the rounded rectangle.
//                                                 )
//                                                     : Center(
//                                                   child: Text(
//                                                     "Image not available",
//                                                     style: TextStyle(
//                                                       color: Colors.grey,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//
//
//                                               Positioned( right: 0,
//                                                 top:0,
//
//                                                 child: Icon(Icons.favorite_outline ) ,)
//                                             ]
//                                         ) ,
//                                         SizedBox(height: 10,),
//
//
//                                         Text(" ${ProductData[index]["product_description"]}" ,softWrap: true, style: TextStyle(fontWeight: FontWeight.bold ), ),
//                                         SizedBox(height: 3,),
//
//                                         Text("Discount: ${ProductData[index]["discount_percent"]}%",  overflow: TextOverflow.ellipsis)   ,
//                                         SizedBox(height: 3,),
//
//                                         Text("Actual Price: ${ProductData[index]["price"]}", overflow: TextOverflow.ellipsis) ,
//                                         SizedBox(height: 3,),
//
//                                         Text("Reduced Price: ${ProductData[index]["Reduced_price"]}", overflow: TextOverflow.ellipsis) ,
//
//
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ));
//
//
//                         },);
//
//                     }
//                     else{
//                       return Center(child: Text("No data available"));
//                     }
//                   },
//
//                 )
//             )]
//       ),
//
//     );
//   }
//
// }

// class MyPage extends StatelessWidget {
//
//   Future<List<Map<String, dynamic>>> fetchProductData() async {
//     final response = await http.get(Uri.parse("https://b0g6wnld-8000.inc1.devtunnels.ms/custom/"));
//
//     if (response.statusCode==200) {
//       // final data = json.decode(response.body);
//       List<dynamic> data = json.decode(response.body);
//
//       return data.map((e) =>
//       ({
//         "product_id": e["product_id"],
//         "category_name": e["category_name"],
//         "sub_category_name": e["sub_category_name"],
//         "product_description": e["product_description"],
//         "availability": e["availability"],
//         "price": e["price"],
//         "stock": e["stock"],
//         "product_variation_id": e["product_variation_id"],
//         "variation_type": e["variation_type"],
//         "variation_name": e["variation_name"],
//         "discount_percent": e["discount_percent"],
//         "discount_price": e["discount_price"],
//         "reduced_price": e["Reduced_price"],
//         "color_code": e["ColorCode"],
//         "images": e["images"],
//       })).toList();
//     }
//     else{
//       throw Exception(Text("Data not loaded properly"));
//     }
//
//
//     }
//
//
//    List<String>  arr2 = [
//    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
//    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
//    "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
//    "https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg" ,
//      "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
//      "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
//      "https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg",
//
//
//    ];
//    List<String> names=["THis iss name 11 of ss jss ddd dd wqa ak " , "THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss","THis iss name 11 of ss jss" ];
//     List<double> nums=[100, 200,300,400 , 200,300,400];
//     List<int> price=[2222,3344,4433,2222,3344,4433,2222];
//
//    @override
//   Widget build(BuildContext context) {
//      double screenWidth = MediaQuery.of(context).size.width;
//      double cardWidth = screenWidth / 2.5; // Divide screen into 2.5 cards
//      double cardHeight = cardWidth * 1.5; // Maintain aspect ratio (e.g., 1.5)
//
//
//      return   Scaffold(
//        appBar: AppBar(
//          title: Center(child: const Text('My First Flutter Application' )),
//          elevation: 20,
//          actions: [
//            Icon(Icons.favorite),
//            Icon(Icons.notifications),
//            // Adds space at the end
//          ],
//
//          ) ,
//        body:  Column(
//            children: [
//              SearchBar(),
//              Wrap(
//
//                children: [
//                  ElevatedButton(onPressed: ()=>{ print('filter')}, child: Text("Filter") ,
//
//                    style:
//                  ElevatedButton.styleFrom(
//                    fixedSize: Size(screenWidth/2, 50),
//
//                    // backgroundColor: Colors.blue,
//                    // foregroundColor: Colors.white,
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(100),
//                      // Rounded corners
//                    ),) ,
//                  ) ,
//                  ElevatedButton(onPressed: ()=>{ print('Sort')}, child: Text("Sort") , style:
//               ElevatedButton.styleFrom(
//               fixedSize: Size(screenWidth/2, 50),
//
//               // backgroundColor: Colors.blue,
//               // foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(100),
//               // Rounded corners
//               ),) ,
//               )
//
//                ],
//              ),
//        Expanded(
// child: FutureBuilder(
//
//   future: fetchProductData(),
//   builder: (BuildContext context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(child: CircularProgressIndicator());
//     } else if (snapshot.hasError) {
//       return Center(child: Text("Error: ${snapshot.error}"));
//     }
//     if (snapshot.hasData){
//       List<Map<String, dynamic>> ProductData = snapshot.data!;
//
//
//       return GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//           maxCrossAxisExtent: 200, // Maximum width for each card
//           mainAxisSpacing: 10,    // Vertical spacing between cards
//           crossAxisSpacing: 10,   // Horizontal spacing between cards
//           childAspectRatio: 2 / 3
//
//       ),
//
//         itemCount: ProductData.length,
//
//         itemBuilder: (context, index){
//           return Container(
//               width: cardWidth,
//               height: cardHeight,
//
//               child: Card(
//
//                 elevation: 200,
//
//                 child: Padding(
//
//                   padding: const EdgeInsets.all(8.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       // Aligns child widgets to the left
//
//                       // mainAxisSize: MainAxisSize.min,
//                       children: [
//
//                         Stack(
//                           children: [
//                             AspectRatio(
//                               aspectRatio: 1.5,
//                               child: ProductData[index]["images"] != null &&
//                                   ProductData[index]["images"].isNotEmpty
//                                   ? Image.network(
//                                 ProductData[index]["images"][0],
//                                 fit: BoxFit.cover, // Ensures the image fills the rounded rectangle.
//                               )
//                                   : Center(
//                                 child: Text(
//                                   "Image not available",
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//
//                               Positioned( right: 0,
//                                 top:0,
//
//                                 child: Icon(Icons.favorite_outline ) ,)
//                             ]
//                         ) ,
//                         SizedBox(height: 10,),
//
//
//                         Text(" ${ProductData[index]["product_description"]}" ,softWrap: true, style: TextStyle(fontWeight: FontWeight.bold ), ),
//                         SizedBox(height: 3,),
//
//                         Text("Discount: ${ProductData[index]["discount_percent"]}%",  overflow: TextOverflow.ellipsis)   ,
//                         SizedBox(height: 3,),
//
//                         Text("Actual Price: ${ProductData[index]["price"]}", overflow: TextOverflow.ellipsis) ,
//                         SizedBox(height: 3,),
//
//                         Text("Reduced Price: ${ProductData[index]["Reduced_price"]}", overflow: TextOverflow.ellipsis) ,
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ));
//
//
//         },);
//
//     }
//     else{
//       return Center(child: Text("No data available"));
//     }
//   },
//
// )
//        )]
//        ),
//
//      );
//    }
//
// }
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

class MyBottomBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (newContext) {
        return Container(
          // color: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: ()=>{
                Navigator.pushReplacementNamed(context, "/home")
              }, icon: Icon(Icons.home ) ,   )  ,
              IconButton(onPressed: ()=>{
                Navigator.pushReplacementNamed(context, "/account")


              }, icon: Icon(Icons.person)) ,
              IconButton(onPressed: ()=>{
                Navigator.pushReplacementNamed(context, "/products")

              }, icon: Icon(Icons.shop) ,color: Colors.red,) ,


            ],
          ),
        );
      }
    );
  }


}


// Scaffold(
// appBar: AppBar(
// title: Center(child: const Text('My First Flutter Grid Application' )),
// actions: [
// Icon(Icons.favorite_outline),
//
// Icon(Icons.notifications_outlined),
// ],
// ) ,
//
// body: Column(
// children: [Container(
// padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black38,
// // width:
// )),
// margin:EdgeInsets.fromLTRB(100, 10, 50, 10) ,
// width: double.infinity,
// child: TextField(
// decoration: InputDecoration(
// hintText: 'Search forrrrr',
//
// ))),
// // Wrap(spacing: 20,
//   children: [ElevatedButton( onPressed: () { print("filter is pressed"); },style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.red,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),),
// child: Text("Filter")),
// ElevatedButton( onPressed: () { print("filter is pressed"); },
//     child: Text("Filter"))

// ],),
// Expanded(
// child: GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
// maxCrossAxisExtent: 200, // Maximum width for each card
// mainAxisSpacing: 10,    // Vertical spacing between cards
// crossAxisSpacing: 10,   // Horizontal spacing between cards
// childAspectRatio: 2 / 3
//
// ),
//
// itemCount: arr2.length,
//
// itemBuilder: (context, index){
// return Container(
// width: cardWidth,
// height: cardHeight,
//
// child: Card(

// elevation: 100,
//
// child: Padding(
// padding: EdgeInsets.all(15),
// child: Column(
//
// // mainAxisSize: MainAxisSize.min,
// children: [
//
// Stack(
// children: [AspectRatio(
// aspectRatio: 1.5,
// child: Image.network(
// arr2[index],
//
// fit: BoxFit.cover, // Ensures the image fills the rounded rectangle.
// ),
// ) ,



// Positioned(  right: 0,
// top:0,
//
// child: Icon(Icons.favorite_outline ) ,)
// ]
// ) ,
// // Text(names[index]),
//
// Text(names[index], maxLines: 2, // Limit to 2 lines
// overflow: TextOverflow.ellipsis),
// Container(alignment: Alignment.centerLeft,  child: Text("numbers: ${nums[index]}", textAlign: TextAlign.start, overflow: TextOverflow.ellipsis)) ,
// Container(alignment: Alignment.centerLeft, child: Text("Actualllll number: ${price[index]}" ,  overflow: TextOverflow.ellipsis,)),
// Container(alignment: Alignment.centerLeft, child: Text("Actualllll number: ${price[index]}" ,  overflow: TextOverflow.ellipsis,)),

//      FittedBox( child: Text("Actualllll number: ${price[index]}")),



//
// ],),
// ),
// ),
// );
// }))
//
//
// ] ,));

// Scaffold(
// appBar: AppBar(
// title: Center(child: const Text('My First Flutter Grid Application' )),
// actions: [
// Icon(Icons.favorite_outline),
//
// Icon(Icons.notifications_outlined),
// ],
// ) ,
//
// body: Column(
// children: [Container(
// padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
// decoration: BoxDecoration(
// border: Border.all(
// color: Colors.black38,
// // width:
// )),
// margin:EdgeInsets.fromLTRB(100, 10, 50, 10) ,
// width: double.infinity,
// child: TextField(
// decoration: InputDecoration(
// hintText: 'Search forrrrr',
//
// )
//
// ),
// ),
// Expanded(
// child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemCount: arr2.length,itemBuilder: (context, index){
// return Container( decoration: BoxDecoration(border: Border.all(
// color: Colors.black , width: 1.0
// )),
// padding: EdgeInsets.only(left: 25 , top: 10, right: 10,bottom: 10),
// margin: EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 10),
//
// child: Column(  crossAxisAlignment: CrossAxisAlignment.start, children:[  Stack(
// children: [Container(
// child:Image.network(arr2[index] ,
//
// //     width: MediaQuery.of(context).size.width,
// // height: MediaQuery.of(context).size.height,
// //     fit: BoxFit.cover
// ) ),
// Positioned(  left: 600,
// top:0,
//
// child: Icon(Icons.favorite_outline,  size:100) ,)
// ]
// ) ,
// Expanded(child: Container(child: Text(names[index],style: TextStyle(fontSize: 35),), )) ,
// Expanded(
// child: Container( child: Text("numbers: ${nums[index]}", style: TextStyle(fontSize: 35),),
//
// ),
// ),
//
// Expanded(
// child: Container( child: Text("Actualllll number: ${price[index]}", style: TextStyle(fontSize: 35),),
// ),
// ),
// Expanded(
// child: Container( child: Text("Actualllll number: ${price[index]}", style: TextStyle(fontSize: 35),),
// ),
// )
// ]),
// );
// }
// ),
// )
// ]
// ),
//
// );