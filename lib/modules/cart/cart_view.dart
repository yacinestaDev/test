//
import 'package:amir_diet/extensions/app_button.dart';
import 'package:amir_diet/extensions/colors.dart';
import 'package:amir_diet/extensions/decorations.dart';
import 'package:amir_diet/extensions/extension_util/widget_extensions.dart';
import 'package:amir_diet/extensions/text_styles.dart';
import 'package:amir_diet/extensions/widgets.dart';
import 'package:amir_diet/main.dart';
import 'package:amir_diet/modules/store/store_controller.dart';
import 'package:amir_diet/utils/app_colors.dart';
import 'package:amir_diet/utils/app_constants.dart';
import 'package:amir_diet/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
// import '../controllers/store_controller.dart';

class CartPage extends StatelessWidget {
  final StoreController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.myCart,
        context: context,
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.cart.length,
                itemBuilder: (context, index) {
                  var product = controller.cart[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(product['image'], width: 50),
                      title: Text(
                        product['name'],
                        style: primaryTextStyle(),
                      ),
                      subtitle: Text(
                        "${product['price']} x ${product['quantity']}",
                        style: primaryTextStyle(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: context.height * 0.045,
                            width: context.width * 0.1,
                            decoration: BoxDecoration(
                                color: userStore.gender == MALE
                                    ? scaffoldColorDark
                                    : primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 0
                                          : 20),
                                  bottomLeft: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 0
                                          : 20),
                                  topRight: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 20
                                          : 0),
                                  bottomRight: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 20
                                          : 0),
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
                          Text("${product['quantity']}",
                                  style: boldTextStyle().copyWith(fontSize: 20))
                              .paddingAll(10),
                          Container(
                            height: context.height * 0.045,
                            width: context.width * 0.1,
                            decoration: BoxDecoration(
                                color: userStore.gender == MALE
                                    ? scaffoldColorDark
                                    : primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 20
                                          : 0),
                                  bottomLeft: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 20
                                          : 0),
                                  topRight: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 0
                                          : 20),
                                  bottomRight: Radius.circular(
                                      appStore.selectedLanguageCode == 'ar'
                                          ? 0
                                          : 20),
                                )),
                            child: IconButton(
                              color: userStore.gender == MALE
                                  ? scaffoldColorDark
                                  : primaryColor,
                              icon: Icon(
                                appStore.selectedLanguageCode == 'ar'
                                    ? Icons.remove
                                    : Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                appStore.selectedLanguageCode == 'ar'
                                    ? controller.removeFromCart(product)
                                    : controller.addToCart(product);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text("Total:",
                    //     style: TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.bold)),
                    // Text("${controller.total} DA",
                    //     style: TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                GestureDetector(
                        child: Text(
                          languages.lblClearAll,
                          style: primaryTextStyle(
                            color: userStore.gender == MALE
                                ? scaffoldDarkColor
                                : primaryColor,
                          ),
                        ).paddingLeft(2),
                        onTap: () {
                          // SignInScreen().launch(context);
                        })
                    .paddingAll(15),
                GestureDetector(
                  child: Container(
                      width: context.width * 0.8,
                      height: context.height * 0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(radiusCircular(15)),
                          border: Border.all(
                            width: 4,
                            color: userStore.gender == MALE
                                ? scaffoldDarkColor
                                : primaryColor,
                          )),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // backIcon(context).paddingOnly(
                            //   left: 10,
                            //   right: 10,
                            // ),

                            Text("${languages.totalPrice}",
                                style: boldTextStyle().copyWith(fontSize: 20)),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${controller.total} ",
                                style: boldTextStyle().copyWith(fontSize: 20)),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${languages.da}",
                                style: boldTextStyle().copyWith(fontSize: 20)),
                            Icon(
                                    appStore.selectedLanguageCode == 'ar'
                                        ? MaterialIcons.arrow_forward_ios
                                        : Octicons.chevron_left,
                                    color: userStore.gender == MALE
                                        ? scaffoldColorDark
                                        : primaryColor,
                                    size: 28)
                                .onTap(() {
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      )
                      // ,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
