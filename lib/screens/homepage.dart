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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // provider object
    final productListProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    verticalScrollController.addListener(() {
      if (verticalScrollController.position.maxScrollExtent ==
          verticalScrollController.offset) {

        // checking index range since the api contains only 30 items
        if (productListProvider.endproductLoadIndex < 30) {
          // fetching 5 more products while scroll reaches the end of the screen
          productListProvider
              .setStartIndex(productListProvider.endproductLoadIndex);
          productListProvider
              .setEndIndex(productListProvider.endproductLoadIndex + 5);
        } else {
          // resetting values if index reached the limit
          productListProvider.setDataLimit(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("build test");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 28, 28),
        title: Text(
          "Products",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          fetchDataFromList(),
        ],
      ),
    );
  }

  Widget fetchDataFromList() {
    // provider object
    return Consumer<ProductListProvider>(
        builder: ((context, value, child) => FutureBuilder(
              future: value.setProducts(
                  value.startproductLoadIndex, value.endproductLoadIndex),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> categories = ["Popular"];
                  // getting all the categories available in the data retrieved.
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
                      itemCount: categories.length + 1,
                      itemBuilder: (context, indexi) {
                        if (indexi < categories.length) {
                          // using consumer widget for provider
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      categories[indexi],
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SeeAll(
                                                    category:
                                                        categories[indexi],
                                                    productList: snapshot.data!,
                                                  ))),
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
                                              // dividing section according to the categories.
                                              if (categories[indexi] ==
                                                  snapshot
                                                      .data![indexj].category) {
                                                return ProductCard(
                                                    image: snapshot
                                                        .data![indexj]
                                                        .thumbnail,
                                                    title: snapshot
                                                        .data![indexj].title,
                                                    desc: snapshot
                                                        .data![indexj].desc);
                                              } else if (categories[indexi] ==
                                                  "Popular") {
                                                return ProductCard(
                                                    image: snapshot
                                                        .data![indexj]
                                                        .thumbnail,
                                                    title: snapshot
                                                        .data![indexj].title,
                                                    desc: snapshot
                                                        .data![indexj].desc);
                                              } else {
                                                return const SizedBox();
                                              }
                                            })),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              value.dataLimit
                                  ? Padding(
                                    padding: const EdgeInsets.only( bottom: 20.0),
                                    child: Text(
                                        "No More data to load.",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                  )
                                  : const SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                            ],
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            )));
  }
}
