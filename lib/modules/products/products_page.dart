import 'package:amir_diet/extensions/colors.dart';
import 'package:amir_diet/extensions/text_styles.dart';
import 'package:amir_diet/extensions/widgets.dart';
import 'package:amir_diet/main.dart';
import 'package:amir_diet/modules/product_detail/product_detail_page.dart';
import 'package:amir_diet/modules/store/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsPage extends StatelessWidget {
  final StoreController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.allProducts,
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: context.height * 0.015, left: context.height * 0.015),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            var product = controller.products[index];
            return GestureDetector(
              onTap: () {
                Get.to(ProductDetailPage(product: product));
              },
              child: Card(
                color: whiteSmoke,
                child: Column(
                  children: [
                    Image.asset(product['image']!,
                        height: context.height * 0.11),
                    SizedBox(
                      height: context.height * 0.02,
                    ),
                    Text(
                      product['name']!,
                      style: boldTextStyle().copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    Text(
                      "${product['price']!} ${languages.da}",
                      style: primaryTextStyle().copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
