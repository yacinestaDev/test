import 'package:amir_diet/extensions/colors.dart';
import 'package:amir_diet/extensions/decorations.dart';
import 'package:amir_diet/extensions/text_styles.dart';
import 'package:amir_diet/extensions/widgets.dart';
import 'package:amir_diet/language/base_language.dart';
import 'package:amir_diet/main.dart';
import 'package:amir_diet/modules/cart/cart_view.dart';
import 'package:amir_diet/modules/category/category_page.dart';
import 'package:amir_diet/modules/product_detail/product_detail_page.dart';
import 'package:amir_diet/modules/products/products_page.dart';
import 'package:amir_diet/modules/store/store_controller.dart';
import 'package:amir_diet/utils/app_colors.dart';
import 'package:amir_diet/utils/app_constants.dart';
import 'package:amir_diet/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../extensions/app_text_field.dart';

class StorePage extends StatelessWidget {
  final StoreController controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.store,
          context: context,
          showBack: false,
          titleSpacing: 20,
          actions: [
            AnimatedContainer(
              margin: EdgeInsets.only(left: 8, top: 4),
              duration: Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Image.asset(
                      ic_store_fill,
                      height: 50,
                      width: 50,
                      color: userStore.gender == MALE
                          ? scaffoldColorDark
                          : primaryColor,
                    ),
                    onPressed: () async {
                      Get.to(CartPage());
                    },
                    color: userStore.gender == MALE
                        ? scaffoldColorDark
                        : primaryColor,
                  )
                ],
              ),
              width: 70,
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            AppTextField(
              // controller: mSearchCont,
              textFieldType: TextFieldType.OTHER,
              isValidationRequired: false,
              autoFocus: false,
              // suffix: _getClearButton(),
              decoration: defaultInputDecoration(context,
                  label: languages.lblSearch, isFocusTExtField: true),
              onTap: () {
                // hideKeyboard(context);
                // SearchScreen().launch(context);
              },
            ).paddingSymmetric(horizontal: 16),
            // Advertising space
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      languages.advertisingsSpace,
                      // "Advertising space",
                      style: boldTextStyle().copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Container(
                width: context.width,
                decoration: BoxDecoration(),
                height: context.height * 0.27,
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset("assets/images1.png"))),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      languages.Categories,
                      style: boldTextStyle().copyWith(fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: appStore.selectedLanguageCode != 'ar'
                      ? Icon(Icons.chevron_left, color: grayColor)
                      : Icon(
                          Icons.chevron_right,
                          color: grayColor,
                        ),
                  onPressed: () async {
                    // Get.to(Categor());
                  },
                  color: userStore.gender == MALE
                      ? scaffoldColorDark
                      : primaryColor,
                )
              ],
            ),
            Obx(() {
              return Container(
                padding: EdgeInsets.only(
                    right: context.height * 0.015,
                    left: context.height * 0.015),
                height: 160,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  scrollDirection: Axis.horizontal, // تمرير أفقي

                  // scrollDirection: Axis.vertical,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    var category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(CategoryPage(category: category));
                      },
                      child: Card(
                        // borderOnForeground: false,
                        // shadowColor: whiteSmoke.withAlpha(255),
                        color: Color.fromARGB(255, 245, 245, 245),
                        child: Padding(
                          padding: EdgeInsets.all(
                            context.height * 0.01,
                          ),
                          child: Column(
                            children: [
                              Image.asset(category['image']!,
                                  height: context.height * 0.11),
                              SizedBox(
                                height: context.height * 0.03,
                              ),
                              Text(
                                category['name']!,
                                style: boldTextStyle().copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            // All Products
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      languages.allProducts,
                      style: boldTextStyle().copyWith(fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: appStore.selectedLanguageCode == 'ar'
                      ? Icon(Icons.chevron_left, color: grayColor)
                      : Icon(
                          Icons.chevron_right,
                          color: grayColor,
                        ),
                  onPressed: () async {
                    Get.to(ProductsPage());
                  },
                  color: userStore.gender == MALE
                      ? scaffoldColorDark
                      : primaryColor,
                )
              ],
            ),
            Obx(() {
              return Container(
                padding: EdgeInsets.only(
                    right: context.height * 0.015,
                    left: context.height * 0.015),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
