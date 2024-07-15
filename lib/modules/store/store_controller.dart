// // import 'package:get/get.dart';

// // class StoreController extends GetxController {
// //   var categories = [
// //     {"name": "Equipment", "image": "assets/ic_radio_button_fill.png"},
// //     {"name": "Nutrition", "image": "assets/ic_radio_button_fill.png"},
// //     {"name": "Clothing", "image": "assets/ic_radio_button_fill.png"},
// //     {"name": "Green", "image": "assets/ic_radio_button_fill.png"},
// //   ].obs;

// //   var products = [
// //     {
// //       "name": "Flex Dumbbells",
// //       "price": "2000 DA",
// //       "image": "assets/ic_radio_button_fill.png",
// //       "description": "High quality dumbbells for your workout."
// //     },
// //     {
// //       "name": "Jump Rope",
// //       "price": "1500 DA",
// //       "image": "assets/ic_radio_button_fill.png",
// //       "description": "Perfect for cardio exercises."
// //     },
// //     {
// //       "name": "Kettlebells",
// //       "price": "3000 DA",
// //       "image": "assets/ic_radio_button_fill.png",
// //       "description": "Kettlebells for strength training."
// //     },
// //     {
// //       "name": "Yoga Mat",
// //       "price": "2500 DA",
// //       "image": "assets/ic_radio_button_fill.png",
// //       "description": "Comfortable yoga mat for your practice."
// //     },
// //     {
// //       "name": "Hand Gripper",
// //       "price": "1000 DA",
// //       "image": "assets/ic_radio_button_fill.png",
// //       "description": "Improve your grip strength."
// //     },
// //   ].obs;

// //   var cart = [].obs;

// //   void addToCart(product) {
// //     cart.add(product);
// //   }

// //   void removeFromCart(product) {
// //     cart.remove(product);
// //   }
// // }
// import 'package:get/get.dart';

// class StoreController extends GetxController {
//   var categories = [
//     {"name": "Equipment", "image": "assets/ic_radio_button_fill.png"},
//     {"name": "Nutrition", "image": "assets/ic_radio_button_fill.png"},
//     {"name": "Clothing", "image": "assets/ic_radio_button_fill.png"},
//     {"name": "Green", "image": "assets/ic_radio_button_fill.png"},
//   ].obs;

//   var products = [
//     {
//       "name": "Flex Dumbbells",
//       "price": "2000 DA",
//       "image": "assets/ic_radio_button_fill.png",
//       "description": "High quality dumbbells for your workout."
//     },
//     {
//       "name": "Jump Rope",
//       "price": "1500 DA",
//       "image": "assets/ic_radio_button_fill.png",
//       "description": "Perfect for cardio exercises."
//     },
//     {
//       "name": "Kettlebells",
//       "price": "3000 DA",
//       "image": "assets/ic_radio_button_fill.png",
//       "description": "Kettlebells for strength training."
//     },
//     {
//       "name": "Yoga Mat",
//       "price": "2500 DA",
//       "image": "assets/yogamat.png",
//       "description": "Comfortable yoga mat for your practice."
//     },
//     {
//       "name": "Hand Gripper",
//       "price": "1000 DA",
//       "image": "assets/handgripper.png",
//       "description": "Improve your grip strength."
//     },
//   ].obs;

//   var cart = [].obs;

//   void addToCart(product) {
//     var index = cart.indexWhere((item) => item['name'] == product['name']);
//     if (index == -1) {
//       product['quantity'] = 1;
//       cart.add(product);
//     } else {
//       cart[index]['quantity'] += 1;
//       cart.refresh();
//     }
//   }

//   void removeFromCart(product) {
//     var index = cart.indexWhere((item) => item['name'] == product['name']);
//     if (index != -1 && cart[index]['quantity'] > 1) {
//       cart[index]['quantity'] -= 1;
//     } else {
//       cart.removeAt(index);
//     }
//     cart.refresh();
//   }

//   void deleteFromCart(product) {
//     cart.remove(product);
//   }

//   void clearCart() {
//     cart.clear();
//   }

//   double get total {
//     return cart.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
//   }
// }
import 'package:get/get.dart';

class StoreController extends GetxController {
  var categories = [
    {"name": "Equipment", "image": "assets/categori1.png"},
    {"name": "Nutrition", "image": "assets/categor2.png"},
    {"name": "Clothing", "image": "assets/categori3.png"},
    // {"name": "Green", "image": "assets/ic_radio_button_fill.png"},
  ].obs;

  var products = [
    {
      "name": "Flex Dumbbells",
      "price": "1000",
      "image": "assets/image1.png",
      "description": "High quality dumbbells for your workout."
    },
    {
      "name": "Jump Rope",
      "price": "1500",
      "image": "assets/image2.png",
      "description": "Perfect for cardio exercises."
    },
    {
      "name": "Kettlebells",
      "price": "300",
      "image": "assets/image3.png",
      "description": "Kettlebells for strength training."
    },
    {
      "name": "Yoga Mat",
      "price": "2500",
      "image": "assets/image4.png",
      "description": "Comfortable yoga mat for your practice."
    },
    {
      "name": "Hand Gripper",
      "price": "1000",
      "image": "assets/image5.png",
      "description": "Improve your grip strength."
    },
  ].obs;

  var cart = [].obs;
  // RxList<Map<String, dynamic>> cart = <Map<String, dynamic>>[].obs;
  void addToCart(product) {
    var index = cart.indexWhere((item) => item['name'] == product['name']);
    if (index == -1) {
      product['quantity'] = "1";
      cart.add(product);
    } else {
      cart[index]['quantity'] = "${int.parse(cart[index]['quantity']) + 1}";
      cart.refresh();
    }
  }

  void removeFromCart(product) {
    var index = cart.indexWhere((item) => item['name'] == product['name']);
    if (index != -1 && int.parse(cart[index]['quantity']) > 1) {
      cart[index]['quantity'] = "${int.parse(cart[index]['quantity']) - 1}";
    } else {
      cart.removeAt(index);
    }
    cart.refresh();
  }

  void deleteFromCart(product) {
    cart.remove(product);
  }

  void clearCart() {
    cart.clear();
  }

  double get total {
    return cart
        .fold(
            0,
            (sum, item) =>
                sum + int.parse(item['price']) * int.parse(item['quantity']))
        .toDouble();
  }
}
