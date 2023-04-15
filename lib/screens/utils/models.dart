import 'package:flutter/foundation.dart';

class products{
  int id;
  String title;
  String desc;
  int price;
  String brand;
  String category;
  String thumbnail;
  List<String> images;
  products({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });
  
}