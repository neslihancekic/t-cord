import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/models/midi.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/themes.dart';

const double cellWidth = 40;
const double cellHeigth = 25;

class Cell extends StatelessWidget {
  final String? tag;
  final String? value;
  final int index;
  final double? width;
  final double? height;
  final double? radius;
  final Color? color;
  final Function? onTap;

  Cell({
    this.value,
    required this.index,
    this.color,
    this.width,
    this.height,
    this.radius,
    this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    CellController controller = Get.put(CellController(context), tag: tag);
    controller.width.value = width != null ? width! : 40;
    return InkWell(
      splashColor: AppTheme.MintCream,
      onTap: () {
        if (onTap != null) onTap!.call();
      },
      child: Container(
        width: width ?? cellWidth,
        height: height ?? cellHeigth,
        decoration: BoxDecoration(
          color: color,
          border: Border(
              top: BorderSide(
                color: Colors.black12,
                width: 1.0,
              ),
              bottom: BorderSide(
                color: Colors.black12,
                width: 1.0,
              ),
              left: BorderSide(
                color: index % 4 == 0 ? Colors.white : Colors.black12,
                width: 0.25,
              ),
              right: BorderSide(
                color: (index + 1) % 4 == 0 ? Colors.white : Colors.black12,
                width: 0.25,
              )),
        ),
        alignment: Alignment.bottomCenter,
        child: Text(
          value ?? '',
          style: TextStyle(
              fontSize: 11.0,
              color: color == Colors.black ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class CellController extends BaseGetxController {
  var width = 40.0.obs;
  CellController(BuildContext context) : super(context);
}

class ExpandableCells extends StatelessWidget {
  final String? value;
  final double? growthPer;
  final double? height;
  final double? radius;
  final Color? color;

  ExpandableCells(
      {this.value, this.color, this.height, this.radius, this.growthPer});

  @override
  Widget build(BuildContext context) {
    EditPageController editController = Get.find();

    ExpandableCellsController controller = Get.put(
        ExpandableCellsController(context, color, editController.midiModel));

    return Obx(() => Stack(children: [
          for (var noteInfo in controller.midiModel.value.notes!)
            Column(
              children: [
                SizedBox(
                  height: (108 - noteInfo.midiNote) * 15,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: noteInfo.startTick *
                                    growthPer! /
                                    controller.midiModel.value.resolution! <
                                0
                            ? 0
                            : noteInfo.startTick *
                                growthPer! /
                                controller.midiModel.value.resolution!),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        controller.verticalValue.value += details.delta.dy;
                        if (controller.verticalValue.value > 15) {
                          noteInfo.midiNote -= 1;
                          controller.verticalValue.value = 0;
                        }
                        if (controller.verticalValue.value < -15) {
                          noteInfo.midiNote += 1;
                          controller.verticalValue.value = 0;
                        }
                        editController.changeMidi(controller.midiModel.value);
                      },
                      onLongPress: () {
                        controller.midiModel.value.notes!.remove(noteInfo);
                        editController.changeMidi(controller.midiModel.value);
                      },
                      child: Container(
                        width: noteInfo.durationTick *
                            growthPer! /
                            controller.midiModel.value.resolution!,
                        height: height ?? cellHeigth,
                        decoration: BoxDecoration(
                          color: controller.color.value,
                          borderRadius: BorderRadius.circular(radius ?? 0),
                          border: Border.all(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  noteInfo.durationTick -= (details.delta.dx *
                                          controller
                                              .midiModel.value.resolution! /
                                          growthPer!)
                                      .round();
                                  noteInfo.startTick += (details.delta.dx *
                                          controller
                                              .midiModel.value.resolution! /
                                          growthPer!)
                                      .round();
                                  if (noteInfo.durationTick *
                                              growthPer! /
                                              controller
                                                  .midiModel.value.resolution! <
                                          0 ||
                                      noteInfo.durationTick < 0) {
                                    return;
                                  }
                                  editController
                                      .changeMidi(controller.midiModel.value);
                                },
                                child: Container(
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.circular(radius ?? 0),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    noteInfo.durationTick += (details.delta.dx *
                                            controller
                                                .midiModel.value.resolution! /
                                            growthPer!)
                                        .round();
                                    if (noteInfo.durationTick *
                                                growthPer! /
                                                controller.midiModel.value
                                                    .resolution! <
                                            0 ||
                                        noteInfo.durationTick < 0) {
                                      return;
                                    }
                                    editController
                                        .changeMidi(controller.midiModel.value);
                                  },
                                  child: Container(
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.circular(radius ?? 0),
                                    ),
                                  ),
                                )),
                            Text(
                              value ?? '',
                              style: TextStyle(
                                  fontSize: 11.0,
                                  color: color == Colors.black
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ]));
  }
}

class ExpandableCellsController extends BaseGetxController {
  var color = Color(00000).obs;
  var midiModel = MidiModel(null, null, null, null, null).obs;
  var verticalValue = 0.0.obs;
  ExpandableCellsController(BuildContext context, c, midi) : super(context) {
    color.value = c;
    midiModel = midi;
  }
}
