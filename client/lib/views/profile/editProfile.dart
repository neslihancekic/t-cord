import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/models/generic/button_model.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/views/animation/fade_animation.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatelessWidget {
  final Function successCommand;

  const EditProfilePage(this.successCommand, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EditProfilePageController controller =
        Get.put(EditProfilePageController(context, successCommand));
    AuthenticationData authenticationData =
        controller.authenticationService.authenticationData!;
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/png/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        1.8,
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                  onTap: () => showGeneralDialog(
                                      barrierDismissible: true,
                                      barrierColor:
                                          AppTheme.GrayWeb.withOpacity(0.4),
                                      barrierLabel: '',
                                      transitionDuration:
                                          Duration(milliseconds: 400),
                                      context: context,
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              SizedBox.shrink(),
                                      transitionBuilder:
                                          (context, a1, a2, widget) {
                                        final curvedValue = Curves
                                                .easeInOutCubic
                                                .transform(a1.value) -
                                            1.0;
                                        return Transform(
                                          transform: Matrix4.translationValues(
                                              0.0, curvedValue * -50, 0.0),
                                          child: Opacity(
                                              opacity: a1.value,
                                              child: BottomListTilePopup([
                                                ButtonModel(
                                                    Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.GrayWeb,
                                                          fontSize: AppTheme
                                                              .BodyFontSize15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        color: AppTheme.Lilac),
                                                    () => controller
                                                        .onCameraPressed(
                                                            ImageSource
                                                                .camera)),
                                                ButtonModel(
                                                    Text(
                                                      "Gallery",
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.GrayWeb,
                                                          fontSize: AppTheme
                                                              .BodyFontSize15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Icon(Icons.filter,
                                                        color: AppTheme.Opal),
                                                    () => controller
                                                        .onCameraPressed(
                                                            ImageSource
                                                                .gallery))
                                              ])),
                                        );
                                      }),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: AppTheme.Opal,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Obx(
                                      () => controller.isImageSelected.value
                                          ? Image.file(
                                              controller.selectedFile.value)
                                          : (authenticationData
                                                      .user?.profilePhoto !=
                                                  null)
                                              ? CachedNetworkImage(
                                                  imageUrl: authenticationData
                                                      .user!.profilePhoto!,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              child: Image.asset(
                                                                  'assets/images/loading.gif'))),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(
                                                    Icons.error_outline,
                                                    size: 30,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : authenticationData
                                                          .user!.profilePhoto ==
                                                      null
                                                  ? Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27)),
                                                      child: new Icon(
                                                        Icons.person,
                                                        size: 30,
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        authenticationData.user!
                                                            .profilePhoto!,
                                                      ),
                                                    ),
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 21, bottom: 7.5),
                                child: CustomInputForm(
                                    AppLocalizations.of(context)!.firstName,
                                    controller.firstNameController,
                                    controller.firstNameFocusNode,
                                    onEditingComplete: () => node.nextFocus(),
                                    textInputAction: TextInputAction.next),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.5, bottom: 7.5),
                                child: CustomInputForm(
                                    AppLocalizations.of(context)!.lastName,
                                    controller.lastNameController,
                                    controller.lastNameFocusNode,
                                    onEditingComplete: () => node.nextFocus(),
                                    textInputAction: TextInputAction.next),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.5, bottom: 7.5),
                                child: CustomInputForm(
                                    AppLocalizations.of(context)!.userName,
                                    controller.userNameController,
                                    controller.userNameFocusNode,
                                    onEditingComplete: () => node.nextFocus(),
                                    textInputAction: TextInputAction.next),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7.5, bottom: 7.5),
                                  child: CustomInputForm(
                                      AppLocalizations.of(context)!.email,
                                      controller.emailController,
                                      controller.emailFocusNode,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next)),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.5, bottom: 7.5),
                                child: CustomInputForm(
                                    "Bio",
                                    controller.bioController,
                                    controller.bioFocusNode,
                                    onEditingComplete: () => node.nextFocus(),
                                    textInputAction: TextInputAction.next),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2,
                          InkWell(
                            onTap: () => controller.onEdit(context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    AppTheme.Lilac,
                                    AppTheme.Opal,
                                  ])),
                              child: Center(
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: controller.isBusy.value,
              child: BusyPageIndicator(),
            ))
      ]),
    );
  }
}

class EditProfilePageController extends BaseGetxController {
  final Function successCommand;

  var isImageSelected = false.obs;
  var selectedFile = File("").obs;

  final UserService _userService = Get.find();
  final UploadService _uploadService = Get.find();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final bioController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final bioFocusNode = FocusNode();

  EditProfilePageController(BuildContext context, this.successCommand)
      : super(context) {
    firstNameController.text =
        authenticationService.authenticationData!.user!.firstName!;
    lastNameController.text =
        authenticationService.authenticationData!.user!.lastName!;
    emailController.text =
        authenticationService.authenticationData!.user!.email!;
    userNameController.text =
        authenticationService.authenticationData!.user!.username!;
    firstNameController.text =
        authenticationService.authenticationData!.user!.firstName!;
    bioController.text =
        authenticationService.authenticationData!.user!.profileInfo ?? "";
  }
  onCameraPressed(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
        source: imageSource, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      isBusy.value = true;
      File? cropped = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 500,
          maxHeight: 500,
          compressQuality: 50,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: AppTheme.White, toolbarTitle: "Crop"));
      isBusy.value = false;
      if (cropped != null) {
        selectedFile.value = cropped;
        isImageSelected.value = true;
      }
    }
  }

  Future<String?> uploadPhoto() async {
    isBusy.value = true;
    var result = await _uploadService.postImg(selectedFile.value.path);
    isBusy.value = false;
    return result;
  }

  onEdit(BuildContext context) async {
    if (firstNameFocusNode.hasFocus) firstNameFocusNode.unfocus();
    if (lastNameFocusNode.hasFocus) lastNameFocusNode.unfocus();
    if (emailFocusNode.hasFocus) emailFocusNode.unfocus();
    if (userNameFocusNode.hasFocus) userNameFocusNode.unfocus();
    if (bioFocusNode.hasFocus) bioFocusNode.unfocus();
    String? photoLink;
    isBusy.value = true;
    if (selectedFile.value.path.isNotEmpty) {
      photoLink = await uploadPhoto();
    }
    var request = new UserModel(
        firstName: firstNameController.text !=
                authenticationService.authenticationData!.user!.firstName!
            ? firstNameController.text
            : null,
        lastName: lastNameController.text !=
                authenticationService.authenticationData!.user!.lastName!
            ? lastNameController.text
            : null,
        username: userNameController.text !=
                authenticationService.authenticationData!.user!.username!
            ? userNameController.text
            : null,
        email: emailController.text !=
                authenticationService.authenticationData!.user!.email!
            ? emailController.text
            : null,
        profileInfo: bioController.text !=
                authenticationService.authenticationData!.user!.profileInfo
            ? bioController.text
            : null,
        profilePhoto: photoLink != null ? photoLink : null);
    var response = await _userService.editProfile(request);
    isBusy.value = false;
    if (response != null) {
      authenticationService.authenticationData!.user = response;
      Get.back();
      successCommand.call();
      await showCustomGeneralDialog(
          context,
          Icon(
            Icons.check_circle,
            size: 100,
            color: AppTheme.Success,
          ),
          "Your account has been edited!",
          AppLocalizations.of(context)!.okayUpper);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
