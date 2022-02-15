import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/base.dart';

import 'cell.dart';
import 'constants.dart';

class TimeLine extends StatelessWidget {
  final ScrollController scrollController;

  TimeLine({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    EditPageController editController = Get.find();
    TimeLineController controller = Get.put(TimeLineController(context));
    return SizedBox(
      height: 15,
      child: Row(
        children: [
          Cell(
            color: Colors.yellow.withOpacity(0.3),
            width: 40 + 20,
            index: 1,
            height: 15,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  ((editController.midiModel.value.endTick! / 960).ceil() +
                      (editController.midiModel.value.endTick! / 960).ceil() %
                          4), (index) {
                return Obx(() => Cell(
                      index: index,
                      tag: "resizable",
                      width: controller.cwidth.value,
                      color: Colors.yellow.withOpacity(0.3),
                      value: index.toString(),
                      height: 15,
                    ));
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeLineController extends BaseGetxController {
  var cwidth = 50.0.obs;
  TimeLineController(BuildContext context) : super(context) {
    EditPageController controller = Get.find();
    controller.currentValue.listen((p0) {
      cwidth.value = p0;
    });
  }
}
