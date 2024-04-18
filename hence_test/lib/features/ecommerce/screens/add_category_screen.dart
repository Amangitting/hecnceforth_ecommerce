import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hence_test/features/ecommerce/cubit/category_cubit.dart';
import 'package:hence_test/features/ecommerce/screens/add_product_screen.dart';
import 'package:hence_test/features/ecommerce/screens/product_by_category.dart';
import 'package:hence_test/features/ecommerce/widgets/drawer_widget.dart';
import 'package:hive/hive.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final CategoryController = TextEditingController();
  List categoryList = [];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    getCategoryNames();
  }


  saveCategoryName() {
    BlocProvider.of<EcommerceCubit>(context)
        .saveCategory(categoryName: CategoryController.text);
  }

  getCategoryNames() {
    BlocProvider.of<EcommerceCubit>(context).getAllCategory();
  }


  deleteCategoryName({required int categoryIndex}){
        BlocProvider.of<EcommerceCubit>(context).deleteCategory(categoryIndex: categoryIndex);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:DrawerWidget(),
      appBar: AppBar(
        title: Text('Add Categories'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
            onPressed: () {
              saveCategoryName();
            },
            child: Text("Add category")),
      ),
      body: BlocConsumer<EcommerceCubit, EcommerceState>(
        listener: (context, state) {

          if(state is CategorySavedState){
            getCategoryNames();
          }
          else if(state is CategoryLoadedState){
            categoryList=state.categoryList;

            CategoryController.clear();
          }
          else if(state is  CategoryDeletedState){
            getCategoryNames();
          }
          // TODO: implement listener
        },
        builder: (context, state) {


          if(state is EcommerceLoadingState){
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
                    controller: CategoryController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("Categories")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(onPressed: (){

                            deleteCategoryName(categoryIndex: index);
                          }, icon: Icon(Icons.delete)),
                          
                          title: Text(categoryList[index]),
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
