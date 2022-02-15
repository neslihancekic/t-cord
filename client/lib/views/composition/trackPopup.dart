import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackPopup extends StatelessWidget {
  final CompositionModel composition;

  const TrackPopup({Key? key, required this.composition}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CompositionService _compositionService = Get.find();
    return Material(
        color: Colors.white.withOpacity(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SingleChildScrollView(
                  child: Container(
                      height: 300,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          color: AppTheme.GhostWhite,
                          borderRadius: BorderRadius.circular(25)),
                      child: ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: composition.tracks!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final path = directory.path;
                                    final file = File('$path/detected.csv');
                                    final _uploadService =
                                        Get.put(UploadService());
                                    var csv = await _uploadService.downloadFile(
                                        composition.tracks![index].csv!);
                                    await file.writeAsString(csv!);
                                    Get.to(() => EditPage(
                                        csvFile: file.path,
                                        track: composition.tracks![index],
                                        isEditable: false));
                                  },
                                  child: Container(
                                      height: 54,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          boxShadow: [CustomBoxShadow()],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Track " +
                                                      (index + 1).toString(),
                                                  style: TextStyle(
                                                      color: AppTheme.Opal,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "by " +
                                                      (composition
                                                              .tracks![index]
                                                              .username ??
                                                          ""),
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .DarkJungleGreen,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ]))),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }))),
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
        ));
  }
}
/* final directory =
                                              await getApplicationDocumentsDirectory();
                                          final path = directory.path;
                                          final file =
                                              File('$path/detected.csv');
                                          final _uploadService =
                                              Get.put(UploadService());
                                          var csv = await _uploadService
                                              .downloadFile(controller
                                                  .compositions[index].csv!);
                                          await file.writeAsString(csv!);
                                          Get.to(() => EditPage(
                                              csvFile: file.path,
                                              track: controller
                                                  .compositions[index]
                                                  .tracks!
                                                  .first,
                                              isEditable: false));*/