import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/views/addTrack/addTrack.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetTitlePopup extends StatelessWidget {
  const SetTitlePopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddTrackPageController controller = Get.find();
    final node = FocusScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 220,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: AppTheme.GhostWhite,
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: CustomInputForm("Title", controller.titleController,
                        controller.titleFocusNode,
                        isRequired: true,
                        onEditingComplete: () => node.nextFocus(),
                        textInputAction: TextInputAction.next),
                  ),
                ),
                SizedBox(height: 11),
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: CustomInputForm("Info", controller.infoController,
                        controller.infoFocusNode,
                        onEditingComplete: () => node.nextFocus(),
                        textInputAction: TextInputAction.next),
                  ),
                ),
                SizedBox(height: 11),
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        Get.back();
                        await controller.send();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done_outline_rounded,
                                  size: 30, color: AppTheme.Critical),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Confirm",
                                style: TextStyle(
                                    color: AppTheme.DarkJungleGreen,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
