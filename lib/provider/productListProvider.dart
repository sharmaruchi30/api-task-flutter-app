import 'package:flutter/foundation.dart';
import 'package:task_app/screens/utils/models.dart';
import 'package:dio/dio.dart';

class ProductListProvider with ChangeNotifier {
  List<Products> _productList = [];
  int _startproductLoadIndex = 0;
  int _endproductLoadIndex = 10;
  bool _dataLimit = false;

  List<Products> get productList => _productList;
  int get startproductLoadIndex => _startproductLoadIndex;
  int get endproductLoadIndex => _endproductLoadIndex;
  bool get dataLimit => _dataLimit;
  
  Future<List<Products>> setProducts(int start, int end) async {
    var response = await Dio().get("https://dummyjson.com/products");
    // var data = jsonDecode(response.data['products'].toString());
    // print(data);
    // print(response.data['products'][2]['title']);
    for (int i = start; i < end; i++) {
      List<String> imgs = [];
      for (int j = 0; j < response.data['products'][i]['images'].length; j++) {
        imgs.add(response.data['products'][i]['images'][j]);
      }
      Products product = Products(
          id: response.data['products'][i]['id'],
          title: response.data['products'][i]['title'],
          desc: response.data['products'][i]['description'],
          price: response.data['products'][i]['price'],
          brand: response.data['products'][i]['brand'],
          category: response.data['products'][i]['category'],
          thumbnail: response.data['products'][i]['thumbnail'],
          images: imgs);

      _productList.add(product);
    }
    return _productList;
  }

  void setStartIndex(int index){
    _startproductLoadIndex = index;
    notifyListeners();
  }
  
  void setEndIndex(int index){
    _endproductLoadIndex = index;
    notifyListeners();
  }

  void setDataLimit(bool value){
    _dataLimit = value;
    notifyListeners();
  }
}
