import 'package:amir_diet/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../screens/favourite_screen.dart';
import '../../components/featured_diet_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../screens/view_all_diet.dart';
import '../components/diet_category_component.dart';
import '../extensions/app_text_field.dart';
import '../extensions/decorations.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/text_styles.dart';
import '../models/category_diet_response.dart';
import '../models/diet_response.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';
import 'no_data_screen.dart';
import 'view_diet_category_screen.dart';

class DietScreen extends StatefulWidget {
  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  List<CategoryDietModel>? mDietCategoryList = [];
  List<DietModel>? mFeaturedDietList = [];
  List<DietModel>? mOtherDietList = [];
  List<DietModel>? mDietList = [];

  TextEditingController mSearch = TextEditingController();
  String? mSearchValue = "";

  int page = 1;
  int? numPage;

  bool isLastPage = false;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getDietData();
    mSearch.addListener(() {
      setState(() {
        _showClearButton = mSearch.text.length > 0;
      });
    });
  }

  getDietData() async {
    appStore.setLoading(true);
    await getDietCategoryApi()
        .then((value) async {
          mDietCategoryList = value.data;
          setState(() {});
        })
        .catchError((e) {})
        .whenComplete(() async {
          await getDietApi("yes", false)
              .then((value) async {
                mFeaturedDietList = value.data;
                setState(() {});
              })
              .catchError((e) {})
              .whenComplete(() async {
                await getDietApi("no", false).then((value) {
                  mOtherDietList = value.data;
                  setState(() {});
                  appStore.setLoading(false);
                }).catchError((e) {
                  appStore.setLoading(false);
                });
              });
        });
  }

  getDietDataAPI() async {
    await getSearchDietApi(mSearch: mSearchValue).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDietList!.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mDietList!.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeading(String? title, {bool? isSeeAll = false, Function? onCall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!, style: boldTextStyle(size: 18))
            .paddingSymmetric(horizontal: 16),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            onCall!.call();
          },
          icon: appStore.selectedLanguageCode != 'ar'
              ? Transform.rotate(
                  angle: 180 *
                      (3.1415926535897932 / 180), // تحويل الدرجة إلى راديان
                  child: Icon(
                    Feather.chevron_right,
                    color: userStore.gender == MALE
                        ? scaffoldColorDark
                        : primaryColor,
                  ),
                )
              : Icon(
                  Feather.chevron_right,
                  color: userStore.gender == MALE
                      ? scaffoldColorDark
                      : primaryColor,
                ),
        ),
      ],
    );
  }

  Widget mDietSearchList(List<DietModel>? mList) {
    return ListView.builder(
      itemCount: mList!.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return FeaturedDietComponent(
          isList: true,
          mDietModel: mList[index],
        );
      },
    );
  }

  @override
  void dispose() {
    mSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblDiet,
          context: context,
          showBack: false,
          titleSpacing: 16,
          actions: [
            Image.asset(ic_favorite,
                    height: 25,
                    width: 25,
                    color: userStore.gender == MALE
                        ? scaffoldColorDark
                        : primaryColor)
                .onTap(() {
              FavouriteScreen(index: 1).launch(context);
            }).paddingSymmetric(horizontal: 16)
          ]),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: mSearch,
                  textFieldType: TextFieldType.OTHER,
                  isValidationRequired: false,
                  autoFocus: false,
                  suffix: getClearButton(),
                  decoration: defaultInputDecoration(context,
                      isFocusTExtField: true, label: languages.lblSearch),
                  onChanged: (v) {
                    mSearchValue = v;
                    appStore.setLoading(true);
                    getDietDataAPI();
                    setState(() {});
                  },
                ).paddingSymmetric(horizontal: 16),
                mSearchValue.isEmptyOrNull
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              8.height,
                              mHeading(languages.lblDietCategories, onCall: () {
                                ViewDietCategoryScreen().launch(context);
                              }),
                              HorizontalList(
                                physics: BouncingScrollPhysics(),
                                itemCount: mDietCategoryList!.length,
                                padding: EdgeInsets.only(left: 16, right: 8),
                                itemBuilder: (context, index) {
                                  return DietCategoryComponent(
                                    mCategoryDietModel:
                                        mDietCategoryList![index],
                                  );
                                },
                              ),
                            ],
                          ).visible(mDietCategoryList!.isNotEmpty),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              8.height,
                              mHeading(languages.lblBestDietDiscoveries,
                                  onCall: () {
                                ViewAllDiet(
                                        isFeatured: true,
                                        mTitle:
                                            languages.lblBestDietDiscoveries)
                                    .launch(context)
                                    .then((value) {
                                  getDietData();
                                  setState(() {});
                                });
                              }),
                              HorizontalList(
                                physics: BouncingScrollPhysics(),
                                itemCount: mFeaturedDietList!.length,
                                padding:
                                    EdgeInsets.only(left: 16, right: 8, top: 4),
                                itemBuilder: (context, index) {
                                  return FeaturedDietComponent(
                                    mDietModel: mFeaturedDietList![index],
                                  );
                                },
                              ),
                            ],
                          ).visible(mFeaturedDietList!.isNotEmpty),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mHeading(languages.lblDietaryOptions, onCall: () {
                                ViewAllDiet(mTitle: languages.lblDietaryOptions)
                                    .launch(context)
                                    .then((value) {
                                  getDietData();
                                  setState(() {});
                                });
                              }),
                              mDietSearchList(mOtherDietList),
                            ],
                          ).visible(mOtherDietList!.isNotEmpty)
                        ],
                      )
                    : Stack(
                        children: [
                          mDietSearchList(mDietList!).paddingTop(16),
                          SizedBox(
                            height: context.height() * 0.6,
                            child: NoDataScreen(
                              mTitle: languages.lblResultNoFound,
                            )
                                .visible(mDietList!.isEmpty)
                                .center()
                                .visible(!appStore.isLoading),
                          )
                        ],
                      ),
              ],
            ),
          ),
          Loader().visible(appStore.isLoading)
        ],
      ),
    );
  }

  Widget getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () {
        hideKeyboard(context);
        mSearch.clear();
        mSearchValue = "";
        setState(() {});
      },
      icon: Icon(Icons.clear),
    );
  }
}
