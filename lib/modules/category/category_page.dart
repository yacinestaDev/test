import 'package:amir_diet/modules/product_detail/product_detail_page.dart';
import 'package:amir_diet/modules/store/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/store_controller.dart';
// import 'products_page.dart';

class CategoryPage extends StatelessWidget {
  final Map<String, String> category;
  final StoreController controller = Get.find();

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category['name']!)),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          var product = controller.products[index];
          // Assuming we filter products based on category here
          if (product['category'] == category['name']) {
            return GestureDetector(
              onTap: () {
                Get.to(ProductDetailPage(product: product));
              },
              child: Card(
                child: Column(
                  children: [
                    Image.asset(product['image']!, height: 80),
                    Text(product['name']!),
                    Text(product['price']!),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
