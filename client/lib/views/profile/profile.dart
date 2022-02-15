import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcord/main.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/composition/feed.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/profile/editProfile.dart';
import 'package:tcord/views/profile/userListPopup.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({Key? key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfilePageController controller =
        Get.put(ProfilePageController(context, userId));
    return Scaffold(
      backgroundColor: AppTheme.MintCream,
      body: RefreshIndicator(
        onRefresh: () async => await controller.refresh(),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                    backgroundColor: AppTheme.White.withOpacity(0),
                    shadowColor: AppTheme.White.withOpacity(0),
                    collapsedHeight: 255,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                height: 260,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        colorFilter:
                                            ColorFilter.linearToSrgbGamma(),
                                        image:
                                            AssetImage('assets/png/lines.png'),
                                        fit: BoxFit.fill)),
                              ),
                            ],
                          ),
                          Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.linearToSrgbGamma(),
                                      image: AssetImage(
                                          'assets/png/background.png'),
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: HeaderWidget(),
                              )),
                          Positioned(
                            top: 185,
                            left: MediaQuery.of(context).size.width / 6,
                            child: InkWell(
                              onTap: () => controller.compositionsSelected(),
                              child: Column(
                                children: [
                                  Obx(() => Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(27)),
                                        child: new Icon(
                                          Icons.play_arrow_rounded,
                                          color: controller
                                                  .isCompositionsPageSelected
                                                  .value
                                              ? AppTheme.Lilac
                                              : AppTheme.Lilac.withOpacity(0.3),
                                          size: 55,
                                        ),
                                      )),
                                  Text(
                                    "Compositions",
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.MuntbattenPink,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 185,
                              left: MediaQuery.of(context).size.width / 2.3,
                              child: InkWell(
                                onTap: () => controller.debutsSelected(),
                                child: Column(
                                  children: [
                                    Obx(() => Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.star_rate_rounded,
                                            color: controller
                                                    .isDebutsPageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 50,
                                          ),
                                        )),
                                    Text(
                                      "Debuts",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.MuntbattenPink,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Positioned(
                              top: 210,
                              left: MediaQuery.of(context).size.width / 1.4,
                              child: InkWell(
                                onTap: () => controller.likesSelected(),
                                child: Column(
                                  children: [
                                    Obx(() => Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.favorite_rounded,
                                            color: controller
                                                    .isLikesPageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 40,
                                          ),
                                        )),
                                    Text(
                                      "Likes",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.MuntbattenPink,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )),
                SliverToBoxAdapter(
                  child: Obx(() => GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      childAspectRatio: 1,
                      children: List.generate(
                          controller.compositions.length,
                          (index) => InkWell(
                                onTap: () => {
                                  Get.to(() => FeedPage(
                                        compositions: controller.compositions,
                                        index: index,
                                      ))
                                },
                                child: buildCompositionItem(
                                    context,
                                    controller.compositions[index].photo,
                                    index,
                                    controller.compositions[index]),
                              ),
                          growable: true))),
                ),
              ],
            ),
            Obx(() => Visibility(
                  visible: controller.isBusy.value,
                  child: BusyPageIndicator(),
                ))
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String? userId;

  const HeaderWidget({Key? key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfilePageController controller =
        Get.put(ProfilePageController(context, userId));
    return Obx(() => Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 15, bottom: 18, right: 20),
          child: Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: AppTheme.Opal,
                    boxShadow: [CustomBoxShadow()],
                    borderRadius: BorderRadius.circular(36)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: AppTheme.White,
                        borderRadius: BorderRadius.circular(34)),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: controller.user.value.profilePhoto == null
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
                                imageUrl: controller.user.value.profilePhoto!,
                                placeholder: (context, url) => Center(
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset(
                                            'assets/images/loading.gif'))),
                                errorWidget: (context, url, error) => new Icon(
                                  Icons.error_outline,
                                  size: 30,
                                ),
                                fit: BoxFit.cover,
                              )),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 17),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.user.value.username ?? "",
                                style: TextStyle(
                                  fontSize: AppTheme.TitleFontSize20,
                                  color: AppTheme.DarkJungleGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                controller.user.value.profileInfo ?? "",
                                style: TextStyle(
                                  fontSize: AppTheme.FootnoteFontSize13,
                                  color: AppTheme.DarkJungleGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 30),
                        Padding(
                            padding: const EdgeInsets.only(top: 0, left: 17),
                            child: InkWell(
                              onTap: () async =>
                                  await controller.openFollowers(),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                      fontSize: AppTheme.CaptionFontSize11,
                                      color: AppTheme.GrayWeb,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Obx(() => Text(
                                        controller.user.value.followerCount
                                                ?.toString() ??
                                            "",
                                        style: TextStyle(
                                          fontSize: AppTheme.FootnoteFontSize13,
                                          color: AppTheme.DarkJungleGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 0, left: 17),
                            child: InkWell(
                              onTap: () async =>
                                  await controller.openFollowing(),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                      fontSize: AppTheme.CaptionFontSize11,
                                      color: AppTheme.GrayWeb,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Obx(() => Text(
                                        controller.user.value.followingCount
                                                ?.toString() ??
                                            "",
                                        style: TextStyle(
                                          fontSize: AppTheme.FootnoteFontSize13,
                                          color: AppTheme.DarkJungleGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 17),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Compositions",
                                style: TextStyle(
                                  fontSize: AppTheme.CaptionFontSize11,
                                  color: AppTheme.GrayWeb,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Obx(() => Text(
                                    controller.user.value.compositionCount
                                            ?.toString() ??
                                        "",
                                    style: TextStyle(
                                      fontSize: AppTheme.FootnoteFontSize13,
                                      color: AppTheme.DarkJungleGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Center(
                      child: InkWell(
                    onTap: () async {
                      await controller.follow();
                    },
                    child: Obx(
                      () => controller.isFollowingBusy.value
                          ? Container(
                              width: 300,
                              height: 35,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: AppTheme.Lilac.withOpacity(0.1),
                                  boxShadow: [CustomBoxShadow()],
                                  border: Border.all(
                                    width: 0.5,
                                    color: AppTheme.GrayWeb.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/images/dualBall.gif'))),
                            )
                          : controller.isFollowing.value
                              ? Container(
                                  width: 300,
                                  height: 35,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      color: AppTheme.Opal.withOpacity(0.5),
                                      boxShadow: [CustomBoxShadow()],
                                      border: Border.all(
                                        width: 0.5,
                                        color:
                                            AppTheme.GrayWeb.withOpacity(0.2),
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text(
                                      "Unfollow",
                                      style: TextStyle(
                                        fontSize: AppTheme.FootnoteFontSize13,
                                        color: AppTheme.DarkJungleGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 300,
                                  height: 35,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppTheme.Opal,
                                            AppTheme.Lilac.withOpacity(0.5),
                                          ]),
                                      border: Border.all(
                                        width: 0.5,
                                        color:
                                            AppTheme.GrayWeb.withOpacity(0.2),
                                      ),
                                      boxShadow: [CustomBoxShadow()],
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                        fontSize: AppTheme.FootnoteFontSize13,
                                        color: AppTheme.DarkJungleGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                  )))
            ],
          ),
        ));
  }
}

Widget buildCompositionItem(BuildContext context, String? photo, int index,
    CompositionModel composition) {
  List<Color> colors = [
    AppTheme.Lilac.withOpacity(0.1),
    AppTheme.Opal.withOpacity(0.2),
    AppTheme.MuntbattenPink.withOpacity(0.1),
    AppTheme.GrayWeb.withOpacity(0.1)
  ];
  var i = index % 4;
  return Container(
      decoration: BoxDecoration(
          color: colors[i], border: Border.all(color: AppTheme.GrayWeb)),
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              width: MediaQuery.of(context).size.width / 3.3,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: AppTheme.Opal,
                        boxShadow: [CustomBoxShadow()],
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: AppTheme.White,
                            borderRadius: BorderRadius.circular(34)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: photo == null
                              ? Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27)),
                                  child: new Icon(
                                    Icons.person,
                                    size: 15,
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
                                    imageUrl: photo,
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
                  Spacer(),
                  Text(
                    DateFormat.yMd()
                        .format(DateTime.parse(composition.createdAt!)),
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.DarkJungleGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.width / 10,
              left: MediaQuery.of(context).size.width / 10,
              child: Container(
                height: MediaQuery.of(context).size.width / 8,
                width: MediaQuery.of(context).size.width / 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width / 16)),
                    border: Border.all(color: AppTheme.GrayWeb, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('play'.toSvgPath(),
                      color: AppTheme.GrayWeb, width: 20),
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.width / 3.6,
            left: 5,
            child: Text(
              composition.title ?? "asdasdasd",
              style: TextStyle(
                fontSize: 9,
                color: AppTheme.DarkJungleGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ));
}

class ProfilePageController extends BaseGetxController {
  final String? userId;
  var user = UserModel().obs;
  var isFollowing = false.obs;
  var isFollowingBusy = false.obs;
  final UserService _userService = Get.find();
  var compositions = <CompositionModel>[].obs;

  var isCompositionsPageSelected = true.obs;
  var isDebutsPageSelected = false.obs;
  var isLikesPageSelected = false.obs;
  ProfilePageController(BuildContext context, this.userId) : super(context);

  Future refresh() async {
    isBusy.value = true;
    var response = await _userService.getUser(userId ?? "");
    user.value = response;
    var a = authenticationService.authenticationData!.user;
    if (a!.following != null) {
      isFollowing.value = a.following!.contains(user.value.id) ? true : false;
    }
    var comps;
    if (isCompositionsPageSelected.value) {
      comps = await _userService.getUserCompositions(userId ?? "");
    } else if (isDebutsPageSelected.value) {
      comps = await _userService.getUserDebuts(userId ?? "");
    } else if (isLikesPageSelected.value) {
      comps = await _userService.getUserLikes(userId ?? "");
    }
    compositions.value = comps.compositions ?? [];
    isBusy.value = false;
  }

  Future compositionsSelected() async {
    if (isCompositionsPageSelected.value) {
      return;
    }
    isCompositionsPageSelected.value = true;
    isDebutsPageSelected.value = false;
    isLikesPageSelected.value = false;
    await refresh();
  }

  Future debutsSelected() async {
    if (isDebutsPageSelected.value) {
      return;
    }
    isCompositionsPageSelected.value = false;
    isDebutsPageSelected.value = true;
    isLikesPageSelected.value = false;
    await refresh();
  }

  Future likesSelected() async {
    if (isLikesPageSelected.value) {
      return;
    }
    isCompositionsPageSelected.value = false;
    isDebutsPageSelected.value = false;
    isLikesPageSelected.value = true;
    await refresh();
  }

  Future follow() async {
    if (isBusy.value) return;
    isBusy.value = true;
    isFollowingBusy.value = true;
    user.value.followerCount = !isFollowing.value
        ? (user.value.followerCount ?? 0) + 1
        : (user.value.followerCount ?? 0) - 1;
    isFollowing.value = !isFollowing.value ? true : false;
    user.refresh();
    var a = await _userService.follow(new FollowRequest(userId: user.value.id));

    isFollowingBusy.value = false;
    authenticationService.authenticationData!.user = a;
    isBusy.value = false;
  }

  Future openFollowers() async {
    isBusy.value = true;
    var response = await _userService.getUserFollowers(user.value.id ?? "");
    await showPopup(
        context: context, child: UserListPopup(response ?? [], "FOLLOWERS"));
    isBusy.value = false;
  }

  Future openFollowing() async {
    isBusy.value = true;
    var response = await _userService.getUserFollowing(user.value.id ?? "");
    await showPopup(
        context: context, child: UserListPopup(response ?? [], "FOLLOWING"));
    isBusy.value = false;
  }

  @override
  void onInit() async {
    isFollowingBusy.value = true;
    await refresh();
    isFollowingBusy.value = false;
    super.onInit();
  }
}
