import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hence_test/features/ecommerce/cubit/category_cubit.dart';
import 'package:hence_test/features/ecommerce/models/product_model.dart';
import 'package:hence_test/features/ecommerce/screens/add_category_screen.dart';
import 'package:hence_test/features/ecommerce/screens/add_product_screen.dart';
import 'package:hence_test/features/ecommerce/screens/product_by_category.dart';
import 'package:hence_test/features/ecommerce/widgets/drawer_widget.dart';
import 'package:hive/hive.dart';

class ProductByCategory extends StatefulWidget {
  const ProductByCategory({super.key});

  @override
  State<ProductByCategory> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  ValueNotifier<String> selectedCategory = ValueNotifier("");
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  final descriptionController = TextEditingController();

  List<Product> productList = [];
  List categoryList = ["No category"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    getCategory();

  }

  saveProduct() {
    BlocProvider.of<EcommerceCubit>(context).saveProduct(
        product: Product(
            price: double.parse(priceController.text),
            description: descriptionController.text,
            name: nameController.text,
            category: selectedCategory.value));
  }

  getProductByCategory({required String categoryName}) {
    BlocProvider.of<EcommerceCubit>(context).getProductByCategory(categoryName: categoryName);
  }

  getCategory() {
    BlocProvider.of<EcommerceCubit>(context).getAllCategory();
  }

  deleteProduct({required int productIndex}) {
    BlocProvider.of<EcommerceCubit>(context)
        .deleteCategory(categoryIndex: productIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:DrawerWidget(),
      appBar: AppBar(
        title: Text('Product by category'),
      ),

      body: BlocConsumer<EcommerceCubit, EcommerceState>(
        listener: (context, state) {
    if (state is ProductLoadedState) {
            productList = state.productList;

            nameController.clear();
            priceController.clear();

            descriptionController.clear();
          } else if (state is CategoryLoadedState) {
            categoryList = state.categoryList;
            if(categoryList.isNotEmpty){

            selectedCategory.value = categoryList[0];
            }
          } 
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is EcommerceLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: selectedCategory,
                builder: (context, value, child) {

                  if(categoryList.isEmpty){
                    return Text("Please add category first");
                  }
          
                  return
                   Column(
                    children: [
                      DropdownButton(
                          isExpanded: true,
                          value: selectedCategory.value,
                          items: categoryList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            selectedCategory.value = value.toString();
                            getProductByCategory(categoryName: selectedCategory.value);
                      
                            // selectedCategory.notifyListeners()
                          }),
                          productList.isEmpty?Text("No product found"):
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Text(
                                    productList [index].price.toString()),
                                trailing: Text(
                                    productList[index].category.toString()),
                                title: Text(productList[index].name),
                                subtitle:
                                    Text(productList[index].description),
                              ),
                            );
                          })
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
