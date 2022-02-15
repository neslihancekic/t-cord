import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcord/main.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/menu_item.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/login/login.dart';
import 'package:tcord/views/profile/profile.dart';

// ignore: must_be_immutable

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SearchPageController(context));
    var safePaddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.MintCream,
      body: GestureDetector(
        onTap: () {
          controller.searchFocusNode.unfocus();
        },
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.axisDirection == AxisDirection.right ||
                    scrollInfo.metrics.axisDirection == AxisDirection.left) {
                  return true;
                }
                controller.scrollOffset.value = scrollInfo.metrics.pixels;
                if (scrollInfo.metrics.maxScrollExtent -
                        scrollInfo.metrics.pixels <
                    50) {
                  controller.loadMoreusers();
                }
                return true;
              },
              child: CustomScrollView(
                controller: controller.scrollController,
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SearchAreaWidget(
                        topSafeMargin: MediaQuery.of(context).padding.top),
                  ),
                  Obx(
                    () => SliverToBoxAdapter(
                      child: controller.isInitState.value &&
                              !controller.isSuggestingCategories.value &&
                              controller.isLastViewedUserLoaded.value
                          ? LastViewed()
                          : SizedBox.shrink(),
                    ),
                  ),
                  Obx(
                    () => SliverToBoxAdapter(
                      child: controller.isNoResultState.value ||
                              controller.isInitState.value ||
                              controller.isSuggestingCategories.value
                          ? SizedBox.shrink()
                          : SizedBox(height: 15),
                    ),
                  ),
                  Obx(
                    () => SliverToBoxAdapter(
                      child: controller.isNoResultState.value &&
                              !controller.isInitState.value &&
                              !controller.isSuggestingCategories.value
                          ? NoResult()
                          : SizedBox.shrink(),
                    ),
                  ),
                  Obx(
                    () => controller.users == null || controller.users.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 20),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, childAspectRatio: 5),
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Container(
                                      child:
                                          UserWidget(controller.users[index])),
                                  childCount: controller.users.length),
                            ),
                          ),
                  ),
                  Obx(
                    () => SliverToBoxAdapter(
                      child: controller.isLoadingMore.value
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                height: 35,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(AppTheme.Opal)),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                  visible: controller.scrollOffset > 140 &&
                      !controller.isSuggestingCategories.value &&
                      !controller.isInitState.value,
                  child: Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [CustomBoxShadow()]),
                      child: Material(
                        color: AppTheme.White,
                        child: InkWell(
                          onTap: () => controller.scrollController.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn),
                          child: Icon(Icons.keyboard_arrow_up_rounded),
                        ),
                      ),
                    ),
                  )),
            ),
            Obx(() => Visibility(
                  visible: controller.isBusy.value,
                  child: BusyPageIndicator(),
                )),
          ],
        ),
      ),
    );
  }
}

class LastViewed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.recentlyViewedUpper,
                  style: TextStyle(
                      fontSize: AppTheme.BodyFontSize15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, childAspectRatio: 5),
                children: List.generate(
                  controller.lastViewed.length,
                  (index) {
                    return Container(
                        child: UserWidget(controller.lastViewed[index]));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SearchAreaWidget extends StatelessWidget {
  final double topSafeMargin;

  const SearchAreaWidget({Key? key, required this.topSafeMargin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SearchPageController controller = Get.find();
    return Container(
      height: 56 + topSafeMargin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          boxShadow: [CustomBoxShadow()],
          color: AppTheme.Opal.withOpacity(0.3)),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Icon(
                  Icons.search_rounded,
                  color: AppTheme.DarkJungleGreen,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: TextField(
                  onEditingComplete: () async => await controller.searchUser(),
                  focusNode: controller.searchFocusNode,
                  controller: controller.searchTextController,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppTheme.BodyFontSize15,
                      color: AppTheme.Xiketic),
                  cursorColor: AppTheme.Xiketic,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Container(
                  child: Obx(() => controller.isClearTextVisible.value
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: controller.clearSearch,
                          icon: SvgPicture.asset(
                              'iconsBasicDeleteConsole'.toSvgPath(),
                              color: AppTheme.DarkJungleGreen))
                      : SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  final UserModel user;
  UserWidget(this.user);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Container(
        height: 50,
        width: 136,
        decoration: BoxDecoration(
            color: AppTheme.White.withOpacity(.7),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [CustomBoxShadow()]),
        child: Material(
          child: InkWell(
            onTap: () {
              Get.to(() => ProfilePage(userId: user.id));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 60,
                  height: 60,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: AppTheme.Opal,
                      boxShadow: [CustomBoxShadow()],
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: AppTheme.White,
                          borderRadius: BorderRadius.circular(34)),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: user.profilePhoto == null
                            ? Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27)),
                                child: new Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              )
                            : Container(
                                clipBehavior: Clip.hardEdge,
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: AppTheme.Opal,
                                    borderRadius: BorderRadius.circular(50)),
                                child: CachedNetworkImage(
                                  imageUrl: user.profilePhoto!,
                                  placeholder: (context, url) => Center(
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                              'assets/images/loading.gif'))),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.error_outline,
                                    size: 30,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),
                  ),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 17),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.username ?? "",
                          style: TextStyle(
                            fontSize: AppTheme.Body2FontSize18,
                            color: AppTheme.DarkJungleGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          user.profileInfo ?? "",
                          style: TextStyle(
                            fontSize: AppTheme.Footnote2FontSize12,
                            color: AppTheme.DarkJungleGreen.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14),
          Obx(
            () => Text(
              controller.resultText.value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.Opal),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(child: Text(AppLocalizations.of(context)!.noUsersFound)),
          ],
        ));
  }
}

class SearchPageController extends BaseGetxController {
  final UserService _userService = Get.find();
  bool hasLoadMoreLimit = false;
  var isInitState = true.obs;
  var isNoResultState = false.obs;
  var isClearTextVisible = false.obs;
  var isSuggestingCategories = false.obs;
  var isLastViewedUserLoaded = false.obs;
  var isLoadingMore = false.obs;
  int _pageIndex = 0;
  var resultText = "".obs;
  var filterQuery = "";
  var sort = "";
  final scrollController = ScrollController();
  final searchTextController = TextEditingController();
  final searchFocusNode = FocusNode();
  var users = <UserModel>[].obs;
  var lastViewed = <UserModel>[].obs;
  Rx<double> scrollOffset = Rx<double>(0);
  var columnCount = 2.obs;

  SearchPageController(BuildContext context) : super(context) {
    searchTextController.addListener(textChanged);
  }
  Future getLastViewed() async {
    lastViewed.value = await _userService.getLastViewedUsers();
    isLastViewedUserLoaded.value = true;
  }

  textChanged() {
    if (searchTextController.text.isNotEmpty) {
      isClearTextVisible.value = true;
    } else {
      isClearTextVisible.value = false;
    }
  }

  clearSearch() async {
    isInitState.value = true;
    isClearTextVisible.value = false;
    isNoResultState.value = false;

    await getLastViewed();
    resultText.value = "";
    searchTextController.text = "";
    users.clear();
  }

  loadMoreusers() async {
    if (isBusy.value ||
        hasLoadMoreLimit ||
        users.isEmpty ||
        isLoadingMore.value) return;
    _pageIndex++;
    isLoadingMore.value = true;
    await addUsersToList(true);
    isLoadingMore.value = false;
    isBusy.value = false;
  }

  Future searchUser() async {
    if (isBusy.value) return;
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
    filterQuery = "";
    isSuggestingCategories.value = false;
    if (searchTextController.text == null ||
        searchTextController.text.isEmpty) {
      await clearSearch();
      isBusy.value = false;
      return;
    }
    _pageIndex = 0;
    hasLoadMoreLimit = false;
    isBusy.value = true;
    await addUsersToList(false);
    isBusy.value = false;
  }

  addUsersToList(bool isAddingMore) async {
    var response = await _userService.searchUser(
        searchTextController.text, _pageIndex, 10);
    isBusy.value = false;
    if (isAddingMore) {
      if (response != null) {
        users.addAll(response);
      } else {
        hasLoadMoreLimit = true;
      }
      return;
    }
    isClearTextVisible.value = true;
    isInitState.value = false;
    isNoResultState.value = false;
    users.clear();
    if (response != null) {
      users.addAll(response);
      resultText.value = AppLocalizations.of(context)!
          .userSearchResult
          .replaceAll("total_result_count", "${response.length}")
          .replaceAll("search_text", searchTextController.text.toUpperCase());
    } else {
      resultText.value = "";
      isNoResultState.value = true;
    }
  }

  @override
  void onReady() async {
    await getLastViewed();

    if (!searchFocusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 500))
          .then((value) async => searchFocusNode.requestFocus());
    }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
