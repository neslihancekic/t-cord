import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcord/main.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/models/comment/comment_model.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/comment_service.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/addTrack/addTrack.dart';
import 'package:tcord/views/animation/progress_animation.dart';
import 'package:tcord/views/comment/commentPopup.dart';
import 'package:tcord/views/composition/morePopup.dart';
import 'package:tcord/views/composition/trackPopup.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/profile/myProfile.dart';
import 'package:tcord/views/profile/profile.dart';
import 'package:tcord/views/profile/userListPopup.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:audioplayers/audioplayers.dart' as p;

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.put(HomePageController(context));

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
              body: Obx(
            () => controller.compositions.length == 0
                ? SizedBox.shrink()
                : TikTokStyleFullPageScroller(
                    contentSize: controller.compositions.length,
                    swipePositionThreshold: 0.1,
                    swipeVelocityThreshold: 2000,
                    animationDuration: const Duration(milliseconds: 300),
                    onScrollEvent: controller._handleCallbackEvent,
                    builder: (BuildContext context, int index) {
                      return Container(
                        color: AppTheme.MintCream,
                        child: Column(
                          children: [
                            HeaderWidget(index: index),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                            InkWell(
                              onTap: () async => await controller.resume(),
                              child: Obx(
                                () => controller.isPlaying.value
                                    ? Icon(Icons.pause_circle_outline_rounded,
                                        size: 80, color: AppTheme.Opal)
                                    : Icon(Icons.play_circle_outline_rounded,
                                        size: 80, color: AppTheme.Opal),
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    Visibility(
                                      visible: controller.authenticationService
                                              .authenticationData!.user!.id ==
                                          controller
                                              .compositions[index].ownerUserId,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: InkWell(
                                          onTap: () {
                                            showGeneralDialog(
                                              barrierDismissible: true,
                                              barrierColor:
                                                  AppTheme.DarkJungleGreen
                                                      .withOpacity(0.4),
                                              barrierLabel: '',
                                              transitionDuration:
                                                  Duration(milliseconds: 400),
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  SizedBox.shrink(),
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                final curvedValue = Curves
                                                        .easeInOutCubic
                                                        .transform(a1.value) -
                                                    1.0;
                                                return Transform(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          0.0,
                                                          curvedValue * -50,
                                                          0.0),
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: MorePopup(
                                                        composition: controller
                                                                .compositions[
                                                            index],
                                                        refresh:
                                                            controller.refresh),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(Icons.more_horiz_rounded,
                                              size: 35,
                                              color: AppTheme.Opal.withOpacity(
                                                  0.7)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: InkWell(
                                        onTap: () async {
                                          String path = controller
                                              .compositions[index].sheetMusic!;
                                          GallerySaver.saveImage(path);

                                          await showCustomGeneralDialog(
                                              context,
                                              Icon(
                                                Icons.check_circle,
                                                size: 100,
                                                color: AppTheme.Success,
                                              ),
                                              "Sheet music saved!",
                                              AppLocalizations.of(context)!
                                                  .okayUpper);
                                        },
                                        child: SvgPicture.asset(
                                            'musicNotes'.toSvgPath(),
                                            color:
                                                AppTheme.Opal.withOpacity(0.7),
                                            width: 35),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: InkWell(
                                        onTap: () async {
                                          await showPopup(
                                              context: context,
                                              child: TrackPopup(
                                                  composition: controller
                                                      .compositions[index]));
                                        },
                                        child: SvgPicture.asset(
                                            'midi'.toSvgPath(),
                                            color:
                                                AppTheme.Opal.withOpacity(0.7),
                                            width: 35),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Spacer(),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: InkWell(
                                          onTap: () async {
                                            Get.to(() => AddTrackPage(
                                                composition: controller
                                                    .compositions[index]));
                                          },
                                          child: Icon(
                                              Icons.my_library_music_rounded,
                                              size: 35,
                                              color: AppTheme.Opal.withOpacity(
                                                  0.7)),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Obx(() =>
                                BottomWidget(controller.compositions[index]))
                          ],
                        ),
                      );
                    },
                  ),
          )),
        ),
        Obx(() => Visibility(
              visible: controller.isBusy.value,
              child: BusyPageIndicator(),
            ))
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final int index;
  const HeaderWidget({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find();
    AuthenticationData? authenticationData =
        controller.authenticationService.authenticationData;
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: 6,
                  color: AppTheme.Lilac.withOpacity(0.3),
                  width: MediaQuery.of(context).size.width),
              ProgressAnimation(Container(
                  height: 6,
                  width: MediaQuery.of(context).size.width,
                  color: AppTheme.Lilac)),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 15, bottom: 18, right: 20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: AppTheme.Opal,
                      boxShadow: [CustomBoxShadow()],
                      borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: AppTheme.White,
                          borderRadius: BorderRadius.circular(34)),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: controller.compositions[index].photo == ""
                            ? Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27)),
                                child: new Icon(
                                  Icons.person,
                                  size: 16,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  controller.compositions[index].photo!,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.compositions[index].username ?? "",
                        style: TextStyle(
                          fontSize: AppTheme.BodyFontSize15,
                          color: AppTheme.DarkJungleGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                    onTap: () async => await controller
                        .openContributers(controller.compositions[index]),
                    child: Container(
                      height: 50,
                      width: 45,
                      child: Stack(
                        children: [
                          controller.compositions[index].userPhotos!.length > 1
                              ? Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: AppTheme.Opal,
                                        boxShadow: [CustomBoxShadow()],
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            color: AppTheme.White,
                                            borderRadius:
                                                BorderRadius.circular(34)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: controller.compositions[index]
                                                      .userPhotos![0] ==
                                                  ""
                                              ? Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              27)),
                                                  child: new Icon(
                                                    Icons.person,
                                                    size: 8,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    controller
                                                        .compositions[index]
                                                        .userPhotos![0],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          controller.compositions[index].userPhotos!.length > 2
                              ? Positioned(
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: AppTheme.Opal,
                                        boxShadow: [CustomBoxShadow()],
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            color: AppTheme.White,
                                            borderRadius:
                                                BorderRadius.circular(34)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: controller.compositions[index]
                                                      .userPhotos![1] ==
                                                  ""
                                              ? Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              27)),
                                                  child: new Icon(
                                                    Icons.person,
                                                    size: 8,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    controller
                                                        .compositions[index]
                                                        .userPhotos![1],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          controller.compositions[index].userPhotos!.length > 3
                              ? Positioned(
                                  top: 15,
                                  left: 3,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: AppTheme.Opal,
                                        boxShadow: [CustomBoxShadow()],
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            color: AppTheme.White,
                                            borderRadius:
                                                BorderRadius.circular(34)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: controller.compositions[index]
                                                      .userPhotos![2] ==
                                                  ""
                                              ? Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              27)),
                                                  child: new Icon(
                                                    Icons.person,
                                                    size: 8,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    controller
                                                        .compositions[index]
                                                        .userPhotos![2],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          controller.compositions[index].userPhotos!.length > 4
                              ? Positioned(
                                  right: 0,
                                  top: 27,
                                  child: Text(
                                    "+ " +
                                        (controller.compositions[index]
                                                    .userPhotos!.length -
                                                3)
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: AppTheme.CaptionFontSize11,
                                      color: AppTheme.DarkJungleGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  final CompositionModel compositionModel;
  const BottomWidget(
    this.compositionModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find();
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      controller.like(compositionModel);
      compositionModel.isLiked = !isLiked;
      return !isLiked;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 18, right: 20),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compositionModel.title ?? "",
                  style: TextStyle(
                    fontSize: AppTheme.BodyFontSize15,
                    color: AppTheme.DarkJungleGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  compositionModel.info ?? "",
                  style: TextStyle(
                    fontSize: AppTheme.FootnoteFontSize13,
                    color: AppTheme.DarkJungleGreen.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          LikeButton(
            onTap: onLikeButtonTapped,
            isLiked: compositionModel.isLiked ?? false,
            size: 35,
            circleColor:
                CircleColor(start: AppTheme.Critical, end: AppTheme.Lilac),
            bubblesColor: BubblesColor(
              dotPrimaryColor: AppTheme.Critical,
              dotSecondaryColor: AppTheme.Lilac,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite_outlined,
                color: isLiked
                    ? AppTheme.Lilac
                    : AppTheme.DarkJungleGreen.withOpacity(0.3),
                size: 35,
              );
            },
            likeCount: compositionModel.likes != null
                ? compositionModel.likes!.length
                : 0,
            countBuilder: (int? count, bool isLiked, String text) {
              var color = isLiked
                  ? AppTheme.Lilac
                  : AppTheme.DarkJungleGreen.withOpacity(0.3);
              Widget result;
              if (count == 0) {
                result = Text(
                  " ",
                  style: TextStyle(color: color),
                );
              } else
                result = Text(
                  text,
                  style: TextStyle(color: color),
                );
              return result;
            },
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () async => await controller.openComments(compositionModel),
            child: Row(
              children: [
                Icon(Icons.comment, size: 35, color: AppTheme.Opal),
                compositionModel.commentCount == null ||
                        compositionModel.commentCount == 0
                    ? SizedBox.shrink()
                    : SizedBox(width: 5),
                Text(
                  compositionModel.commentCount == null ||
                          compositionModel.commentCount == 0
                      ? ""
                      : compositionModel.commentCount.toString(),
                  style: TextStyle(color: AppTheme.Opal),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageController extends BaseGetxController {
  final UploadService _uploadService = Get.find();
  final CompositionService _compositionService = Get.find();
  final CommentService _commentService = Get.find();

  late p.AudioPlayer player;
  var isInitPlayer = false;
  var compositions = <CompositionModel>[].obs;
  var isPlaying = false.obs;
  var isComplete = false.obs;
  var duration = 0.obs;

  var cacheIndex = 0;
  HomePageController(BuildContext context, {List<CompositionModel>? comps})
      : super(context) {
    player = new p.AudioPlayer();
    if (comps != null) compositions.value = comps;
  }

  Future play(String savedpath) async {
    if (isPlaying.value) {
      //stop playing
      if (player != null) {
        await player.pause();
        isPlaying.value = false;
        isComplete.value = true;
      }
    } else {
      //play
      if (!isInitPlayer) {
        player.onPlayerCompletion.listen((event) {
          isPlaying.value = false;
          isComplete.value = true;
        });
        player.onPlayerStateChanged.listen((p.PlayerState s) {
          if (s == p.PlayerState.PLAYING) {
            isPlaying.value = true;
            isComplete.value = false;
          }
        });
        player.onDurationChanged.listen((Duration d) {
          isPlaying.value = false;
          duration.value = d.inMicroseconds;
          isPlaying.value = true;
        });
        isInitPlayer = true;
      }
      await player.setUrl(savedpath, isLocal: true);

      await player.resume();
    }
  }

  Future resume() async {
    if (isPlaying.value) {
      //stop playing
      if (player != null) {
        await player.pause();
        isPlaying.value = false;
        isComplete.value = false;
      }
    } else {
      //play
      await player.resume();
    }
  }

  Future<bool> like(CompositionModel model) async {
    var data = await _compositionService.likeComposition(model.id!);
    compositions[compositions.indexWhere((element) => element.id == model.id)]
        .likes = data.likes;

    return data.likes!
        .contains(authenticationService.authenticationData!.user!.id!);
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) async {
    if (isPlaying.value) {
      await play(compositions[currentIndex!].audioPath!);
    } else {
      isPlaying.value = false;
      isComplete.value = true;
    }
    await play(compositions[currentIndex!].audioPath!);
    if (type == ScrollEventType.SCROLLED_FORWARD) {
      if (cacheIndex == 2 && compositions.length >= currentIndex + 3) {
        var file = await DefaultCacheManager()
            .downloadFile(compositions[currentIndex + 3].audio!);
        var savedpath = file.file.path;
        compositions[currentIndex + 3].audioPath = savedpath;
      } else if (cacheIndex != 2) {
        cacheIndex++;
      }
    }
  }

  Future openContributers(CompositionModel comp) async {
    isBusy.value = true;
    var response = await _compositionService.getContributers(comp.id ?? "");
    await showPopup(
        context: context, child: UserListPopup(response ?? [], "CONTRIBUTERS"));
    isBusy.value = false;
  }

  Future openComments(CompositionModel comp) async {
    isBusy.value = true;
    var c = await _commentService.getComments(comp.id ?? "");
    if (c == null) c = List<CommentModel>.empty(growable: true);

    await showPopup(
        context: context, child: CommentListPopup(comp, c, sendComment));
    isBusy.value = false;
  }

  Future refresh() async {
    var data = await _compositionService.allCompositions();
    compositions.value = data.compositions!;
    for (var i in compositions.take(5)) {
      var file = await DefaultCacheManager().downloadFile(i.audio!);
      var savedpath = file.file.path;
      i.audioPath = savedpath;
      if (compositions.first == i) {
        await play(compositions[0].audioPath!);
      }
    }
  }

  @override
  void onInit() async {
    isInitialized.value = false;
    await refresh();
    isInitialized.value = true;
    super.onInit();
  }

  Future<CommentModel> sendComment(
      CompositionModel compositionModel, comment) async {
    isBusy.value = true;
    var c = await _commentService.createComment(CommentModel(
        userId: compositionModel.ownerUserId,
        commentedUserId: authenticationService.authenticationData!.user!.id!,
        compositionId: compositionModel.id,
        comment: comment));
    compositions
        .firstWhere((element) => element.id == compositionModel.id)
        .commentCount = compositions
            .firstWhere((element) => element.id == compositionModel.id)
            .commentCount! +
        1;
    isBusy.value = false;
    return c;
  }

  @override
  void onReady() async {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == "AppLifecycleState.paused" ||
          msg == "AppLifecycleState.inactive") {}
      return;
    });
    super.onReady();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
