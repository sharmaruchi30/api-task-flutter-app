import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_app/screens/utils/models.dart';
import 'package:task_app/screens/utils/product_card.dart';

class SeeAll extends StatelessWidget {
  String category;
  List<products> productList;
  SeeAll({
    Key? key,
    required this.category,
    required this.productList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<products> CatProducts = [];
    if (category == "Popular") {
      CatProducts = productList;
    } else {
      for (int i = 0; i < productList.length; i++) {
        if (productList[i].category == category) {
          CatProducts.add(productList[i]);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 28, 28),
        title: Text(
          category,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3 / 2,
              // crossAxisSpacing: 20,
              mainAxisSpacing: 20
            ),
            itemCount: CatProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                  image: CatProducts[index].thumbnail,
                  title: CatProducts[index].title,
                  desc: CatProducts[index].desc);
            }),
      ),
    );
  }
}
