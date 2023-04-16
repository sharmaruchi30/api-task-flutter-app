import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  String image;
  String title;
  String desc;
  ProductCard({
    Key? key,
    required this.image,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5 , right: 5),
      child: Container(
        height: 250,
        width: 150,
        decoration: BoxDecoration(
          // color: Colors.white38,
          borderRadius: BorderRadius.circular(12)
        ),

        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                // borderRadius: const BorderRadius.only(topLeft: Radius.circular(12) , topRight: Radius.circular(12)),
                child: Image.network(
                  // snapshot.data![index].thumbnail,
                  image,
                  fit: BoxFit.fill,
                  
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                // snapshot.data![index].title,
                title,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                // snapshot.data![index].title,
                desc,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    
  }
}
