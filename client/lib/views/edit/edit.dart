import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/models/midi.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/views/animation/slide_animation.dart';
import 'package:tcord/views/edit/cell.dart';
import 'package:tcord/views/edit/midi_viewer.dart';
import 'package:tcord/views/edit/piano_roll.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:tcord/views/home/home.dart';

class EditPage extends StatelessWidget {
  final TrackModel track;
  final String csvFile;
  final bool isEditable;

  const EditPage(
      {Key? key,
      required this.track,
      required this.csvFile,
      this.isEditable = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    EditPageController controller =
        Get.put(EditPageController(context, t: track, file: csvFile));

    return Stack(
      children: [
        SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 40,
                  backgroundColor: AppTheme.GhostWhite,
                  shadowColor: AppTheme.GhostWhite.withOpacity(0),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(top: 8, bottom: 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("BPM ",
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: AppTheme.FootnoteFontSize13,
                                      color: AppTheme.Lilac,
                                      fontWeight: FontWeight.bold)),
                            ),
                            isEditable
                                ? Obx(() => controller.midiModel.value.tempo !=
                                        null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Container(
                                          width: 40,
                                          height: 16,
                                          child: TextField(
                                            controller:
                                                controller.bpmController,
                                            focusNode: FocusNode(),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                      color: Colors.greenAccent,
                                                      width: 1.5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  borderSide: BorderSide(
                                                      color: AppTheme.Lilac,
                                                      width: 1.5),
                                                ),
                                                counterText: '',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2)),
                                            style: TextStyle(
                                                fontSize:
                                                    AppTheme.FootnoteFontSize13,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.GrayWeb),
                                            onEditingComplete: () {
                                              controller.midiModel.value.bpm =
                                                  int.parse(controller
                                                      .bpmController.text);
                                              controller.midiModel.value.tempo =
                                                  (60000000 /
                                                          int.parse(controller
                                                              .bpmController
                                                              .text))
                                                      .round();
                                              controller.timers
                                                  .forEach((timer) {
                                                timer.cancel();
                                              });
                                              controller.isInit.value = true;
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 80,
                                      ))
                                : Text(
                                    controller.midiModel.value.bpm.toString(),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: AppTheme.FootnoteFontSize13,
                                        color: AppTheme.MuntbattenPink,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              child: Text('Play Midi'),
                              onPressed: () async {
                                if (controller.isInit.value) {
                                  await controller.play_midi();
                                  return;
                                }
                                if (controller.isPlaying.value) {
                                  controller.isPaused.value = true;
                                  controller.isPlaying.value = false;
                                  return;
                                }
                                if (controller.isPaused.value) {
                                  controller.isPaused.value = false;
                                  controller.isPlaying.value = true;
                                  controller.timers.forEach((timer) {
                                    timer.start();
                                  });
                                  return;
                                }
                              },
                            ),
                            SizedBox(width: 7),
                            isEditable
                                ? ElevatedButton(
                                    child: Text('Done'),
                                    onPressed: () async {
                                      await controller.save_midi();
                                    },
                                  )
                                : ElevatedButton(
                                    child: Text('Back'),
                                    onPressed: () async {
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.portraitDown,
                                        DeviceOrientation.portraitUp
                                      ]);
                                      Get.back();
                                    },
                                  ),
                          ],
                        ),
                        Obx(() => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoSlider(
                                thumbColor: AppTheme.GhostWhite,
                                activeColor: AppTheme.DarkJungleGreen,
                                value: controller.currentValue.value,
                                min: 20,
                                max: 200,
                                divisions: 50,
                                onChanged: (selectedValue) {
                                  controller.currentValue.value = selectedValue;
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                body: Obx(() => controller.isInitialized.value
                    ? PianoRoll()
                    : SizedBox.shrink()))),
        Obx(() => Visibility(
              visible: controller.isBusy.value,
              child: BusyPageIndicator(),
            ))
      ],
    );
  }
}

class EditPageController extends BaseGetxController {
  final _flutterMidi = FlutterMidi();
  final UploadService _uploadService = Get.find();
  final CompositionService _compositionService = Get.find();
  TrackModel? track;
  String csvFile = "";
  var currentValue = 50.0.obs;
  var isInit = true.obs;
  var isPlaying = false.obs;
  var isPaused = true.obs;
  List<PausableTimer> timers = List<PausableTimer>.empty(growable: true);

  List<List<dynamic>>? midi;
  var midiModel = MidiModel(null, null, null, null, null).obs;
  String _value = 'assets/Piano.sf2';

  final bpmController = TextEditingController();
  EditPageController(BuildContext context, {TrackModel? t, String? file})
      : super(context) {
    if (t != null) {
      track = t;
      csvFile = file!;
    }
    isPaused.listen((p0) {
      if (p0)
        timers.forEach((timer) {
          timer.pause();
        });
    });
  }

  void load(String asset) async {
    print('Loading File...');
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    //assets/sf2/SmallTimGM6mb.sf2
    //assets/sf2/Piano.SF2
    _flutterMidi.prepare(sf2: _byte, name: _value.replaceAll('assets/', ''));
  }

  Future<File> get _csvFile async {
    return File(csvFile);
  }

  Future<String> readFile() async {
    try {
      final file = await _csvFile;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future read_midi() async {
    isBusy.value = true;
    var input = await readFile();
    input = input.replaceAll(" ", "");
    input = input.replaceAll("\n", "\r\n");
    midi = const CsvToListConverter().convert(input);
    var tempo = 1;
    var resolution = 960;
    var endTick = 0;
    var notes = new List<Note>.empty(growable: true);
    for (int i = 0; i < midi!.length - 1; i++) {
      if (midi![i][0] == 1 && midi![i][2] == "Tempo") {
        tempo = midi![i][3];
      }
      if (midi![i][0] == 0 && midi![i][2] == "Header") {
        resolution = midi![i][5];
      }
      if (midi![i][0] == 2 && midi![i][2] == "Note_on_c") {
        var tick = midi![i + 1][1] - midi![i][1];
        notes.add(new Note(midi![i][4], midi![i][1], tick));
      }
      if (midi![i][0] == 2 && midi![i][2] == "End_track") {
        endTick = midi![i][1];
      }
    }
    midiModel.value = new MidiModel(
        tempo, resolution, notes, (60000000 / tempo).round(), endTick);
    bpmController.text = midiModel.value.bpm.toString();
    isBusy.value = false;
  }

  Future play_midi() async {
    timers = List<PausableTimer>.empty(growable: true);
    isPlaying.value = true;
    isPaused.value = false;
    isInit.value = false;
    var n = midiModel.value.notes!.reduce((a, b) =>
        a.durationTick + a.startTick > b.durationTick + b.startTick ? a : b);
    midiModel.value.endTick = n.durationTick + n.startTick;
    for (var note in midiModel.value.notes!) {
      timers.add(PausableTimer(
          Duration(
              microseconds: tickToMicroseconds(
                  note.startTick,
                  midiModel.value.resolution!,
                  midiModel.value.tempo!)), () async {
        play(note.midiNote);
      }));
      timers.add(PausableTimer(
          Duration(
              microseconds: tickToMicroseconds(
                  note.startTick + note.durationTick,
                  midiModel.value.resolution!,
                  midiModel.value.tempo!)), () async {
        stop(note.midiNote);
        if (note.startTick + note.durationTick == midiModel.value.endTick) {
          isInit.value = true;
          isPlaying.value = false;
          isPaused.value = true;
        }
      }));
    }
    timers.forEach((timer) {
      timer.start();
    });
  }

  void changeMidi(MidiModel midi) {
    midiModel.value = midi;
    midiModel.refresh();
  }

  void play(int midi) {
    _flutterMidi.playMidiNote(midi: midi);
  }

  void stop(int midi) {
    _flutterMidi.stopMidiNote(midi: midi);
  }

  int tickToMicroseconds(int tick, int resolution, int tempo) {
    /*self.oneTickInSeconds=(self.tempo/self.resolution)/1000000
        self.bpm = int(np.round(60*1000000/tempo))*/
    return tick * (tempo / resolution).round();
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future writeEditedCsv(String csv) async {
    final path = await _localPath;
    final file = File('$path/edited.csv');
    file.writeAsString(csv);
    var link = await _uploadService.postCsv(file.path);
    if (link != null) {
      var t = await _compositionService.updateTrackMidi(link, track!.sId!);
      Get.back();
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }

  Future save_midi() async {
    var str = "";
    str +=
        "0, 0, Header, 1, 2, " + midiModel.value.resolution.toString() + "\n";
    str += "1, 0, Start_track\n";
    str += "1, 0, Time_signature, 4, 2, 24, 8\n";
    str += "1, 0, Tempo, " + midiModel.value.tempo.toString() + "\n";
    str += "1, 0, End_track\n";
    str += "2, 0, Start_track\n";
    for (var note in midiModel.value.notes!) {
      str += "2, " +
          note.startTick.toString() +
          ", Note_on_c, 0, " +
          note.midiNote.toString() +
          ", 100\n";
      str += "2, " +
          (note.startTick + note.durationTick).toString() +
          ", Note_off_c, 0, " +
          note.midiNote.toString() +
          ", 100\n";
    }
    str += "2, " + midiModel.value.endTick.toString() + ", End_track\n";
    str += "0, 0, End_of_file";
    await writeEditedCsv(str);
    print(str);
  }

  @override
  void onInit() async {
    isInitialized.value = false;
    await read_midi();
    load(_value);
    isInitialized.value = true;

    super.onInit();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
