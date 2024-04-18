import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hence_test/features/ecommerce/cubit/category_cubit.dart';
import 'package:hence_test/features/ecommerce/models/product_model.dart';
import 'package:hence_test/features/ecommerce/screens/add_category_screen.dart';
import 'package:hence_test/features/ecommerce/screens/add_product_screen.dart';
import 'package:hence_test/features/ecommerce/screens/product_by_category.dart';
import 'package:hence_test/features/ecommerce/widgets/drawer_widget.dart';
import 'package:hive/hive.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  ValueNotifier<String>selectedCategory=ValueNotifier("");
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

    
    getProduct();
  }

  saveProduct() {
    BlocProvider.of<EcommerceCubit>(context).saveProduct(
        product: Product(
            price: double.parse(priceController.text),
            description: descriptionController.text,
            name: nameController.text,
            category: selectedCategory.value));
  }

  getProduct() {
    BlocProvider.of<EcommerceCubit>(context).getAllProduct();
  }
    getCategory() {
    BlocProvider.of<EcommerceCubit>(context).getAllCategory();
  }

  deleteProduct({required int productIndex}) {
    BlocProvider.of<EcommerceCubit>(context)
        .deleteProduct(productIndex: productIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
            onPressed: () {
              saveProduct();
            },
            child: Text("Add Product")),
      ),
      body: BlocConsumer<EcommerceCubit, EcommerceState>(
        listener: (context, state) {
          if (state is ProductSavedState) {
            getProduct();
          } else if (state is ProductLoadedState) {
            productList = state.productList;

            nameController.clear();
            priceController.clear();

            descriptionController.clear();
          }
          else if(state is CategoryLoadedState){
            categoryList=state.categoryList;
            if(categoryList.isNotEmpty){

    selectedCategory.value=categoryList[0];
            }

            else{
              categoryList=["Without Category"];
              selectedCategory.value=categoryList[0];
            }

          }
          
           else if (state is ProductDeletedState) {
            getProduct();
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
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Product name")),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Product price")),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    maxLines: 4,
                    controller: descriptionController,

                  
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Product Description")),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  ValueListenableBuilder(valueListenable: selectedCategory, builder:(context, value, child) {
                    return DropdownButton(
                      isExpanded: true,
                      value: selectedCategory.value,
                      
                      items: categoryList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e));
                    }).toList(), onChanged: (value){
                      selectedCategory.value=value.toString();
                    });
                  },),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text(productList[index].price.toString()),
                                trailing:
                                    Text(productList[index].category.toString()),
                                title: Text(productList[index].name),
                                subtitle: Text(productList[index].description),
                              ),

                              IconButton(onPressed: (){

                                deleteProduct(productIndex: index);
                              }, icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
