import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcord/main.dart';
import 'package:tcord/models/notification/notification_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/notification_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/menu_item.dart';
import 'package:tcord/views/generic/slidableWidget.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/login/login.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationsPageController controller =
        Get.put(NotificationsPageController(context));
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async => await controller.refresh(),
            child: SafeArea(
                child: Stack(children: [
              Obx(() => CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          backgroundColor: AppTheme.White.withOpacity(0),
                          shadowColor: AppTheme.White.withOpacity(0),
                          collapsedHeight: 100,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding:
                                const EdgeInsets.fromLTRB(20, 20, 15, 10),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Notifications",
                                  style: TextStyle(
                                      fontFamily: "Circular",
                                      fontWeight: FontWeight.w700,
                                      fontSize: AppTheme.TitleFontSize20,
                                      color: AppTheme.DarkJungleGreen),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Obx(() => InkWell(
                                          onTap: () => controller.allSelected(),
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(27)),
                                            child: new Icon(
                                              Icons.notifications_active,
                                              color: controller
                                                      .isAllPageSelected.value
                                                  ? AppTheme.Lilac
                                                  : AppTheme.Lilac.withOpacity(
                                                      0.3),
                                              size: 30,
                                            ),
                                          ),
                                        )),
                                    Obx(() => InkWell(
                                        onTap: () => controller.likeSelected(),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.favorite,
                                            color: controller
                                                    .isLikePageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 30,
                                          ),
                                        ))),
                                    Obx(() => InkWell(
                                        onTap: () =>
                                            controller.followSelected(),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.person_add,
                                            color: controller
                                                    .isFollowPageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 30,
                                          ),
                                        ))),
                                    Obx(() => InkWell(
                                        onTap: () => controller.trackSelected(),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.library_music_rounded,
                                            color: controller
                                                    .isTrackPageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 30,
                                          ),
                                        ))),
                                    Obx(() => InkWell(
                                        onTap: () =>
                                            controller.commentSelected(),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27)),
                                          child: new Icon(
                                            Icons.comment,
                                            color: controller
                                                    .isCommentPageSelected.value
                                                ? AppTheme.Lilac
                                                : AppTheme.Lilac.withOpacity(
                                                    0.3),
                                            size: 30,
                                          ),
                                        ))),
                                  ],
                                )
                              ],
                            ),
                          )),
                      controller.notifications.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio:
                                          MediaQuery.of(context).size.width /
                                              58),
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Container(
                                          child: Column(
                                        children: [
                                          buildNotifications(
                                              controller.notifications[index],
                                              onTap: () async => controller
                                                      .notifications[index] =
                                                  await controller.read(
                                                      controller.notifications[
                                                          index]),
                                              delete: controller
                                                  .onClickedSideContext),
                                          Container(
                                              height: 1,
                                              color: AppTheme.Xiketic),
                                        ],
                                      )),
                                  childCount: controller.notifications.length),
                            ),
                    ],
                  )),
              Obx(() => Visibility(
                    visible: controller.isBusy.value,
                    child: BusyPageIndicator(),
                  ))
            ]))));
  }
}

Widget buildNotifications(NotificationModel notification,
    {Function? onTap, Function? delete}) {
  return SlidableWidget(
      onDismissed: (action) async => await delete!.call(notification, action),
      actionList: [SlidableAction.delete],
      enabled: true,
      child: Material(
        color: AppTheme.MintCream,
        child: InkWell(
          onTap: () => {onTap?.call()},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 15, 10),
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
                        child: notification.image == null
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
                                  imageUrl: notification.image!,
                                  placeholder: (context, url) => Center(
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                              'assets/images/loading.gif'))),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.error_outline,
                                    size: 15,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? "",
                      style: TextStyle(
                          fontFamily: "Circular",
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.BodyFontSize15,
                          color: AppTheme.Xiketic),
                    ),
                    Text(
                      notification.body ?? "",
                      style: TextStyle(
                          fontFamily: "Circular",
                          fontWeight: FontWeight.w600,
                          fontSize: AppTheme.FootnoteFontSize13,
                          color: AppTheme.Xiketic),
                    ),
                  ],
                ),
                Spacer(),
                notification.isRead == false
                    ? Container(
                        width: 10,
                        height: 10,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: AppTheme.Lilac,
                            boxShadow: [CustomBoxShadow()],
                            borderRadius: BorderRadius.circular(5)),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ));
}

class NotificationsPageController extends BaseGetxController {
  final NotificationService _notificationService = Get.find();
  NotificationsPageController(BuildContext context) : super(context);

  var allNotifications = <NotificationModel>[].obs;
  var notifications = <NotificationModel>[].obs;

  var isAllPageSelected = true.obs;
  var isLikePageSelected = false.obs;
  var isFollowPageSelected = false.obs;
  var isTrackPageSelected = false.obs;
  var isCommentPageSelected = false.obs;

  //SIDE CONTEXT
  Future onClickedSideContext(
      NotificationModel not, SlidableAction action) async {
    switch (action) {
      case SlidableAction.delete:
        notifications.remove(not);
        allNotifications.remove(not);
        await _notificationService.deleteNotification(not.sId!);
        break;
    }
  }

  Future refresh() async {
    isBusy.value = true;
    var data = await _notificationService.getNotifications();

    allNotifications.value = data!;
    if (isAllPageSelected.value) {
      notifications.value = data;
    } else if (isLikePageSelected.value) {
      likeSelected();
    } else if (isFollowPageSelected.value) {
      followSelected();
    } else if (isTrackPageSelected.value) {
      trackSelected();
    } else if (isCommentPageSelected.value) {
      commentSelected();
    }
    isBusy.value = false;
  }

  Future<NotificationModel> read(NotificationModel not) async {
    var request = NotificationModel(isRead: true);
    var data = await _notificationService.readNotification(not.sId!, request);
    return data!;
  }

  Future allSelected() async {
    if (isAllPageSelected.value) {
      return;
    }
    isAllPageSelected.value = true;
    isLikePageSelected.value = false;
    isFollowPageSelected.value = false;
    isTrackPageSelected.value = false;
    isCommentPageSelected.value = false;
    notifications.value = allNotifications;
  }

  Future likeSelected() async {
    if (isLikePageSelected.value) {
      return;
    }
    isAllPageSelected.value = false;
    isLikePageSelected.value = true;
    isFollowPageSelected.value = false;
    isTrackPageSelected.value = false;
    isCommentPageSelected.value = false;
    notifications.value = allNotifications.where((p0) => p0.type == 0).toList();
  }

  Future followSelected() async {
    if (isFollowPageSelected.value) {
      return;
    }
    isAllPageSelected.value = false;
    isLikePageSelected.value = false;
    isFollowPageSelected.value = true;
    isTrackPageSelected.value = false;
    isCommentPageSelected.value = false;
    notifications.value = allNotifications.where((p0) => p0.type == 1).toList();
  }

  Future trackSelected() async {
    if (isTrackPageSelected.value) {
      return;
    }
    isAllPageSelected.value = false;
    isLikePageSelected.value = false;
    isFollowPageSelected.value = false;
    isTrackPageSelected.value = true;
    isCommentPageSelected.value = false;
    notifications.value = allNotifications.where((p0) => p0.type == 2).toList();
  }

  Future commentSelected() async {
    if (isCommentPageSelected.value) {
      return;
    }
    isAllPageSelected.value = false;
    isLikePageSelected.value = false;
    isFollowPageSelected.value = false;
    isTrackPageSelected.value = false;
    isCommentPageSelected.value = true;
    notifications.value = allNotifications.where((p0) => p0.type == 3).toList();
  }

  @override
  void onInit() async {
    isInitialized.value = false;
    await refresh();
    isInitialized.value = true;
    super.onInit();
  }
}
