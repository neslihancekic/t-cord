import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/views/edit/edit.dart';

/// This is the stateful widget that the main application instantiates.
class SlideAnimation extends StatefulWidget {
  final Widget child;
  const SlideAnimation(
    this.child, {
    Key? key,
  }) : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

/// This is the private State class that goes with SlideAnimation.
class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  double offset = 50.0;
  int microSeconds = 0;
  late AnimationController _controller = AnimationController(
    duration: Duration(microseconds: microSeconds),
    vsync: this,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditPageController editController = Get.find();
    offset = (editController.currentValue.value *
        ((editController.midiModel.value.endTick! / 960).ceil() +
            (editController.midiModel.value.endTick! / 960).ceil() % 4));
    microSeconds = editController.tickToMicroseconds(
        960 *
            ((editController.midiModel.value.endTick! / 960).ceil() +
                (editController.midiModel.value.endTick! / 960).ceil() % 4),
        editController.midiModel.value.resolution!,
        editController.midiModel.value.tempo!);
    editController.currentValue.listen((p) {
      setState(() {
        offset = (p *
            ((editController.midiModel.value.endTick! / 960).ceil() +
                (editController.midiModel.value.endTick! / 960).ceil() % 4));
      });
    });
    editController.midiModel.listen((p) {
      setState(() {
        offset = (editController.currentValue.value *
            ((p.endTick! / 960).ceil() + (p.endTick! / 960).ceil() % 4));
      });
      setState(() {
        microSeconds = editController.tickToMicroseconds(
            960 * ((p.endTick! / 960).ceil() + (p.endTick! / 960).ceil() % 4),
            p.resolution!,
            p.tempo!);
      });
    });
    editController.isInit.listen((p) {
      if (p) _controller.reset();
      _controller.duration = Duration(microseconds: microSeconds);
    });
    editController.isPlaying.listen((p) {
      _controller.duration = Duration(microseconds: microSeconds);
      if (p) _controller.forward();
    });
    editController.isPaused.listen((p) {
      if (p) _controller.stop();
      _controller.duration = Duration(microseconds: microSeconds);
    });
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(offset / 2, 0.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      )),
      child: widget.child,
    );
  }
}
