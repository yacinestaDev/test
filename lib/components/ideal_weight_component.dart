import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../extensions/LiveStream.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import 'count_down_progress_indicator.dart';

class IdealWeightComponent extends StatefulWidget {
  static String tag = '/BMIComponent';

  @override
  IdealWeightComponentState createState() => IdealWeightComponentState();
}

class IdealWeightComponentState extends State<IdealWeightComponent>
    with TickerProviderStateMixin {
  double? mCm;

  double result = 0.0;

  late AnimationController controller;
  CountDownController mCountDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(PROGRESS, (p0) {
      convertFeetToCm();

      setState(() {});
    });
  }

  init() async {
    convertFeetToCm();
    double idealWeight;

    double inchesOver5Feet = (userStore.height.toDouble() - 152.4) / 2.54;
    if (userStore.gender == "male") {
      idealWeight = 52 + (1.9 * inchesOver5Feet);
    } else {
      idealWeight = 49 + (1.7 * inchesOver5Feet);
    }
    result = double.parse(idealWeight.toStringAsFixed(2));
    super.initState();
  }

  // convert Feet to cm
  void convertFeetToCm() {
    mCm = userStore.heightUnit == FEET
        ? double.parse(userStore.height.validate()) * 30.48
        : double.parse(userStore.height.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: appStore.isDarkMode
          ? boxDecorationWithRoundedCorners(
              borderRadius: radius(16), backgroundColor: context.cardColor)
          : boxDecorationRoundedWithShadow(16,
              backgroundColor: context.cardColor),
      child: Observer(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(8),
                      backgroundColor:
                          appStore.isDarkMode ? Colors.black : Colors.white),
                  padding: EdgeInsets.all(6),
                  child: Image.asset(ic_ideal_weight,
                      width: 22,
                      height: 22,
                      color: userStore.gender == MALE
                          ? scaffoldColorDark
                          : primaryColor),
                ),
                Text(languages.lblIdealWeight,
                    style: boldTextStyle(
                        size: 18,
                        color: appStore.isDarkMode
                            ? userStore.gender == MALE
                                ? scaffoldColorDark
                                : primaryColor
                            : black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
            12.height,
            Image.asset(ic_ideal_weight1,
                width: 50,
                height: 50,
                color: userStore.gender == MALE
                    ? scaffoldColorDark
                    : primaryColor),
            10.height,
            Text('$result', style: boldTextStyle(size: 19)),
            Text(languages.lblKg, style: secondaryTextStyle()),
          ],
        );
      }),
    );
  }
}
