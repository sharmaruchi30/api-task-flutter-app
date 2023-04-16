import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_app/screens/provider/productListProvider.dart';
import 'package:task_app/screens/seeallpage.dart';
import 'package:task_app/screens/utils/models.dart';
import 'package:task_app/screens/utils/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController verticalScrollController = ScrollController();
  int startproductLoadIndex =0;
  int endproductLoadIndex =10;
  bool dataLimit= false;
  List<products> productList = [];

  Future<List<products>> getProducts(int start , int end) async {
    var response = await Dio().get("https://dummyjson.com/products");
    // var data = jsonDecode(response.data['products'].toString());
    // print(data);
    // print(response.data['products'][2]['title']);
    for (int i = start; i < end; i++) {
      List<String> imgs = [];
      for (int j = 0; j < response.data['products'][i]['images'].length; j++) {
        imgs.add(response.data['products'][i]['images'][j]);
      }
      products product = products(
          id: response.data['products'][i]['id'],
          title: response.data['products'][i]['title'],
          desc: response.data['products'][i]['description'],
          price: response.data['products'][i]['price'],
          brand: response.data['products'][i]['brand'],
          category: response.data['products'][i]['category'],
          thumbnail: response.data['products'][i]['thumbnail'],
          images: imgs);

      productList.add(product);
    }
    return productList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verticalScrollController.addListener(() {
      if (verticalScrollController.position.maxScrollExtent == verticalScrollController.offset){
        // checking index range since the api contains only 30 items 
        if (endproductLoadIndex < 30){
          // fetching 5 more products while scroll reaches the end of the screen
          startproductLoadIndex = endproductLoadIndex;
          endproductLoadIndex = endproductLoadIndex + 5;
          setState(() {
            
          });
        }
        else{
          // resetting values if index reached the limit 
          dataLimit = true;
          setState(() {
            
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 28, 28),
        title: Text(
          "Products ",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            fetchDataFromList(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<products>> fetchDataFromList() {
    return FutureBuilder(
            future: getProducts(startproductLoadIndex, endproductLoadIndex),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> categories = ["Popular"];
                for (int i = 0; i < snapshot.data!.length; i++) {
                  if (categories.contains(snapshot.data![i].category) ==
                      false) {
                    categories.add(snapshot.data![i].category);
                  }
                }
                return Expanded(
                  //Vertical Scroll ListView for category distribution
                  child: ListView.builder(
                    controller: verticalScrollController,
                    itemCount: categories.length +1,
                    itemBuilder: (context, indexi) {
                      if(indexi < categories.length){

                        // using consumer widget for provider
                        return Consumer(
                          builder: ((context, value, child) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categories[indexi],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SeeAll(category: categories[indexi], productList:  snapshot.data!,))),
                               
                                child: Text(
                                  "See All >",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                Expanded(
                                  // Horizontal Scroll ListView
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: ((context, indexj) {
                                        if (categories[indexi] == snapshot.data![indexj].category){
                                            return ProductCard(
                                            image: snapshot
                                                .data![indexj].thumbnail,
                                            title:
                                                snapshot.data![indexj].title,
                                            desc:
                                                snapshot.data![indexj].desc);
                                        }
                                        else if(categories[indexi] == "Popular" ){
                                          return ProductCard(
                                            image: snapshot
                                                .data![indexj].thumbnail,
                                            title:
                                                snapshot.data![indexj].title,
                                            desc:
                                                snapshot.data![indexj].desc);
                                        }
                                        else{
                                          return const SizedBox();
                                        }
                                      })),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40,)
                        ],
                      )) 
                        
                        );
                      }
                      else{
                        return Column(
                          children: [
                            dataLimit ? Text("No More data to load.",
                            style: GoogleFonts.poppins(
                              color: Colors.white
                            ),
                            ) :
                            
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(color: Colors.white,))
                          ],
                        );
                      }
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            },
          );
  }
}
