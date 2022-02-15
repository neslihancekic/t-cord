import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcord/main.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter/animation.dart';
import 'package:tcord/views/record/setTitlePopup.dart';

// ignore: must_be_immutable
class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecordPageController controller = Get.put(RecordPageController(context));
    return Scaffold(
        backgroundColor: AppTheme.MintCream,
        body: Stack(
          children: [
            SafeArea(
                child: Obx(
              () => Stack(
                children: [
                  Positioned(
                      left: MediaQuery.of(context).size.width / 10,
                      top: 40.0,
                      child: CustomPaint(
                          painter: CirclePainter(
                            controller._animationController,
                            color: AppTheme.Lilac,
                          ),
                          child: SizedBox(
                              width: 80 * 4.125,
                              height: 80 * 4.125,
                              child: InkWell(
                                onTap: () async => await controller.record(),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: <Color>[
                                              AppTheme.Lilac,
                                              Color.lerp(AppTheme.Lilac,
                                                  Colors.black, .05)!
                                            ],
                                          ),
                                        ),
                                        child: ScaleTransition(
                                          scale: Tween(begin: 0.95, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: controller
                                                  ._animationController,
                                              curve: const CurveWave(),
                                            ),
                                          ),
                                          child: controller.isRecording.value
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      30.0),
                                                  child: SvgPicture.asset(
                                                    'stop'.toSvgPath(),
                                                    color: AppTheme.MintCream,
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      30.0),
                                                  child: SvgPicture.asset(
                                                    'mic'.toSvgPath(),
                                                    height: 50,
                                                    color: AppTheme.MintCream,
                                                  )),
                                        )),
                                  ),
                                ),
                              )))),
                  Positioned(
                      left: 100.0,
                      top: 380,
                      child: InkWell(
                        child: Container(
                            width: MediaQuery.of(context).size.width - 130,
                            child: CupertinoSlider(
                              thumbColor: AppTheme.GhostWhite,
                              activeColor: AppTheme.DarkJungleGreen,
                              value: controller._currentValue.value,
                              min: 0,
                              max: controller._duration.value,
                              divisions: controller._duration.toInt(),
                              onChanged: (selectedValue) async {
                                await controller.player.seekToPlayer(Duration(
                                    milliseconds: selectedValue.toInt()));
                                controller._currentValue.value = selectedValue;
                              },
                            )),
                      )),
                  Positioned(
                      left: 30.0,
                      top: 380,
                      child: InkWell(
                        onTap: () async => await controller.play(),
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: controller.isPlaying.value
                                    ? AppTheme.Lilac
                                    : AppTheme.Opal,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [CustomBoxShadow()]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: controller.isPlaying.value
                                  ? SvgPicture.asset(
                                      'pause'.toSvgPath(),
                                      width: 10,
                                      color: AppTheme.MintCream,
                                    )
                                  : SvgPicture.asset(
                                      'play'.toSvgPath(),
                                      width: 20,
                                      color: AppTheme.MintCream,
                                    ),
                            )),
                      )),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2.5,
                      top: MediaQuery.of(context).size.height / 1.5,
                      child: InkWell(
                        onTap: () async {
                          showGeneralDialog(
                            barrierDismissible: true,
                            barrierColor:
                                AppTheme.DarkJungleGreen.withOpacity(0.4),
                            barrierLabel: '',
                            transitionDuration: Duration(milliseconds: 400),
                            context: context,
                            pageBuilder: (context, animation1, animation2) =>
                                SizedBox.shrink(),
                            transitionBuilder: (context, a1, a2, widget) {
                              final curvedValue =
                                  Curves.easeInOutCubic.transform(a1.value) -
                                      1.0;
                              return Transform(
                                transform: Matrix4.translationValues(
                                    0.0, curvedValue * -50, 0.0),
                                child: Opacity(
                                  opacity: a1.value,
                                  child: SetTitlePopup(),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: controller.isPlaying.value
                                    ? AppTheme.Lilac
                                    : AppTheme.Opal,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [CustomBoxShadow()]),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SvgPicture.asset(
                                'checkCircle'.toSvgPath(),
                                color: AppTheme.White,
                              ),
                            )),
                      )),
                ],
              ),
            )),
            Obx(() => Visibility(
                  visible: controller.isBusy.value,
                  child: BusyPageIndicator(),
                ))
          ],
        ));
  }
}

class RecordPageController extends BaseGetxController
    with SingleGetTickerProviderMixin {
  late FlutterSoundRecorder recorder;
  var isInitRecorder = false;
  var isInitPlayer = false;
  late FlutterSoundPlayer player;
  var path;
  var isRecording = false.obs;
  var isPlaying = false.obs;
  var _currentValue = 0.0.obs;
  var _duration = 1.0.obs;

  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();

  final infoController = TextEditingController();
  final infoFocusNode = FocusNode();

  late AnimationController _animationController;
  final UploadService _uploadService = Get.find();
  final CompositionService _compositionService = Get.find();

  RecordPageController(BuildContext context) : super(context) {
    recorder = new FlutterSoundRecorder();
    player = new FlutterSoundPlayer();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  Future record() async {
    if (isRecording.value) {
      //stop recording
      _animationController.reset();
      await recorder.stopRecorder();
      isRecording.value = false;
    } else {
      //record
      if (!isInitRecorder) {
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }
        await recorder.openAudioSession();
        var tempDir = await getTemporaryDirectory();
        path = '${tempDir.path}/flutter_sound.wav';
        isInitRecorder = true;
      }

      _animationController.repeat();
      await recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
      isRecording.value = true;
    }
  }

  Future play() async {
    if (isRecording.value) return;
    if (isPlaying.value) {
      //stop playing
      if (player != null) {
        await player.pausePlayer();
      }
      isPlaying.value = false;
    } else {
      //play
      if (!isInitPlayer) {
        await player.openAudioSession();
        player.setSubscriptionDuration(Duration(milliseconds: 100));
        player.onProgress!.listen((e) {
          if (e != null) {
            _currentValue.value = e.position.inMilliseconds.toDouble();
            _duration.value = e.duration.inMilliseconds.toDouble();
            DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                e.duration.inMilliseconds);
            String txt = DateFormat("mm:ss:SS’", "en_US").format(date);
            isPlaying.value = true;
            //_playerTxt = txt.substring(0, 8);
          }
        });
        var tempDir = await getTemporaryDirectory();
        path = '${tempDir.path}/flutter_sound.wav';
        isInitPlayer = true;
      }
      if (player.isPaused) {
        await player.resumePlayer();
      } else {
        await player.startPlayer(
            fromURI: path,
            codec: Codec.mp3,
            whenFinished: () {
              _currentValue.value = 0;
              isPlaying.value = false;
            });
      }
    }
  }

  Future send() async {
    if (isRecording.value) return;
    isBusy.value = true;
    var data = await _uploadService.transcribe(path);
    if (data == null) {
      isBusy.value = false;
      return;
    }
    var track = await _compositionService.createTrack(TrackModel(
        ownerUserId: authenticationService.authenticationData!.user!.id,
        username: authenticationService.authenticationData!.user!.username,
        midi: data.midi,
        csv: data.csv,
        audio: data.url,
        sheetMusic: data.sheetMusic));
    var composition = await _compositionService.createComposition(
        CompositionModel(
            originOwnerUserId:
                authenticationService.authenticationData!.user!.id,
            ownerUserId: authenticationService.authenticationData!.user!.id,
            title: titleController.text,
            info: infoController.text,
            username: authenticationService.authenticationData!.user!.username,
            midi: data.midi,
            csv: data.csv,
            audio: data.url,
            sheetMusic: data.sheetMusic,
            tracks: [track]));
    var csv = await _uploadService.downloadFile(composition.csv!);
    var csvFile = await writeCsv(csv!);
    Get.to(() => EditPage(csvFile: csvFile.path, track: track));
    isBusy.value = false;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/detected.csv');
  }

  Future<File> writeCsv(String csv) async {
    final file = await _localFile;
    return file.writeAsString(csv);
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    recorder.closeAudioSession();
    player.closeAudioSession();
    super.dispose();
  }
}

class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
