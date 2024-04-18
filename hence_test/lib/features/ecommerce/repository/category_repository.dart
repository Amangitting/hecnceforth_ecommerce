import 'package:hence_test/features/ecommerce/utils/utils.dart';

class CategoryRepository {
  Future saveCategory({required String categoryName}) async {
    await categoryBox.add(categoryName);
  }


  Future<List> getCategory() async {
    return await categoryBox.values.toList();
  }
  
  Future deleteCategory({required int categoryindex}) async {
    return await categoryBox.deleteAt(categoryindex);
  }
    Future deleteAllCategory() async {
    return await categoryBox.clear();
  }
}

