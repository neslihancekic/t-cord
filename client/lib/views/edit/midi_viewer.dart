import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:tcord/models/midi.dart';
import 'package:tcord/views/animation/slide_animation.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/themes.dart';

import 'cell.dart';
import 'constants.dart';

class MidiViewer extends StatelessWidget {
  final ScrollController scrollController;

  MidiViewer({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    MidiViewerController controller = Get.put(MidiViewerController(context));

    EditPageController editController = Get.find();
    controller.midiModel.value = editController.midiModel.value;
    return Row(
      children: [
        SizedBox(
            width: cellWidth + 20,
            child: ListView(
                controller: controller._firstColumnController,
                primary: false,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  Stack(
                    children: [
                      Column(
                        children: List.generate(maxNumber, (index) {
                          if (!blackKeys.contains(108 - index)) {
                            return Cell(
                                index: 1,
                                tag: "white",
                                color: Colors.white,
                                width: cellWidth + 20,
                                height: index != 0 ? 25.7 : 15,
                                value: (108 - index) % 12 == 0
                                    ? "C" +
                                        (((108 - index) / 12) - 1)
                                            .toInt()
                                            .toString()
                                    : null,
                                onTap: () async {
                                  editController.play(108 - index);
                                  await Future.delayed(
                                      Duration(microseconds: 200));
                                  editController.stop(108 - index);
                                });
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                      ),
                      Column(
                        children: List.generate(maxNumber, (index) {
                          if (!blackKeys.contains(108 - index) &&
                              !blackKeys.contains(108 - index - 1)) {
                            return SizedBox(height: 15);
                          }
                          if (blackKeys.contains(108 - index)) {
                            return Cell(
                                index: 1,
                                tag: "black",
                                color: Colors.black,
                                width: cellWidth,
                                height: 15,
                                onTap: () async {
                                  editController.play(108 - index);
                                  await Future.delayed(
                                      Duration(microseconds: 200));
                                  editController.stop(108 - index);
                                });
                          } else {
                            return SizedBox(height: 15);
                          }
                        }),
                      ),
                    ],
                  ),
                ])),
        Obx(() => Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width:
                      ((editController.midiModel.value.endTick! / 960).ceil() +
                              (editController.midiModel.value.endTick! / 960)
                                      .ceil() %
                                  4) *
                          controller.cwidth.value,
                  child: ListView(
                      primary: false,
                      controller: controller._restColumnsController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        Stack(children: [
                          Column(
                              children: List.generate(maxNumber, (y) {
                            return Row(
                                children: List.generate(
                                    ((editController.midiModel.value.endTick! /
                                                960)
                                            .ceil() +
                                        (editController.midiModel.value
                                                        .endTick! /
                                                    960)
                                                .ceil() %
                                            4), (x) {
                              return Cell(
                                  index: x,
                                  tag: "resizable",
                                  height: 15,
                                  width: controller.cwidth.value,
                                  color: blackKeys.contains(108 - y)
                                      ? Colors.black.withOpacity(0.87)
                                      : Colors.black.withOpacity(0.64),
                                  onTap: () {
                                    editController.midiModel.value.notes!.add(
                                        Note(
                                            108 - y,
                                            x *
                                                    controller.midiModel.value
                                                        .resolution! +
                                                ((x / 4).floor() * 2),
                                            controller
                                                .midiModel.value.resolution!));
                                    editController.midiModel.refresh();
                                  });
                            }));
                          })),
                          ExpandableCells(
                              growthPer: controller.cwidth.value,
                              radius: 5,
                              height: 15,
                              color: AppTheme.Success),
                          SlideAnimation(
                            Container(
                                height: 89 * 15, width: 2, color: Colors.red),
                          ),
                        ])
                      ]),
                ),
              ),
            )),
      ],
    );
  }
}

class MidiViewerController extends BaseGetxController {
  LinkedScrollControllerGroup? _controllers;
  ScrollController? _firstColumnController;
  ScrollController? _restColumnsController;
  var midiModel = MidiModel(null, null, null, null, null).obs;

  var cwidth = 50.0.obs;

  MidiViewerController(BuildContext context) : super(context) {
    EditPageController controller = Get.find();
    controller.currentValue.listen((p0) {
      cwidth.value = p0;
    });
  }

  @override
  void onInit() {
    super.onInit();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers?.addAndGet();
    _restColumnsController = _controllers?.addAndGet();
    Timer(
        Duration(seconds: 1),
        () => _firstColumnController?.animateTo(
              (_firstColumnController?.position.maxScrollExtent ?? 0) / 2,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            ));
  }

  @override
  void dispose() {
    _firstColumnController?.dispose();
    _restColumnsController?.dispose();
    super.dispose();
  }
}
