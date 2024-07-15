import 'package:amir_diet/utils/app_constants.dart';
import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../../screens/view_workouts_screen.dart';
import '../extensions/constants.dart';
import '../utils/app_colors.dart';
import 'view_all_diet.dart';

class AssignScreen extends StatefulWidget {
  static String tag = '/AssignScreen';

  @override
  AssignScreenState createState() => AssignScreenState();
}

class AssignScreenState extends State<AssignScreen> {
  bool select = true;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPlan,
          context: context,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: context.dividerColor))),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color: select
                                  ? userStore.gender == MALE
                                      ? scaffoldColorDark
                                      : primaryColor
                                  : Colors.transparent))),
                  child: Text(languages.lblWorkouts,
                          style: boldTextStyle(
                              color: select
                                  ? userStore.gender == MALE
                                      ? scaffoldColorDark
                                      : primaryColor
                                  : textSecondaryColorGlobal))
                      .center(),
                ).onTap(
                  () {
                    setState(() {
                      select = !select;
                    });
                  },
                ).expand(),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    width: 1.5,
                    color: select
                        ? Colors.transparent
                        : userStore.gender == MALE
                            ? scaffoldColorDark
                            : primaryColor,
                  ))),
                  child: Text(
                    languages.lblDiet,
                    style: boldTextStyle(
                      color: select
                          ? textSecondaryColorGlobal
                          : userStore.gender == MALE
                              ? scaffoldColorDark
                              : primaryColor,
                    ),
                  ).center(),
                ).onTap(() {
                  setState(() {
                    select = !select;
                  });
                }).expand(),
              ]).paddingSymmetric(horizontal: 16),
            ),
          )),
      body: select
          ? ViewWorkoutsScreen(isAssign: true)
          : ViewAllDiet(isAssign: true),
    );
  }
}
