import 'package:cached_network_image/cached_network_image.dart';
import 'package:tcord/models/generic/button_model.dart';
import 'package:tcord/models/generic/customer_field.dart';
import 'package:tcord/models/generic/selectable_models.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'themes.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppTheme.DarkJungleGreen)),
    );
  }
}

class CustomInputForm extends StatefulWidget {
  final String placeHolder;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final bool isPassword;
  final Function? onEditingComplete;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final int? maxLength;
  final bool hasShadow;
  final bool isRequired;
  CustomInputForm(this.placeHolder, this.controller, this.focusNode,
      {this.fontSize = AppTheme.BodyFontSize15,
      this.fontWeight = FontWeight.w600,
      this.textColor = AppTheme.DarkJungleGreen,
      this.isPassword = false,
      this.onEditingComplete,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.autoFocus = false,
      this.maxLength,
      this.hasShadow = true,
      this.isRequired = false});

  @override
  State<StatefulWidget> createState() =>
      _CustomInputForm(placeHolder, controller, focusNode,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textColor: textColor,
          isPassword: isPassword,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autoFocus: autoFocus,
          maxLength: maxLength,
          hasShadow: hasShadow,
          isRequired: isRequired);
}

class _CustomInputForm extends State<CustomInputForm> {
  var isPlaceHolderState = false;
  final String placeHolder;
  final TextEditingController controller;
  final FocusNode focusNode;
  double fontSize;
  FontWeight fontWeight;
  Color textColor;
  final bool isPassword;
  Function? onEditingComplete;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  bool autoFocus;
  final int? maxLength;
  final bool hasShadow;
  final bool isRequired;
  var showingPassword = false.obs;
  var text = "".obs;
  _CustomInputForm(this.placeHolder, this.controller, this.focusNode,
      {this.fontSize = AppTheme.BodyFontSize15,
      this.fontWeight = FontWeight.w600,
      this.textColor = AppTheme.DarkJungleGreen,
      this.isPassword = false,
      this.onEditingComplete,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.autoFocus = false,
      this.maxLength,
      this.hasShadow = true,
      this.isRequired = false}) {
    isPlaceHolderState = controller.text == null || controller.text.isEmpty;
    focusNode.addListener(focusNodeListener);
    controller.addListener(() {
      text.value = controller.text;
    });
  }

  void focusNodeListener() {
    setState(() {
      isPlaceHolderState = !focusNode.hasFocus &&
          (controller.text == null || controller.text.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 58,
        decoration: BoxDecoration(
            color: AppTheme.White,
            borderRadius: BorderRadius.circular(10),
            boxShadow: hasShadow ? [CustomBoxShadow()] : []),
        child: Stack(children: <Widget>[
          isPlaceHolderState
              ? AnimatedPositioned(
                  top: 20,
                  left: 16,
                  duration: Duration(milliseconds: 100),
                  child: Row(
                    children: [
                      Text(
                        placeHolder,
                        style: TextStyle(
                            fontSize: AppTheme.BodyFontSize15,
                            color: AppTheme.Opal,
                            fontWeight: FontWeight.w600),
                      ),
                      Visibility(
                          visible: isRequired,
                          child: Text(
                            "*",
                            style: TextStyle(
                                fontSize: AppTheme.BodyFontSize15,
                                color: AppTheme.Critical,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ))
              : AnimatedPositioned(
                  top: 12,
                  left: 16,
                  duration: Duration(milliseconds: 100),
                  child: Row(
                    children: [
                      Text(
                        placeHolder,
                        style: TextStyle(
                            fontSize: AppTheme.CaptionFontSize11,
                            color: AppTheme.Lilac,
                            fontWeight: FontWeight.w500),
                      ),
                      Visibility(
                          visible: isRequired,
                          child: Text(
                            "*",
                            style: TextStyle(
                                fontSize: AppTheme.CaptionFontSize11,
                                color: AppTheme.Lilac,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  )),
          Padding(
            padding: isPassword
                ? const EdgeInsets.only(top: 14, right: 40)
                : const EdgeInsets.only(top: 14),
            child: Center(
              child: Obx(
                () => TextField(
                  autofocus: autoFocus,
                  focusNode: focusNode,
                  controller: controller,
                  obscureText: !showingPassword.value && isPassword,
                  autocorrect: false,
                  maxLength: maxLength,
                  onEditingComplete: () => onEditingComplete,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15)),
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: textColor),
                ),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: text.value.isNotEmpty && isPassword,
              child: Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => showingPassword.value = !showingPassword.value,
                    child: Obx(
                      () => SvgPicture.asset(
                        showingPassword.value
                            ? 'eye'.toSvgPath()
                            : 'eyeOff'.toSvgPath(),
                        color: AppTheme.DarkJungleGreen,
                        width: 24,
                      ),
                    ),
                  )),
            ),
          )
        ]));
  }
}

class PassiveTextButton extends StatelessWidget {
  final String text;

  PassiveTextButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TextButton(
        onPressed: null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => AppTheme.PassiveButtonBackgroundColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTheme.BodyFontSize15,
                fontWeight: FontWeight.w600,
                color: AppTheme.PassiveButtonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveTextButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double fontSize;
  final double height;

  ActiveTextButton(this.text, this.onPressed,
      {this.fontSize = AppTheme.BodyFontSize15, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TextButton(
        onPressed: () => onPressed!.call(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => AppTheme.ActiveButtonBackgroundColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: AppTheme.ActiveButtonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveSecondaryTextButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double fontSize;
  final double height;

  ActiveSecondaryTextButton(this.text, this.onPressed,
      {this.fontSize = AppTheme.BodyFontSize15, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [CustomBoxShadow()]),
      child: TextButton(
        onPressed: () => onPressed!.call(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => AppTheme.White),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppTheme.Opal,
          ),
        ),
      ),
    );
  }
}

class BusyPageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.DarkJungleGreen.withOpacity(.5),
      child: Center(
          child: Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/dualBall.gif'))),
    );
  }
}

class ResultPopup extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? message;
  final String okText;
  final String? cancelText;
  final Function? okPressed;
  final Function? cancelPressed;
  final double? top;

  const ResultPopup(
      {Key? key,
      required this.icon,
      required this.title,
      required this.okText,
      this.message,
      this.cancelText,
      this.okPressed,
      this.cancelPressed,
      this.top})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Material(
          color: Colors.transparent,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: AppTheme.White, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, this.top ?? 0, 20, 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: icon,
                  ),
                  title == null || title.isEmpty
                      ? SizedBox(height: 0)
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppTheme.BodyFontSize15,
                              color: AppTheme.DarkJungleGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  message == null || message!.isEmpty
                      ? SizedBox(height: 0)
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            message ?? "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        cancelText == null || cancelText!.isEmpty
                            ? SizedBox(height: 0)
                            : Expanded(
                                child: ActiveSecondaryTextButton(
                                    cancelText ?? "", () {
                                Get.back();
                                if (cancelPressed != null) {
                                  cancelPressed!.call();
                                }
                              })),
                        SizedBox(
                            width: cancelText == null || cancelText!.isEmpty
                                ? 0
                                : 16),
                        Expanded(
                            child: ActiveTextButton(okText, () {
                          Get.back();
                          if (okPressed != null) {
                            okPressed!.call();
                          }
                        }))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class PickerWidget extends StatelessWidget {
  final SelectableListModel listModel;
  final bool isRequired;
  final bool isSearchable;

  PickerWidget(this.listModel,
      {Key? key, this.isRequired = false, this.isSearchable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppTheme.White,
        child: InkWell(
          onTap: listModel.isEmpty
              ? null
              : () async {
                  await showGeneralDialog(
                      barrierDismissible: true,
                      barrierColor: AppTheme.DarkJungleGreen.withOpacity(0.4),
                      barrierLabel: '',
                      transitionDuration: Duration(milliseconds: 400),
                      context: context,
                      pageBuilder: (context, animation1, animation2) =>
                          SizedBox.shrink(),
                      transitionBuilder: (context, a1, a2, widget) {
                        final curvedValue =
                            Curves.easeInOutCubic.transform(a1.value) - 1.0;
                        return Transform(
                          transform: Matrix4.translationValues(
                              0.0, curvedValue * -50, 0.0),
                          child: Opacity(
                              opacity: a1.value,
                              child: PickerPopup(listModel, isSearchable)),
                        );
                      });
                },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 37,
                      child: Stack(
                        children: [
                          Obx(() => listModel.selectedItem == null ||
                                  listModel.selectedItem?.value == null ||
                                  listModel.selectedItem?.value.item == null
                              ? AnimatedPositioned(
                                  top: 10,
                                  left: 16,
                                  duration: Duration(milliseconds: 100),
                                  child: Row(
                                    children: [
                                      Text(
                                        listModel.title,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: AppTheme.BodyFontSize15,
                                            color: AppTheme.DarkJungleGreen,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Visibility(
                                          visible: isRequired,
                                          child: Text(
                                            "*",
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize:
                                                    AppTheme.BodyFontSize15,
                                                color: AppTheme.Critical,
                                                fontWeight: FontWeight.w600),
                                          ))
                                    ],
                                  ))
                              : AnimatedPositioned(
                                  top: 0,
                                  left: 16,
                                  duration: Duration(milliseconds: 100),
                                  child: Row(
                                    children: [
                                      Text(
                                        listModel.title,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize:
                                                AppTheme.CaptionFontSize11,
                                            color: AppTheme.Lilac,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Visibility(
                                          visible: isRequired,
                                          child: Text(
                                            "*",
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize:
                                                    AppTheme.CaptionFontSize11,
                                                color: AppTheme.Lilac,
                                                fontWeight: FontWeight.w500),
                                          ))
                                    ],
                                  ))),
                          Positioned(
                              bottom: 1,
                              left: 16,
                              child: Obx(() => Text(
                                    listModel.selectedItem?.value.text ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: AppTheme.BodyFontSize15,
                                        color: AppTheme.DarkJungleGreen,
                                        fontWeight: FontWeight.w600),
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !listModel.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.DarkJungleGreen,
                    size: 32,
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

class PickerPopup extends StatefulWidget {
  final SelectableListModel listModel;
  final bool isSearchable;

  const PickerPopup(this.listModel, this.isSearchable, {Key? key})
      : super(key: key);

  @override
  _PickerPopupState createState() => _PickerPopupState();
}

class _PickerPopupState extends State<PickerPopup> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    textEditingController.addListener(updateState);
    super.initState();
  }

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final filteredItems = widget.listModel.items!
        .where((element) => (element == null
            ? false
            : element.detailedText == null
                ? element.text
                    .toLowerCase()
                    .contains(textEditingController.text.toLowerCase())
                : element.detailedText!
                    .toLowerCase()
                    .contains(textEditingController.text.toLowerCase())))
        .toList();
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Flexible(
        flex: 1,
        child: Container(),
      ),
      Flexible(
          flex: 6,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: AppTheme.White,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 60,
                          color: AppTheme.White,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                padding: const EdgeInsets.only(left: 16),
                                child: GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: AppTheme.BodyFontSize15,
                                        color: AppTheme.DarkJungleGreen
                                            .withOpacity(0.3),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.listModel.title,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: AppTheme.Body2FontSize18,
                                      color: AppTheme.DarkJungleGreen,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(width: 80),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Container(
                            height: 1,
                            color: AppTheme.GrayWeb,
                          ),
                        ),
                        widget.isSearchable
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: CustomInputForm(
                                    AppLocalizations.of(context)!.filter,
                                    textEditingController,
                                    FocusNode()),
                              )
                            : SizedBox.shrink(),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: height * 5 / 6 - 150),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            itemCount: filteredItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Material(
                                  color: AppTheme.White,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                      if (widget
                                              .listModel.selectedItem!.value !=
                                          filteredItems[index]) {
                                        widget.listModel.selectedItem!.value =
                                            filteredItems[index];
                                        if (widget.listModel.onValueChanged !=
                                            null) {
                                          widget.listModel.onValueChanged!(
                                              widget.listModel.selectedItem!
                                                  .value.item);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    filteredItems[index]
                                                            .detailedText ??
                                                        filteredItems[index]
                                                            .text,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        fontSize: AppTheme
                                                            .BodyFontSize15,
                                                        color: AppTheme
                                                            .DarkJungleGreen),
                                                  ),
                                                ),
                                                widget.listModel.selectedItem
                                                            ?.value ==
                                                        filteredItems[index]
                                                    ? Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: AppTheme
                                                                    .DarkJungleGreen,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: AppTheme
                                                                    .DarkJungleGreen,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            9)),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: AppTheme
                                                                    .DarkJungleGreen,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                      ),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: AppTheme.GrayWeb,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]))
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.removeListener(updateState);
    textEditingController.dispose();
  }
}

class BottomListTilePopup extends StatelessWidget {
  final List<ButtonModel> buttons;

  const BottomListTilePopup(this.buttons, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.MintCream,
                    borderRadius: BorderRadius.circular(25)),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Container(
                            height: 54,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                boxShadow: [CustomBoxShadow()],
                                color: AppTheme.White,
                                borderRadius: BorderRadius.circular(10)),
                            child: Material(
                              color: AppTheme.White,
                              child: InkWell(
                                onTap: () async {
                                  Get.back();
                                  buttons[index].onTapped();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        buttons[index].icon,
                                        SizedBox(
                                          width: 16,
                                        ),
                                        buttons[index].text,
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 11),
                    itemCount: buttons.length)),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
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
                          color: AppTheme.MintCream,
                          borderRadius: BorderRadius.circular(22)),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppTheme.DarkJungleGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageBoxButton extends StatelessWidget {
  final String iconData;
  final Color iconColor;
  final String text;
  final Function onTap;

  const ImageBoxButton(this.iconData, this.iconColor, this.text, this.onTap,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          boxShadow: [CustomBoxShadow()],
          color: AppTheme.GhostWhite,
          borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: AppTheme.White,
        child: InkWell(
          onTap: () => onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Row(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: iconColor.withOpacity(.15)),
                    child: Center(
                      child: SvgPicture.asset(
                        iconData,
                        color: iconColor,
                        width: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: AppTheme.Footnote2FontSize12,
                        color: AppTheme.DarkJungleGreen,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  @override
  Color get color => AppTheme.DarkJungleGreen.withOpacity(.1);
  @override
  double get blurRadius => 10;
  @override
  double get spreadRadius => 0;
  @override
  Offset get offset => Offset(0, 5);
}

class PageBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: 24,
        height: 24,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.back(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: SvgPicture.asset(
                  'left'.toSvgPath(),
                  color: AppTheme.Xiketic,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppTheme.HeaderFontSize26,
            fontWeight: FontWeight.bold,
            color: AppTheme.DarkJungleGreen,
          ),
        ),
      ),
    );
  }
}

class PageTitleWithBackButton extends StatelessWidget {
  final String title;

  const PageTitleWithBackButton(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71,
      padding: const EdgeInsets.only(left: 10, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              children: [
                PageBackButton(),
                SizedBox(width: 8),
                PageTitle(title: title)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShadowContainerWithWhiteBorder extends StatelessWidget {
  final double borderRadius;
  final Widget? child;
  final double? height;
  final double? width;

  const ShadowContainerWithWhiteBorder(
      {Key? key,
      required this.borderRadius,
      this.child,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppTheme.White,
          borderRadius: BorderRadius.circular(borderRadius + 2),
          boxShadow: [CustomBoxShadow()]),
      child: Container(
        margin: const EdgeInsets.all(2),
        height: height,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppTheme.GhostWhite,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: child,
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final double height;
  final String placeHolder;
  final FocusNode? focusNode;
  final void Function(String text)? onTextChanged;
  final void Function(String text)? onEditingCompleted;

  const SearchBar(
      {Key? key,
      required this.height,
      this.onTextChanged,
      this.onEditingCompleted,
      required this.placeHolder,
      this.focusNode})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller = TextEditingController();
  bool isClearButtonIsVisible = false;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    controller.addListener(() {
      if (controller.text.length > 0) {
        isClearButtonIsVisible = true;
      } else {
        isClearButtonIsVisible = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTextChanged != null) {
      controller.addListener(() {
        widget.onTextChanged!(controller.text);
      });
    }
    return ShadowContainerWithWhiteBorder(
      borderRadius: 10,
      height: widget.height,
      child: Center(
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: SvgPicture.asset(
                'search'.toSvgPath(),
                width: 24,
              ),
            ),
            TextField(
              controller: controller,
              autocorrect: false,
              focusNode: widget.focusNode,
              onEditingComplete: widget.onEditingCompleted == null
                  ? () => widget.focusNode?.unfocus()
                  : () {
                      widget.focusNode?.unfocus();
                      widget.onEditingCompleted!(controller.text);
                    },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontSize: AppTheme.BodyFontSize15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.DarkJungleGreen.withOpacity(0.3)),
                  counterText: '',
                  hintText: widget.placeHolder,
                  contentPadding: const EdgeInsets.only(left: 52, right: 16)),
              style: TextStyle(
                  fontSize: AppTheme.BodyFontSize15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.DarkJungleGreen),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: isClearButtonIsVisible
                    ? IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () => {
                              controller.text = "",
                              widget.onEditingCompleted!(controller.text)
                            },
                        icon: SvgPicture.asset(
                          'iconsBasicDeleteConsole'.toSvgPath(),
                        ))
                    : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String? message;
  final double height;
  final bool isSuccess;
  const InfoBox(
      {Key? key, required this.height, this.message, this.isSuccess = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              isSuccess ? AppTheme.Success.withOpacity(.15) : AppTheme.GrayWeb),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('info'.toSvgPath(),
              color: isSuccess
                  ? AppTheme.Success
                  : AppTheme.DarkJungleGreen.withOpacity(0.3),
              width: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message ?? "",
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontSize: AppTheme.CaptionFontSize11,
                  fontWeight: FontWeight.w500,
                  color: isSuccess
                      ? AppTheme.Success
                      : AppTheme.DarkJungleGreen.withOpacity(0.3)),
            ),
          )
        ],
      ),
    );
  }
}

class CustomerFieldTemplateSelector extends StatelessWidget {
  final CustomerFieldModel customerFieldModel;
  final FocusNode? focusNode;

  const CustomerFieldTemplateSelector(this.customerFieldModel,
      {this.focusNode, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (customerFieldModel.customerField.fieldType) {
      case CustomerFieldType.ComboBox:
        RxBool? isSelected = RxBool(
            customerFieldModel.textEditingController.text.isEmpty
                ? false
                : customerFieldModel.textEditingController.text.toLowerCase() ==
                        "true"
                    ? true
                    : false);
        changeValue() {
          if (isSelected.value == true) {
            isSelected.value = false;
            customerFieldModel.value = false;
            customerFieldModel.updateIsValid();
          } else {
            isSelected.value = true;
            customerFieldModel.value = true;
            customerFieldModel.updateIsValid();
          }
        }
        return Obx(() => GestureDetector(
              onTap: () {
                changeValue();
              },
              child: Container(
                height: 56,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: customerFieldModel.isValid.value
                        ? AppTheme.White
                        : AppTheme.Critical,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [CustomBoxShadow()]),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: AppTheme.White,
                      boxShadow: [CustomBoxShadow()]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              customerFieldModel.customerField.title!,
                              style: TextStyle(
                                  fontSize: AppTheme.BodyFontSize15,
                                  color: AppTheme.DarkJungleGreen,
                                  fontWeight: FontWeight.w600),
                            ),
                            Visibility(
                                visible: customerFieldModel
                                        .customerField.isRequired ??
                                    false,
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: AppTheme.BodyFontSize15,
                                      color: AppTheme.Critical,
                                      fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => isSelected.value
                                      ? Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: AppTheme.DarkJungleGreen,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: SvgPicture.asset(
                                              "checkThick".toSvgPath(),
                                              color: AppTheme.White),
                                        )
                                      : Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppTheme.DarkJungleGreen
                                                          .withOpacity(0.3),
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      case CustomerFieldType.Radio:
        customerFieldModel.itemSource.value.selectedItem?.listen((item) {
          customerFieldModel.updateIsValid();
        });
        return Obx(
          () => Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? AppTheme.White
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            height: 58,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: AppTheme.White,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [CustomBoxShadow()]),
              child: Row(
                children: [
                  Obx(() => PickerWidget(
                        customerFieldModel.itemSource.value,
                        isRequired:
                            customerFieldModel.customerField.isRequired ??
                                false,
                      )),
                ],
              ),
            ),
          ),
        );
      case CustomerFieldType.PhoneNumber:
        customerFieldModel.textEditingController.addListener(() {
          customerFieldModel.updateIsValid();
        });
        customerFieldModel.itemSource.value.selectedItem?.listen((item) {
          customerFieldModel.updateIsValid();
        });
        if (customerFieldModel.itemSource.value.selectedItem != null) {
          customerFieldModel.updateIsValid();
        }
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                  width: 115,
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: customerFieldModel.isValid.value
                          ? AppTheme.White
                          : AppTheme.Critical,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [CustomBoxShadow()]),
                  height: 58,
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: AppTheme.White,
                          boxShadow: [CustomBoxShadow()]),
                      child: Row(
                        children: [
                          Obx(() => PickerWidget(
                              customerFieldModel.itemSource.value,
                              isRequired: true,
                              isSearchable: true)),
                        ],
                      ))),
            ),
            SizedBox(
              width: 11,
            ),
            Expanded(
              child: Obx(
                () => Container(
                  height: 58,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: customerFieldModel.isValid.value
                          ? AppTheme.White
                          : AppTheme.Critical,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [CustomBoxShadow()]),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: AppTheme.White,
                        boxShadow: [CustomBoxShadow()]),
                    child: CustomInputForm(
                      customerFieldModel.customerField.title!,
                      customerFieldModel.textEditingController,
                      focusNode ?? FocusNode(),
                      keyboardType: TextInputType.number,
                      autoFocus: false,
                      hasShadow: false,
                      maxLength: 15,
                      isRequired:
                          customerFieldModel.customerField.isRequired ?? false,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      case CustomerFieldType.Email:
        customerFieldModel.textEditingController.addListener(() {
          customerFieldModel.updateIsValid();
        });
        return Obx(
          () => Container(
            height: 58,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? AppTheme.White
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.White,
                  boxShadow: [CustomBoxShadow()]),
              child: CustomInputForm(
                customerFieldModel.customerField.title!,
                customerFieldModel.textEditingController,
                focusNode ?? FocusNode(),
                keyboardType: TextInputType.emailAddress,
                autoFocus: false,
                hasShadow: false,
                isRequired:
                    customerFieldModel.customerField.isRequired ?? false,
              ),
            ),
          ),
        );
      case CustomerFieldType.CheckBox:
        RxBool? isSelected = RxBool(
            customerFieldModel.textEditingController.text.isEmpty
                ? false
                : customerFieldModel.textEditingController.text.toLowerCase() ==
                        "true"
                    ? true
                    : false);
        changeValue(bool val) {
          isSelected.value = val;
          customerFieldModel.value = val;
          customerFieldModel.updateIsValid();
        }
        return Obx(
          () => Container(
            height: 87,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? AppTheme.White
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppTheme.White,
                  boxShadow: [CustomBoxShadow()]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          customerFieldModel.customerField.title!,
                          style: TextStyle(
                              fontSize: AppTheme.BodyFontSize15,
                              color: AppTheme.DarkJungleGreen,
                              fontWeight: FontWeight.w600),
                        ),
                        Visibility(
                            visible:
                                customerFieldModel.customerField.isRequired ??
                                    false,
                            child: Text(
                              "*",
                              style: TextStyle(
                                  fontSize: AppTheme.BodyFontSize15,
                                  color: AppTheme.Critical,
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            changeValue(true);
                          },
                          child: Row(
                            children: [
                              Obx(
                                () => isSelected.value
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: AppTheme.DarkJungleGreen,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SvgPicture.asset(
                                            "checkThick".toSvgPath(),
                                            color: AppTheme.White),
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.DarkJungleGreen
                                                    .withOpacity(0.3),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                              ),
                              SizedBox(width: 11),
                              Text(
                                AppLocalizations.of(context)!.yes,
                                style: TextStyle(
                                    fontSize: AppTheme.BodyFontSize15,
                                    color: AppTheme.DarkJungleGreen,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 60),
                        GestureDetector(
                          onTap: () {
                            changeValue(false);
                          },
                          child: Row(
                            children: [
                              Obx(
                                () => isSelected.value
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.DarkJungleGreen
                                                    .withOpacity(0.3),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10)))
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: AppTheme.DarkJungleGreen,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SvgPicture.asset(
                                            "checkThick".toSvgPath(),
                                            color: AppTheme.White),
                                      ),
                              ),
                              SizedBox(width: 11),
                              Text(
                                AppLocalizations.of(context)!.no,
                                style: TextStyle(
                                    fontSize: AppTheme.BodyFontSize15,
                                    color: AppTheme.DarkJungleGreen,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case CustomerFieldType.Date:
        var isDateSelected = false.obs;
        var selectedDate = "".obs;
        var initialDate = DateTime(1970);
        if (customerFieldModel.textEditingController.text.isNotEmpty) {
          initialDate =
              DateTime.parse(customerFieldModel.textEditingController.text);
          selectedDate.value = DateFormat('yyyy.MM.dd').format(initialDate);
          isDateSelected.value = true;
        }
        Future<void> _selectDate(BuildContext context) async {
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2010));
          isDateSelected.value = picked != null;
          customerFieldModel.value = picked;
          customerFieldModel.updateIsValid();
          customerFieldModel.textEditingController.text = selectedDate.value =
              picked == null ? "" : DateFormat('dd/MM/yyyy').format(picked);
        }
        return Obx(
          () => Container(
            height: 58,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? AppTheme.White
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppTheme.White,
                  boxShadow: [CustomBoxShadow()]),
              child: Stack(
                children: [
                  Obx(() => AnimatedPositioned(
                      top: isDateSelected.value ? 12 : 20,
                      left: 16,
                      duration: Duration(milliseconds: 100),
                      child: Row(
                        children: [
                          Text(
                            customerFieldModel.customerField.title!,
                            style: TextStyle(
                                fontSize: isDateSelected.value ? 11 : 15,
                                color: isDateSelected.value
                                    ? AppTheme.Lilac
                                    : AppTheme.DarkJungleGreen,
                                fontWeight: isDateSelected.value
                                    ? FontWeight.w500
                                    : FontWeight.w600),
                          ),
                          Visibility(
                              visible:
                                  customerFieldModel.customerField.isRequired ??
                                      false,
                              child: Text(
                                "*",
                                style: TextStyle(
                                    fontSize: isDateSelected.value ? 11 : 15,
                                    color: isDateSelected.value
                                        ? AppTheme.Lilac
                                        : AppTheme.Critical,
                                    fontWeight: isDateSelected.value
                                        ? FontWeight.w500
                                        : FontWeight.w600),
                              ))
                        ],
                      ))),
                  Positioned(
                      left: 16,
                      top: 14,
                      bottom: 0,
                      child: Obx(
                        () => Center(
                          child: Text(
                            selectedDate.value,
                            style: TextStyle(
                                fontSize: AppTheme.BodyFontSize15,
                                color: AppTheme.DarkJungleGreen,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(color: Colors.transparent),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case CustomerFieldType.Complex:
        customerFieldModel.textEditingController.addListener(() {
          customerFieldModel.updateIsValid();
        });
        return Obx(
          () => Container(
            height: 151,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? Colors.white
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                  boxShadow: [CustomBoxShadow()]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        customerFieldModel.customerField.title!,
                        style: TextStyle(
                          fontSize: AppTheme.BodyFontSize15,
                          color: AppTheme.DarkJungleGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Visibility(
                          visible:
                              customerFieldModel.customerField.isRequired ??
                                  false,
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontSize: AppTheme.BodyFontSize15,
                              color: AppTheme.Critical,
                              fontWeight: FontWeight.w600,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.MintCream,
                    ),
                    child: Stack(
                      children: [
                        Visibility(
                          visible: customerFieldModel.isStar.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 14),
                            child: Text(
                              customerFieldModel.pickerTitle!,
                              style: TextStyle(
                                fontSize: AppTheme.BodyFontSize15,
                                color:
                                    AppTheme.DarkJungleGreen.withOpacity(0.3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          onChanged: (text) => text != null && text.isNotEmpty
                              ? customerFieldModel.isStar.value = false
                              : customerFieldModel.isStar.value = true,
                          controller: customerFieldModel.textEditingController,
                          keyboardType: TextInputType.multiline,
                          maxLength: 200,
                          maxLines: null,
                          focusNode: focusNode,
                          autocorrect: false,
                          autofocus: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: const EdgeInsets.only(
                                  left: 15, right: 18, bottom: 18, top: 18)),
                          style: TextStyle(
                              fontSize: AppTheme.BodyFontSize15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.DarkJungleGreen),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      case CustomerFieldType.ZipCode:
        customerFieldModel.textEditingController.addListener(() {
          customerFieldModel.updateIsValid();
        });
        return Obx(
          () => Container(
            height: 58,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? Colors.white
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                  boxShadow: [CustomBoxShadow()]),
              child: CustomInputForm(
                customerFieldModel.customerField.title!,
                customerFieldModel.textEditingController,
                FocusNode(),
                hasShadow: false,
                autoFocus: false,
                isRequired:
                    customerFieldModel.customerField.isRequired ?? false,
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ),
          ),
        );
      case CustomerFieldType.Text:
      default:
        customerFieldModel.textEditingController.addListener(() {
          customerFieldModel.updateIsValid();
        });
        return Obx(
          () => Container(
            height: 58,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                color: customerFieldModel.isValid.value
                    ? AppTheme.White
                    : AppTheme.Critical,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [CustomBoxShadow()]),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppTheme.White,
                  boxShadow: [CustomBoxShadow()]),
              child: CustomInputForm(
                customerFieldModel.customerField.title!,
                customerFieldModel.textEditingController,
                FocusNode(),
                hasShadow: false,
                autoFocus: false,
                isRequired:
                    customerFieldModel.customerField.isRequired ?? false,
              ),
            ),
          ),
        );
    }
  }
}

class CustomerFieldModel {
  RxInt maxLength = RxInt(0);
  var isStar = RxBool(true);
  var isValid = RxBool(false);
  final Function(dynamic)? valueChangedNotifier;
  final String? pickerTitle;
  final CustomerField customerField;
  final TextEditingController textEditingController = TextEditingController();
  late Rx<SelectableListModel> itemSource;
  dynamic value;
  void updateIsValid() {
    if ((!(customerField.isRequired ?? false)) &&
        customerField.fieldType != CustomerFieldType.Email) {
      isValid.value = true;
      return;
    }
    switch (customerField.fieldType) {
      case CustomerFieldType.ComboBox:
        isValid.value = value == true || value == false;
        break;
      case CustomerFieldType.Radio:
        isValid.value = itemSource.value.selectedItem?.value != null;
        break;
      case CustomerFieldType.PhoneNumber:
        if (itemSource.value.selectedItem?.value.item == "+90") {
          isValid.value = textEditingController.text.isNotEmpty &&
              textEditingController.text.length == 10 &&
              itemSource.value.selectedItem!.value != null;
        }
        break;
      case CustomerFieldType.Email:
        if (!customerField.isRequired! &&
            (textEditingController.text == null ||
                textEditingController.text.isEmpty)) {
          isValid.value = true;
        } else {
          isValid.value = textEditingController.text.isEmail;
        }
        break;
      case CustomerFieldType.CheckBox:
      case CustomerFieldType.Date:
        isValid.value = value != null;
        break;

      case CustomerFieldType.Complex:
        isValid.value = textEditingController.text.isNotEmpty;
        break;
      case CustomerFieldType.ZipCode:
        isValid.value = maxLength.value == null ||
            (textEditingController.text.isNotEmpty &&
                textEditingController.text.length == maxLength.value) ||
            textEditingController.text.isEmpty;

        break;
      case CustomerFieldType.Text:
      default:
        isValid.value = textEditingController.text.isNotEmpty;
        break;
    }
    if (valueChangedNotifier != null) {
      valueChangedNotifier!(value);
    }
  }

  CustomerFieldModel(this.customerField,
      {this.pickerTitle, this.valueChangedNotifier}) {
    itemSource = SelectableListModel(pickerTitle ?? customerField.title!,
            items: <SelectableItemModel>[],
            selectedItem: Rx<SelectableItemModel>(SelectableItemModel("", "")))
        .obs;
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DashedLine({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class CustomListViewContainer extends StatelessWidget {
  final int length;
  final int index;
  final Widget child;
  const CustomListViewContainer(this.length, this.index, this.child, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? Radius.circular(12) : Radius.zero,
                  topRight: index == 0 ? Radius.circular(12) : Radius.zero,
                  bottomLeft:
                      index == length - 1 ? Radius.circular(12) : Radius.zero,
                  bottomRight:
                      index == length - 1 ? Radius.circular(12) : Radius.zero),
              color: AppTheme.White,
              boxShadow: [CustomBoxShadow()]),
          child: Column(
            children: [
              child,
            ],
          ),
        ),
        Container(
            color: AppTheme.White,
            child: index == length - 1
                ? SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 1,
                    color: AppTheme.GrayWeb,
                  ))
      ],
    );
  }
}
