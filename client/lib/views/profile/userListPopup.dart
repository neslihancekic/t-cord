import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:tcord/views/profile/myProfile.dart';
import 'package:tcord/views/profile/profile.dart';

class UserListPopup extends StatelessWidget {
  final List<UserModel> users;
  final String listName;

  const UserListPopup(this.users, this.listName, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.White.withOpacity(.9),
                      borderRadius: BorderRadius.circular(25)),
                  child: CustomScrollView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                          child: Container(
                        height: 50,
                        width: 136,
                        decoration: BoxDecoration(
                            color: AppTheme.MuntbattenPink.withOpacity(.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            boxShadow: [CustomBoxShadow()]),
                        child: Center(
                          child: Text(
                            listName,
                            style: TextStyle(
                              fontSize: AppTheme.TitleFontSize20,
                              color: AppTheme.DarkJungleGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )),
                      users.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, childAspectRatio: 5),
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Container(
                                      child: UserWidget(users[index])),
                                  childCount: users.length),
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                width: 56,
                height: 56,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(28)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: AppTheme.GhostWhite,
                            borderRadius: BorderRadius.circular(22)),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppTheme.Lilac,
                        ),
                      ),
                    ),
                  ),
                ),
              )
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
    UserWidgetController controller =
        Get.put(UserWidgetController(context, user));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Container(
        height: 50,
        width: 136,
        decoration: BoxDecoration(
            color: AppTheme.White.withOpacity(.7),
            boxShadow: [CustomBoxShadow()]),
        child: InkWell(
          onTap: () {
            if (controller.authenticationService.authenticationData!.user!.id ==
                user.id) {
              Get.to(() => MyProfilePage(), preventDuplicates: false);
            } else {
              Get.to(() => ProfilePage(userId: user.id),
                  preventDuplicates: false);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 17),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Visibility(
                  visible: controller
                          .authenticationService.authenticationData!.user!.id !=
                      user.id,
                  child: InkWell(
                      onTap: () async => controller.follow(),
                      child: Obx(() => controller.isFollowingBusy.value
                          ? Container(
                              width: 70,
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
                                  width: 70,
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
                                  width: 70,
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
                                ))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserWidgetController extends BaseGetxController {
  final UserModel user;
  var isFollowing = false.obs;
  var isFollowingBusy = false.obs;
  final UserService _userService = Get.find();
  UserWidgetController(BuildContext context, this.user) : super(context) {
    isFollowing.value = user.isFollowing ?? false;
  }

  Future follow() async {
    isFollowingBusy.value = true;
    await _userService.follow(new FollowRequest(userId: user.id));
    isFollowing.value = isFollowing.value ? false : true;
    isFollowingBusy.value = false;
  }
}
