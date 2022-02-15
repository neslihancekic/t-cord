import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcord/views/composition/feed.dart';
import 'package:tcord/views/home/home.dart';

/// This is the stateful widget that the main application instantiates.
class ProgressAnimation extends StatefulWidget {
  final Widget child;
  const ProgressAnimation(
    this.child, {
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressAnimation> createState() => _ProgressAnimationState();
}

/// This is the private State class that goes with ProgressAnimation.
class _ProgressAnimationState extends State<ProgressAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) _controller.reset();
    });

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePageController homeController = Get.find();
    homeController.duration.listen((p) {
      _controller.duration = Duration(microseconds: p.toInt());
    });
    homeController.isPlaying.listen((p) {
      if (p) {
        _controller.forward();
      } else {
        _controller.stop();
      }
    });
    homeController.isComplete.listen((p) {
      if (p) {
        _controller.reset();
      }
    });

    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: widget.child,
    );
  }
}
