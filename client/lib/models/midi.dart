import 'package:flutter/material.dart';

class MidiModel {
  int? bpm;
  int? tempo;
  int? resolution;
  int? endTick;
  List<Note>? notes;
  MidiModel(this.tempo, this.resolution, this.notes, this.bpm, this.endTick);
}

class Note {
  int startTick;
  int durationTick;
  int midiNote;
  Note(this.midiNote, this.startTick, this.durationTick);
}
