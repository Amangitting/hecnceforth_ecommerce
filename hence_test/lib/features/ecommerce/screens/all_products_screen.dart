import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
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

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<Product> productList = [];
  int product_list_length = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    getProductListLenth();

    getProductByPagination(first_element: 0, total_element: 10);
  }

  getProductByPagination(
      {required int first_element, required int total_element}) {
    BlocProvider.of<EcommerceCubit>(context).getProductByPagination(
        first_element: first_element, total_element: total_element);
  }

  getProductListLenth() {
    BlocProvider.of<EcommerceCubit>(context).getProductLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('All products'),
      ),
      body: BlocConsumer<EcommerceCubit, EcommerceState>(
        listener: (context, state) {
          if (state is ProductLoadedState) {
            productList = state.productList;
          } else if (state is ProductLenghtLoadedState) {
            product_list_length = state.product_length;
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
            child: productList.isEmpty
                ? Text("No product found")
                : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 60),
                          shrinkWrap: true,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Text(productList[index]
                                    .price
                                    .toString()),
                                trailing: Text(productList[index]
                                    .category
                                    .toString()),
                                title: Text(productList[index].name),
                                subtitle: Text(
                                    productList[index].description),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Spacer()
,                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (product_list_length / 10).ceil(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              color: Colors.amber,
                              onPressed: () {
                                if (index != 0) {
                                  getProductByPagination(
                                      first_element: index * 10,
                                      total_element: 10);
                                } else {
                                  getProductByPagination(
                                      first_element: 0,
                                      total_element: 10);
                                }
                              },
                              child: Text((index + 1).toString()),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
          );
        },
      ),
    );
  }
}
