import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
import 'package:tcord/views/addTrack/setTitlePopup.dart';
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

// ignore: must_be_immutable
class AddTrackPage extends StatelessWidget {
  final CompositionModel composition;

  const AddTrackPage({Key? key, required this.composition}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddTrackPageController controller =
        Get.put(AddTrackPageController(context, composition));
    return Scaffold(
        backgroundColor: AppTheme.MintCream,
        body: Stack(
          children: [
            SafeArea(
                child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 50),
                  Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width,
                      color: AppTheme.MuntbattenPink,
                      child: InkWell(
                        onTap: () async => await controller.playComposition(),
                        child: Obx(
                          () => controller.isPlayingComposition.value
                              ? Icon(Icons.pause_circle_outline_rounded,
                                  size: 80, color: AppTheme.Xiketic)
                              : Icon(Icons.play_circle_outline_rounded,
                                  size: 80, color: AppTheme.Xiketic),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width,
                      color: AppTheme.Xiketic,
                      child: InkWell(
                        onTap: () async => await controller.playRecord(),
                        child: Obx(
                          () => controller.isPlayingRecord.value
                              ? Icon(Icons.pause_circle_outline_rounded,
                                  size: 80, color: AppTheme.Lilac)
                              : Icon(Icons.play_circle_outline_rounded,
                                  size: 80, color: AppTheme.Lilac),
                        ),
                      ),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      color: AppTheme.DarkJungleGreen,
                      height: 2,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => {
                          controller.playComposition(),
                          controller.playRecord(),
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: controller.isPlaying.value
                                ? Icon(Icons.pause_circle_filled_rounded,
                                    size: 50, color: AppTheme.Opal)
                                : Icon(Icons.play_circle_fill_rounded,
                                    size: 50, color: AppTheme.Opal)),
                      ),
                      InkWell(
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
                                await controller.recordplayer.seek(Duration(
                                    milliseconds: selectedValue.toInt()));
                                controller._currentValue.value = selectedValue;
                              },
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: controller.isPlaying.value
                                    ? AppTheme.Lilac
                                    : AppTheme.Opal,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [CustomBoxShadow()]),
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                size: 40, color: AppTheme.White)),
                      ),
                      CustomPaint(
                          painter: CirclePainter(
                            controller._animationController,
                            color: AppTheme.Lilac,
                          ),
                          child: SizedBox(
                              width: 50 * 4.125,
                              height: 50 * 4.125,
                              child: InkWell(
                                onTap: () async => await controller.record(),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(50 * 4.125),
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
                              ))),
                      InkWell(
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
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: controller.isPlaying.value
                                    ? AppTheme.Lilac
                                    : AppTheme.Opal,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [CustomBoxShadow()]),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SvgPicture.asset(
                                'checkCircle'.toSvgPath(),
                                color: AppTheme.White,
                              ),
                            )),
                      ),
                    ],
                  ),
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

class AddTrackPageController extends BaseGetxController
    with SingleGetTickerProviderMixin {
  final CompositionModel compositionModel;

  late FlutterSoundRecorder recorder;
  late p.AudioPlayer compositionplayer;
  late p.AudioPlayer recordplayer;
  var isInitRecorder = false;
  var isInitCPlayer = false;
  var isInitRPlayer = false;
  var path;
  var savedpath;
  var isRecording = false.obs;
  var isPlaying = false.obs;
  var _currentValue = 0.0.obs;
  var _duration = 1.0.obs;

  var isPlayingComposition = false.obs;
  var isPlayingRecord = false.obs;

  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();

  final infoController = TextEditingController();
  final infoFocusNode = FocusNode();

  late AnimationController _animationController;
  final UploadService _uploadService = Get.find();
  final CompositionService _compositionService = Get.find();

  AddTrackPageController(BuildContext context, this.compositionModel)
      : super(context) {
    recorder = new FlutterSoundRecorder();
    compositionplayer = new p.AudioPlayer();
    recordplayer = new p.AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void onInit() async {
    isBusy.value = true;
    var file =
        await DefaultCacheManager().downloadFile(compositionModel.audio!);
    savedpath = file.file.path;
    isBusy.value = false;
    super.onInit();
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
      var x = DateTime.now();
      playComposition();
      Future.delayed(
          Duration(
              microseconds: DateTime.now().difference(x).inMicroseconds + 1500),
          () async {
        recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
      });
      isRecording.value = true;
    }
  }

  Future playComposition() async {
    if (isPlayingComposition.value) {
      await compositionplayer.pause();
    } else {
      //play
      if (!isInitCPlayer) {
        await compositionplayer.setUrl(savedpath, isLocal: true);
        compositionplayer.onPlayerStateChanged.listen((p.PlayerState s) => {
              if (s == p.PlayerState.PLAYING)
                {
                  isPlayingComposition.value = true,
                }
              else if (s == p.PlayerState.PAUSED)
                {
                  isPlayingComposition.value = false,
                }
              else if (s == p.PlayerState.STOPPED)
                {
                  isPlayingComposition.value = false,
                }
              else if (s == p.PlayerState.COMPLETED)
                {
                  isPlayingComposition.value = false,
                }
            });
        isInitCPlayer = true;
      }
      await compositionplayer.resume();
    }
  }

  Future playRecord() async {
    if (isPlayingRecord.value) {
      await recordplayer.pause();
    } else {
      //play
      if (!isInitRPlayer) {
        var tempDir = await getTemporaryDirectory();
        path = '${tempDir.path}/flutter_sound.wav';
        await recordplayer.setUrl(path, isLocal: true);
        recordplayer.onPlayerStateChanged.listen((p.PlayerState s) => {
              if (s == p.PlayerState.PLAYING)
                {
                  isPlayingRecord.value = true,
                }
              else if (s == p.PlayerState.PAUSED)
                {
                  isPlayingRecord.value = false,
                }
              else if (s == p.PlayerState.STOPPED)
                {
                  isPlayingRecord.value = false,
                }
              else if (s == p.PlayerState.COMPLETED)
                {
                  _currentValue.value = 0,
                  isPlayingRecord.value = false,
                }
            });
        isInitRPlayer = true;
      }
      await recordplayer.resume();
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
    var composition = await _compositionService.addTrack(
        TrackModel(
            ownerUserId: authenticationService.authenticationData!.user!.id,
            username: authenticationService.authenticationData!.user!.username,
            title: titleController.text,
            info: infoController.text,
            midi: data.midi,
            csv: data.csv,
            audio: data.url,
            sheetMusic: data.sheetMusic),
        compositionModel.id!);
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
    recordplayer.dispose();
    compositionplayer.dispose();
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
