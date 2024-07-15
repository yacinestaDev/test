import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../extensions/colors.dart';
import '../extensions/shared_pref.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import '../../extensions/app_button.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../../main.dart';
import '../extensions/app_text_field.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/constants.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../models/graph_response.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';

class ProgressComponent1 extends StatefulWidget {
  static String tag = '/UserAddMeasurementDialog';
  final GraphModel? mGraphModel;
  final String? mType;
  final String? mUnit;
  final Function? onCall;
  var data;

  ProgressComponent1(
      {this.mGraphModel, this.mType, this.mUnit, this.onCall, this.data});

  @override
  ProgressComponent1State createState() => ProgressComponent1State();
}

class ProgressComponent1State extends State<ProgressComponent1> {
  var formKey = GlobalKey<FormState>();

  TextEditingController mValueCont = TextEditingController();
  TextEditingController countDownCont = TextEditingController();

  TextEditingController mAgeCont = TextEditingController();

  List<String> item = ["Female", "Male"];

  String mGender = "Female";
  double height = 170.0; // Default height in centimeters
  int age = 25;

  FocusNode mAgeFocus = FocusNode();
  bool mIsUpdate = false;

  DateTime? pickedDate;
  String? formattedDate;
  String _result = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mGraphModel != null;

    if (mIsUpdate) {
      mValueCont.text = widget.mGraphModel!.value!;
      formattedDate =
          progressDateStringWidget(widget.mGraphModel!.date.toString());
      countDownCont.text = formattedDate.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // void calculateIBW() {
  //   double height = double.tryParse(mValueCont.text) ?? 0.0;
  //   int age = int.tryParse(mAgeCont.text) ?? 0;
  //
  //   if (height > 0 && age > 0) {
  //     double ibwMale = 52 + (1.9 * (height - 60));
  //     double ibwFemale = 49 + (1.7 * (height - 60));
  //
  //     setState(() {
  //       // For simplicity, let's assume gender based on the formula
  //       // If you want to include gender selection, you can modify this logic.
  //       _result = 'Estimated IBW: ${ibwMale.toStringAsFixed(2)} kg (Male)\n'
  //           'Estimated IBW: ${ibwFemale.toStringAsFixed(2)} kg (Female)';
  //     });
  //   } else {
  //     setState(() {
  //       _result = 'Please enter a valid height.';
  //     });
  //   }
  // }
  double calculateIdealBodyWeight(double height, int age, String gender) {
    double idealWeight;

    if (gender == 'Male') {
      if (age >= 18) {
        // Robinson formula for men
        idealWeight = 52 + (1.9 * ((height - 152.4) / 2.54));
      } else {
        // Robinson formula for adolescent males
        idealWeight = 49 + (1.7 * ((height - 152.4) / 2.54));
      }
    } else {
      if (age >= 18) {
        // Robinson formula for women
        idealWeight = 49 + (1.7 * ((height - 152.4) / 2.54));
      } else {
        // Robinson formula for adolescent females
        idealWeight = 45.5 + (2.3 * ((height - 152.4) / 2.54));
      }
    }

    return idealWeight;
  }

  Future<void> save({String? id}) async {
    if (formKey.currentState!.validate()) {
      Map req;
      if (mIsUpdate) {
        req = {
          "id": id,
          "value": widget.data,
          "type": widget.mType,
          "unit": widget.mUnit,
          "date": countDownCont.text
        };
      } else {
        req = {
          "value": widget.data,
          "type": widget.mType,
          "unit": widget.mUnit,
          "date": countDownCont.text
        };
      }
      await setProgressApi(req).then((value) {
        toast(value.message);
        widget.onCall!.call();
        finish(context);
        setState(() {});
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  Future<void> delete() async {
    Map req = {
      "id": widget.mGraphModel!.id,
    };
    await deleteProgressApi(req).then((value) {
      toast(value.message);
      widget.onCall!.call();
      finish(context);
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500),
        child: Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            backgroundColor:
                appStore.isDarkMode ? cardDarkColor : cardLightColor,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          mIsUpdate
                              ? '${languages.lblUpdate} ${widget.mType.capitalizeFirstLetter()}'
                              : '${languages.lblAdd} ${widget.mType.capitalizeFirstLetter()}',
                          style: boldTextStyle()),
                      4.height,
                      InkWell(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: appStore.isDarkMode
                                  ? cardDarkColor
                                  : context.cardColor),
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.close,
                              color: appStore.isDarkMode
                                  ? cardLightColor
                                  : cardDarkColor),
                        ),
                      )
                    ],
                  ),
                  20.height,
                  DropdownButtonFormField(
                    items: item
                        .map((value) => DropdownMenuItem<String>(
                              child: Text(value, style: primaryTextStyle()),
                              value: value,
                            ))
                        .toList(),
                    isExpanded: false,
                    isDense: true,
                    borderRadius: radius(),
                    decoration: defaultInputDecoration(context),
                    value: mGender,
                    onChanged: (String? value) {
                      setState(() {
                        mGender = value.validate();
                      });
                    },
                  ),
                  20.height,
                  AppTextField(
                    controller: mAgeCont,
                    textFieldType: TextFieldType.NUMBER,
                    isValidationRequired: true,
                    focus: mAgeFocus,
                    decoration: defaultInputDecoration(context,
                        label: languages.lblEnterAge),
                    onChanged: (value) {
                      setState(() {
                        age = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  20.height,
                  AppTextField(
                    controller: mValueCont,
                    textFieldType: TextFieldType.PHONE,
                    decoration: defaultInputDecoration(context,
                        label: languages.lblHint),
                    suffix: Text(widget.mUnit.toString(),
                            style: secondaryTextStyle())
                        .paddingSymmetric(vertical: 16, horizontal: 0),
                    autoFocus: false,
                    isValidationRequired: true,
                    onChanged: (value) {
                      setState(() {
                        height = double.tryParse(value) ?? 0.0;
                      });
                    },
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  // Text(
                  //   'Ideal Body Weight (IBW): ${idealWeight.toStringAsFixed(2)} kg',
                  //   style: TextStyle(fontSize: 18.0),
                  // ),
                  16.height,
                  AppTextField(
                    controller: countDownCont,
                    textFieldType: TextFieldType.NAME,
                    onChanged: (s) {
                      setState(() {});
                    },
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        print(pickedDate);
                        formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate!);
                        print(formattedDate);
                        setState(() {
                          countDownCont.text = formattedDate!;
                        });
                      } else {}
                    },
                    readOnly: true,
                    suffix: Icon(Icons.calendar_today),
                    decoration: defaultInputDecoration(context,
                        label: languages.lblDate),
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  25.height,
                  mIsUpdate == true
                      ? Row(
                          children: [
                            AppButton(
                              color: userStore.gender == MALE
                                  ? scaffoldColorDark
                                  : primaryColor,
                              onTap: () {
                                showConfirmDialogCustom(context,
                                    dialogType: DialogType.CONFIRMATION,
                                    iconColor: userStore.gender == MALE
                                        ? scaffoldColorDark
                                        : primaryColor,
                                    primaryColor: userStore.gender == MALE
                                        ? scaffoldColorDark
                                        : primaryColor,
                                    title:
                                        "${languages.lblDelete} ${widget.mType.capitalizeFirstLetter()}",
                                    image: ic_delete,
                                    subTitle:
                                        "${languages.lblDeleteAccountMSg} ${widget.mType.capitalizeFirstLetter()}?",
                                    onAccept: (context) {
                                  delete();
                                });
                              },
                              text: languages.lblDelete,
                            ).expand(),
                            16.width,
                            AppButton(
                              color: userStore.gender == MALE
                                  ? scaffoldColorDark
                                  : primaryColor,
                              text: languages.lblUpdate,
                              onTap: () {
                                widget.data = calculateIdealBodyWeight(
                                    height, age, mGender);
                                save(id: widget.mGraphModel!.id.toString());
                              },
                            ).expand()
                          ],
                        )
                      : AppButton(
                          color: userStore.gender == MALE
                              ? scaffoldColorDark
                              : primaryColor,
                          width: context.width(),
                          text: languages.lblSave,
                          onTap: () {
                            widget.data =
                                calculateIdealBodyWeight(height, age, mGender);
                            save();
                            print(
                                "-------->${calculateIdealBodyWeight(height, age, mGender)}");

                            // save();
                          },
                        ),
                  // Text(calculateIdealBodyWeight(height, age, mGender).toStringAsFixed(2))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
