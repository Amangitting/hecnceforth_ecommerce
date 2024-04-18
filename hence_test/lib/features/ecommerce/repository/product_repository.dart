import 'dart:math';

import 'package:hence_test/features/ecommerce/utils/utils.dart';

class ProductRepository {

    Future saveProduct({required Map product}) async {
    await productBox.add(product);
  }

  Future<List> getProduct() async {
    return await productBox.values.toList();
  }
  Future<List> getProductByCategory({required String categoryName}) async {
    return await productBox.values.where((element) => element["category"]==categoryName).toList();
  }
   Future<int> getProductLength() async {
    return await productBox.length;
  }
   Future<List> getProductByRange({required int first_element, required total_element}) async {
    return await productBox.values.skip(first_element).take(total_element).toList();
  }
  
  Future deleteProduct({required int productIndex}) async {
    return await productBox.deleteAt(productIndex);
  }
    Future deleteAllProduct() async {
    return await productBox.clear();
  }
}