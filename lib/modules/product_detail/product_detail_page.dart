import 'package:amir_diet/extensions/app_button.dart';
import 'package:amir_diet/extensions/constants.dart';
import 'package:amir_diet/extensions/extension_util/widget_extensions.dart';
import 'package:amir_diet/extensions/text_styles.dart';
import 'package:amir_diet/extensions/widgets.dart';
import 'package:amir_diet/main.dart';
import 'package:amir_diet/modules/cart/cart_view.dart';
import 'package:amir_diet/modules/store/store_controller.dart';
import 'package:amir_diet/utils/app_colors.dart';
import 'package:amir_diet/utils/app_constants.dart';
import 'package:amir_diet/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/store_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final StoreController controller = Get.find();

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", context: context, showBack: false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
                child: Container(
                    child: Image.asset(product['image'],
                        height: context.height * 0.11))),
            SizedBox(height: 16),
            Text(
              product['name'],
              style: boldTextStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              product['price'],
              style: primaryTextStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(product['description']),
            // Spacer(),
            SizedBox(
              height: context.height * 0.3,
            ),
            Obx(() {
              var inCart = controller.cart
                  .firstWhereOrNull((item) => item['name'] == product['name']);
              if (inCart != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //
                  children: [
                    Container(
                      height: context.height * 0.05,
                      width: context.width * 0.1,
                      decoration: BoxDecoration(
                          color: userStore.gender == MALE
                              ? scaffoldColorDark
                              : primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 0 : 20),
                            bottomLeft: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 0 : 20),
                            topRight: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 20 : 0),
                            bottomRight: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 20 : 0),
                          )),
                      child: IconButton(
                        color: userStore.gender == MALE
                            ? scaffoldColorDark
                            : primaryColor,
                        icon: Icon(
                          appStore.selectedLanguageCode != 'ar'
                              ? Icons.remove
                              : Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          appStore.selectedLanguageCode != 'ar'
                              ? controller.removeFromCart(product)
                              : controller.addToCart(product);
                        },
                      ),
                    ),
                    Text("${inCart['quantity']}",
                            style: boldTextStyle().copyWith(fontSize: 20))
                        .paddingAll(10),
                    Container(
                      height: context.height * 0.05,
                      width: context.width * 0.1,
                      decoration: BoxDecoration(
                          color: userStore.gender == MALE
                              ? scaffoldColorDark
                              : primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 20 : 0),
                            bottomLeft: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 20 : 0),
                            topRight: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 0 : 20),
                            bottomRight: Radius.circular(
                                appStore.selectedLanguageCode != 'ar' ? 0 : 20),
                          )),
                      child: IconButton(
                        color: userStore.gender == MALE
                            ? scaffoldColorDark
                            : primaryColor,
                        icon: Icon(
                          appStore.selectedLanguageCode != 'ar'
                              ? Icons.remove
                              : Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          appStore.selectedLanguageCode != 'ar'
                              ? controller.removeFromCart(product)
                              : controller.addToCart(product);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return AppButton(
                    text: languages.lblAdd,
                    width: context.width,
                    color: userStore.gender == MALE
                        ? scaffoldColorDark
                        : primaryColor,
                    disabledColor: defaultInkWellHoverColor,
                    onTap: () {
                      controller.addToCart(product);
                    }).paddingSymmetric(horizontal: 16);
              }
            }),
          ],
        ),
      ),
    );
  }
}
