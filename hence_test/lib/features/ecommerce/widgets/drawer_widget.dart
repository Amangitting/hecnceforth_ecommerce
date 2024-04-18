import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hence_test/features/ecommerce/screens/add_category_screen.dart';
import 'package:hence_test/features/ecommerce/screens/add_product_screen.dart';
import 'package:hence_test/features/ecommerce/screens/all_products_screen.dart';
import 'package:hence_test/features/ecommerce/screens/product_by_category.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
                   ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategoryScreen(),
                      ));
                },
                child: Text("Add category")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(),
                      ));
                },
                child: Text("Add product")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductByCategory(),
                      ));
                },
                child: Text("Product by category")),
                           ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProductScreen(),
                      ));
                },
                child: Text("All Product")),
          ],
        ),
      );
  }
}