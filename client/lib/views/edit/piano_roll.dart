import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:tcord/models/midi.dart';
import 'package:tcord/views/animation/slide_animation.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/base.dart';

import 'timeline.dart';
import 'midi_viewer.dart';

class PianoRoll extends StatelessWidget {
  PianoRoll();
  @override
  Widget build(BuildContext context) {
    PianoRollController controller = Get.put(PianoRollController(context));
    return Column(
      children: [
        TimeLine(scrollController: controller._headController!),
        Expanded(
          child: MidiViewer(scrollController: controller._bodyController!),
        ),
      ],
    );
  }
}

class PianoRollController extends BaseGetxController {
  LinkedScrollControllerGroup? _controllers;
  ScrollController? _headController;
  ScrollController? _bodyController;
  PianoRollController(BuildContext context) : super(context);

  @override
  void onInit() {
    super.onInit();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers?.addAndGet();
    _bodyController = _controllers?.addAndGet();
  }

  @override
  void dispose() {
    _headController?.dispose();
    _bodyController?.dispose();
    super.dispose();
  }
}
