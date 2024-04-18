
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hence_test/features/ecommerce/models/product_model.dart';
import 'package:hence_test/features/ecommerce/repository/category_repository.dart';
import 'package:hence_test/features/ecommerce/repository/product_repository.dart';

abstract class EcommerceState {}

class EcommerceInitState extends EcommerceState {}

class EcommerceLoadingState extends EcommerceState {}

class CategorySavedState extends EcommerceState {}

class ProductSavedState extends EcommerceState {}

class CategoryLoadedState extends EcommerceState {
  final List categoryList;

  CategoryLoadedState({required this.categoryList});
}
class ProductLenghtLoadedState extends EcommerceState {
  final int product_length;

  ProductLenghtLoadedState({required this.product_length});
}

class ProductLoadedState extends EcommerceState {
  final List<Product> productList;

  ProductLoadedState({required this.productList});
}

class CategoryDeletedState extends EcommerceState {}

class ProductDeletedState extends EcommerceState {}

class EcommerceErrorState extends EcommerceState {}
// class ProductInitState extends ProductState{

// }

class EcommerceCubit extends Cubit<EcommerceState> {
  CategoryRepository _categoryRepository = CategoryRepository();

  ProductRepository _productRepository = ProductRepository();
  EcommerceCubit() : super(EcommerceInitState());

  saveCategory({required String categoryName}) async {
    emit(EcommerceLoadingState());
    await _categoryRepository
        .saveCategory(categoryName: categoryName.toUpperCase())
        .then((value) {
      emit(CategorySavedState());
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }

  getAllCategory() async {
    emit(EcommerceLoadingState());
    await _categoryRepository.getCategory().then((value) {
      emit(CategoryLoadedState(categoryList: value));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }

  getProductLength() async {
    emit(EcommerceLoadingState());
    await _productRepository.getProductLength().then((value) {
      emit(ProductLenghtLoadedState(product_length: value));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }
    getProductByPagination({required int first_element,required int total_element}) async {
    emit(EcommerceLoadingState());
    await _productRepository.getProductByRange(first_element:first_element,total_element:total_element  )  .then((value) {
         List<Product> productList = [];
      value.forEach((element) {
        productList.add(Product(
            price: element["price"],
            description: element["description"],
            name: element["name"],
            category: element["category"]));
      });
      emit(ProductLoadedState(productList: productList));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }
  deleteCategory({required int categoryIndex}) async {
    emit(EcommerceLoadingState());
    await _categoryRepository
        .deleteCategory(categoryindex: categoryIndex)
        .then((value) {
      emit(CategoryDeletedState());
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }

  deleteAllCategory() async {
    emit(EcommerceLoadingState());
    await _categoryRepository.deleteAllCategory().then((value) {
      emit(CategoryLoadedState(categoryList: value));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }

  saveProduct({required Product product}) async {
    emit(EcommerceLoadingState());
    await _productRepository
        .saveProduct(product: product.toJson())
        .then((value) {
      emit(ProductSavedState());
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }
  getProductByCategory({required String categoryName }) async {
    emit(EcommerceLoadingState());
    await _productRepository.getProductByCategory(categoryName: categoryName).then((value) {
      List<Product> productList = [];
      value.forEach((element) {
        productList.add(Product(
            price: element["price"],
            description: element["description"],
            name: element["name"],
            category: element["category"]));
      });

      emit(ProductLoadedState(productList: productList));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }
  getAllProduct() async {
    emit(EcommerceLoadingState());
    await _productRepository.getProduct().then((value) {
      List<Product> productList = [];
      value.forEach((element) {
        productList.add(Product(
            price: element["price"],
            description: element["description"],
            name: element["name"],
            category: element["category"]));
      });

      emit(ProductLoadedState(productList: productList));
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }

  deleteProduct({required int productIndex}) async {
    emit(EcommerceLoadingState());
    await _productRepository
        .deleteProduct(productIndex: productIndex)
        .then((value) {
      emit(ProductDeletedState());
    }).onError((error, stackTrace) {
      emit(EcommerceErrorState());
    });
  }
}
