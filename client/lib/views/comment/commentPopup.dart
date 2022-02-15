import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tcord/models/comment/comment_model.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/comment_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:tcord/views/profile/myProfile.dart';
import 'package:tcord/views/profile/profile.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CommentListPopup extends StatefulWidget {
  final CompositionModel composition;
  final List<CommentModel> comments;
  final Function sendComment;

  const CommentListPopup(this.composition, this.comments, this.sendComment,
      {Key? key})
      : super(key: key);
  @override
  _CommentListState createState() => _CommentListState(
        this.composition,
        this.comments,
        this.sendComment,
      );
}

class _CommentListState extends State<CommentListPopup> {
  CompositionModel composition;
  List<CommentModel> comments;
  Function sendComment;

  final commentTextController = TextEditingController();
  final commentFocusNode = FocusNode();

  _CommentListState(this.composition, this.comments, this.sendComment);

  Future sendCommentFunction() async {
    if (commentTextController.text == "") return;
    var x = await sendComment.call(composition, commentTextController.text);
    commentTextController.text = "";
    commentFocusNode.unfocus();
    setState(() {
      comments.add(x);
    });
  }

  Future deleteCommentFunction(CommentModel comment) async {
    final CommentService _commentService = Get.find();
    var c = await _commentService.deleteComment(comment.sId!);
    setState(() {
      comments.remove(comment);
    });
  }

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
                height: 40,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.White.withOpacity(.9),
                      borderRadius: BorderRadius.circular(25)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: CustomScrollView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                                child: Container(
                              height: 50,
                              width: 136,
                              decoration: BoxDecoration(
                                  color:
                                      AppTheme.MuntbattenPink.withOpacity(.5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25)),
                                  boxShadow: [CustomBoxShadow()]),
                              child: Center(
                                child: Text(
                                  "COMMENTS",
                                  style: TextStyle(
                                    fontSize: AppTheme.TitleFontSize20,
                                    color: AppTheme.DarkJungleGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )),
                            comments.isEmpty
                                ? SliverToBoxAdapter(
                                    child: SizedBox.shrink(),
                                  )
                                : SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 5),
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) => Container(
                                            child: CommentWidget(
                                                comments[index],
                                                deleteCommentFunction)),
                                        childCount: comments.length),
                                  ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedTextField(
                              child: Row(
                            children: [
                              SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: TextField(
                                    focusNode: commentFocusNode,
                                    controller: commentTextController,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppTheme.BodyFontSize15,
                                        color: AppTheme.Xiketic),
                                    decoration: InputDecoration(
                                      labelText: "Add Comment",
                                      labelStyle: TextStyle(
                                          color: commentFocusNode.hasFocus
                                              ? AppTheme.Opal
                                              : AppTheme.Lilac),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppTheme.Opal),
                                      ),
                                    ),
                                    cursorColor: AppTheme.Xiketic,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                    child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () async {
                                    await sendCommentFunction();
                                  },
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: AppTheme.Lilac,
                                  ),
                                )),
                              ),
                            ],
                          ))),
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
                    onTap: () => {
                      Navigator.pop(context, true),
                    },
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

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final Function deleteComment;

  CommentWidget(this.comment, this.deleteComment);
  @override
  Widget build(BuildContext context) {
    CommentWidgetController controller =
        Get.put(CommentWidgetController(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.GhostWhite,
            boxShadow: [CustomBoxShadow()],
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Padding(
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
                          child: comment.photo == null || comment.photo == ""
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
                                    imageUrl: comment.photo ?? "",
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
                        comment.username ?? "",
                        style: TextStyle(
                            fontFamily: "Circular",
                            fontWeight: FontWeight.w700,
                            fontSize: AppTheme.BodyFontSize15,
                            color: AppTheme.Xiketic),
                      ),
                      Text(
                        comment.comment ?? "",
                        style: TextStyle(
                            fontFamily: "Circular",
                            fontWeight: FontWeight.w600,
                            fontSize: AppTheme.FootnoteFontSize13,
                            color: AppTheme.Xiketic),
                      ),
                    ],
                  ),
                  Spacer(),
                  controller.authenticationService.authenticationData!.user!
                              .id ==
                          comment.commentedUserId
                      ? IconButton(
                          highlightColor: AppTheme.Lilac.withOpacity(0.3),
                          splashColor: AppTheme.Lilac.withOpacity(0.3),
                          onPressed: () async {
                            controller.isBusy.value = true;
                            await deleteComment(comment);

                            controller.isBusy.value = false;
                          },
                          icon: Icon(
                            Icons.delete,
                            color: AppTheme.Lilac,
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
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

class CommentWidgetController extends BaseGetxController {
  CommentWidgetController(BuildContext context) : super(context);
}

class AnimatedTextField extends StatefulWidget {
  final Widget child;

  const AnimatedTextField({Key? key, required this.child}) : super(key: key);
  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 570.0, end: 300.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    var keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(height: _animation.value),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13),
          child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.White.withOpacity(.9),
                  boxShadow: [CustomBoxShadow()],
                  borderRadius: BorderRadius.circular(20)),
              child: widget.child),
        ),
      ],
    ));
  }
}
