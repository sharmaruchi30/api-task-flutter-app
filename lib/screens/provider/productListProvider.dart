import 'package:flutter/foundation.dart';
import 'package:task_app/screens/utils/models.dart';


class ProductListProvider with ChangeNotifier{
  
  List<products> _productList = [];

  List<products> get productList => _productList;

  void setProductList( List<products> products  ){
    _productList = products;
    notifyListeners();
  }

}