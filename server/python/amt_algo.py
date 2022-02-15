import numpy as np
import sys
import os
import librosa
import librosa.display
import midiutil
import difflib
import requests
import muspy
from scipy import signal


import py_midicsv as pm
import csv
from itertools import islice, dropwhile
from midi2audio import FluidSynth
import warnings

class Midi_Maker:
    def __init__(self):
        super().__init__()
    def load_sound(self,filename):
        y, sr = librosa.load(filename)
        self.y=y
        self.sr=sr
        self.detectedMidi = MidiData()
    def onset_detection(self):
        self.C = np.abs(librosa.cqt(y=self.y, sr=self.sr))
        self.onset_env = librosa.onset.onset_strength(sr=self.sr, y=self.y, aggregate=np.mean)
        times = librosa.times_like(self.onset_env, sr=self.sr)
        onset_frames = librosa.onset.onset_detect(onset_envelope=self.onset_env, sr=self.sr)
        D = np.abs(librosa.cqt(self.y))
        times = librosa.times_like(D) #Return an array of time values to match the time axis from a feature matrix. 
        self.amps=amplitude_envelope(self.y)
        frames=range(0,self.amps.size) 
        new_onset_frames=[]
        self.threshold = np.mean(self.amps[self.amps<0.2])#burda esleri silmek lazım ortalamadan daha güzel biryöntemle
        for i in range(len(onset_frames)):
            #print(onset_frames[i]," ",amps[onset_frames[i]], "false" if amps[onset_frames[i]]<threshold else "true")
            if self.amps[onset_frames[i]]>=self.threshold:
                new_onset_frames.append(onset_frames[i])
        new_onset_times = librosa.frames_to_time(new_onset_frames, sr=self.sr)
        self.onset_frames=new_onset_frames
        self.onset_times=new_onset_times
    def offset_detection(self):
        offset_frames=[]
        for i in range(len(self.onset_frames)-1):
            seq=self.amps[self.onset_frames[i]:self.onset_frames[i+1]]
            first_val = islice(dropwhile(lambda x: x>=self.threshold, seq),0,1)
            li=list(first_val)
            if li:
                result = np.where(seq == li[0])[0][0]
                offset_frames.append(self.onset_frames[i]+result)
            else:
                offset_frames.append(self.onset_frames[i+1])
                
        #last note
        seq=self.amps[self.onset_frames[-1]:]
        first_val = islice(dropwhile(lambda x: x>=self.threshold, seq),0,1)
        li=list(first_val)
        if li:
            result = np.where(seq == li[0])[0][0]
            offset_frames.append(self.onset_frames[-1]+result)
        else:
            offset_frames.append(self.onset_frames[-1]+1)  
        self.offset_times = librosa.frames_to_time(offset_frames, sr=self.sr)    
        self.offset_frames = offset_frames

    def duration_detection(self):
        Ts=1/self.sr
        tsample=self.onset_times/Ts
        tsampleint=np.round(tsample)
        strarr=np.zeros(len(self.y))
        for i in range(len(tsampleint)):
            strarr[int(tsampleint[i])]=1
        t = np.linspace(-1, 1, 5000, endpoint=True)
        a=3
        h=np.exp(-(a*t)**2)
        h=h/np.max(h)
        strarrf=signal.convolve(strarr,h)
        strarrf=strarrf-np.mean(strarrf)
        corrres=signal.correlate(strarrf,strarrf)
        I=np.argmax(corrres)
        corrres2=corrres[I+int(len(t)/2):]
        I2=np.argmax(corrres2)
        frame=I2+int(len(t)/2)
        framelensec=frame/self.sr
        corrres3=corrres[I+int(len(t)/2):I+frame-int(len(t)/2)]
        I3=np.argmax(corrres3)
        subframe=I3+int(len(t)/2)
        if(np.round(frame/subframe)-frame/subframe<0.01):
            subframelensec=subframe/self.sr
            bpm=60/subframelensec
            bpm=bpm*2
        else:
            bpm=60/framelensec
            bpm=bpm*2
        while(bpm>180 or bpm<60):
            if(bpm>180):
                self.bpm = bpm/2
            elif(bpm<60):
                self.bpm = bpm*2

        self.bpm = librosa.beat.tempo(onset_envelope=self.onset_env, sr=self.sr)[0]
        self.detectedMidi.setBPM(int(np.round(self.bpm)))

        tempo=60*1000000/self.bpm
        ticks_per_quarternote=960
        one_tick=(tempo/ticks_per_quarternote)/1000000

        onsets = self.onset_frames
        offsets = self.offset_frames 

        self.detectedMidi.setAllOnsets(librosa.frames_to_time(onsets, sr=self.sr))
        self.detectedMidi.setAllOffsets(librosa.frames_to_time(offsets, sr=self.sr))
        
        self.onsets = np.round(librosa.frames_to_time(onsets, sr=self.sr)/one_tick)
        self.offsets = np.round(librosa.frames_to_time(offsets, sr=self.sr)/one_tick)
        self.onsets = self.onsets.astype(np.int32)
        self.offsets = self.offsets.astype(np.int32)
        self.durations = (self.offsets-self.onsets)

        for i in range(len(self.durations)):
            note_length = (self.offsets[i]-self.onsets[i])/960
            while(note_length>0.25):
                note_length -= 1/4
            
            if(note_length==0.25):
                continue
            elif(note_length>0.15):
                self.durations[i]=self.offsets[i]-self.onsets[i] -(note_length-0.25)*960
            else:
                self.durations[i]=self.offsets[i]-self.onsets[i] - (note_length)*960

        self.durations[self.durations == 0] = 0.25*960
            
        self.detectedMidi.setAllDurations(self.durations*one_tick)

    def note_detection(self):     
        amps=librosa.amplitude_to_db(self.C, ref=np.max)
        amps_notes=[]
        cqt_notes=[]
        for i in range(len(self.onset_frames)):
            amps_notes[x][np.argmax(amps_notes[x])-1]=-80
            amps_notes[x][np.argmax(amps_notes[x])-2]=-80
            amps_notes[x][np.argmax(amps_notes[x])+1]=-80
            amps_notes[x][np.argmax(amps_notes[x])+2]=-80
            amps_notes[x][np.argmax(amps_notes[x])-3]=-80
            amps_notes[x][np.argmax(amps_notes[x])+3]=-80
            firstMax=0
            secondMax=0
            lastNote=0
            lastNoteDb=0
            for x in range(len(amps_notes)):
                firstMax=np.argmax(amps_notes[x])
                firstMaxDb=amps_notes[x][firstMax]
                amps_notes[x][np.argmax(amps_notes[x])]=-80
                #print(amps_notes)
                secondMax=np.argmax(amps_notes[x])
                secondMaxDb=amps_notes[x][secondMax]
                if((firstMaxDb-secondMaxDb)>0.2 and 
                (firstMax-secondMax==12 or firstMax-secondMax==7 or firstMax-secondMax==5 or firstMax-secondMax==19)): #if first max is T, T/2, T/3 or 3T/2 harmonics
                    cqt_notes.append([secondMax,self.onset_frames[x]])##not,onset
                    lastNote=secondMax
                    lastNoteDb=secondMaxDb
                else:
                    if(lastNote==firstMax and lastNoteDb>firstMaxDb and np.abs(lastNoteDb-firstMaxDb)>8):
                        cqt_notes.append([secondMax,self.onset_frames[x]])##not,onset
                        lastNote=secondMax
                        lastNoteDb=secondMaxDb
                    else:
                        cqt_notes.append([firstMax,self.onset_frames[x]])##not,onset
                        lastNote=firstMax
                        lastNoteDb=firstMaxDb
                

        np_cqt=np.array(cqt_notes)
        self.np_cqt=np_cqt[np_cqt[:, 1].argsort()].T#sort by samples    
 
    def set_notes(self):      
        midiNotes=np.arange(24,108).reshape(84) #midi notes for cqt 1 octave up
        self.cqtMidi = midiutil.MIDIFile(1,  eventtime_is_ticks=True)
        self.cqtMidi.addTempo(0, 0, np.round(self.bpm))
        self.cqtMidi.addTimeSignature(0, 0, 4, 2, 24, notes_per_quarter=8)
        notesArray=[ midiNotes[x] for x in self.np_cqt[0] ]

        self.detectedMidi.setAllNotes(notesArray)
        for i in range(len(self.onset_frames)-1):
                self.cqtMidi.addNote(0,0,midiNotes[self.np_cqt[0][i]],self.onsets[i],self.durations[i],100)

        self.cqtMidi.addNote(0,0,midiNotes[self.np_cqt[0][-1]],self.onsets[-1],self.durations[-1],100)

    def export_midi(self):
        with open("detected.mid", 'wb') as output_file:
            self.cqtMidi.writeFile(output_file)
    def export_sheetMusic(self):
        notes=[]
        muspy.download_bravura_font()
        midiNotes=np.arange(24,108).reshape(84) #midi notes for cqt 1 octave up
        for i in range(len(self.onset_frames)-1):
            notes.append(midiNotes[self.np_cqt[0][i]])
        avg_notes=np.mean(notes)
        clef="treble"
        if(avg_notes<50):
            clef="bass"
        elif(avg_notes<60): 
            clef="alto"
        p=muspy.read_midi("detected.mid")
        p.show_score(figsize=(50,5),clef=clef).fig.savefig('detected.jpeg')
        
        
    def transcribe(self,filename):
        self.load_sound(filename)
        self.onset_detection()
        self.offset_detection()
        self.duration_detection()
        self.note_detection()
        self.set_notes()
        self.export_midi()
        self.export_sheetMusic()


def amplitude_envelope(signal, frame_size=1024, hop_length=512):
    return np.array([max(signal[i:i+frame_size]) if i<=frame_size/2 else max(signal[i-int(frame_size/2):i+int(frame_size/2)]) for i in range(0, len(signal), hop_length)])


class MidiData:
    def __init__(self):
        self.resolution = 960
        self.tempo = 0
        self.bpm = 0
        self.oneTickInSeconds = 0
        self.onsets = []        
        self.offsets = []        
        self.durations = []
        self.notes = []
        
    def setResolution(self,reso):
        self.resolution=reso
        
    def setTempo(self,tempo):
        self.tempo=tempo
        self.oneTickInSeconds=(self.tempo/self.resolution)/1000000
        self.bpm = int(np.round(60*1000000/tempo))
        
    def addOnset(self,onset):
        self.onsets.append(onset*self.oneTickInSeconds)
        
    def addOffset(self,offset):
        self.offsets.append(offset*self.oneTickInSeconds)
        
    def addNote(self,note):
        self.notes.append(note)
        
    def setBPM(self,bpm):
        self.bpm=bpm
        self.tempo = int(np.round(60*1000000/bpm))
        self.oneTickInSeconds=(self.tempo/self.resolution)/1000000
    
    def setAllOnsets(self,onsets):
        self.onsets=onsets
        
    def setAllOffsets(self,offsets):
        self.offsets=offsets
    
    def setAllDurations(self,durations):
        self.durations=durations  
        
    def setAllNotes(self,notes):
        self.notes=notes
    
    def calculateDurations(self):
        self.durations = np.array(self.offsets)-np.array(self.onsets)

    def midiReader(self,filename):
        csv_string = pm.midi_to_csv(filename)
        with open(filename.replace(".mid",".csv"),"w") as f:
            f.writelines(csv_string)
        groundTruth = MidiData()
        with open(filename.replace(".mid",".csv"), 'r') as file:
            reader = csv.reader(file)
            for row in reader:
                if row[2] == " Header":
                    groundTruth.setResolution(int(row[5]))
                if(row[2] == " Tempo"):
                    groundTruth.setTempo(int(row[3]))
                if(row[2] == " Note_on_c"):
                    groundTruth.addOnset(int(row[1]))
                    groundTruth.addNote(int(row[4]))
                if(row[2] == " Note_off_c"):
                    groundTruth.addOffset(int(row[1]))
        groundTruth.calculateDurations()

def compare(truth, predicted, debug=False, precision=1):
    print("MIDI Evaluations")
    print("**************************************************")
    print("BPM Evaluation ->", truth.bpm==predicted.bpm)
    if debug: 
        print("Truth","Predicted")
        print(truth.bpm,predicted.bpm)
        print()
        
    sm=difflib.SequenceMatcher(None,truth.notes,predicted.notes)
    print("Note Evaluation ->","%",sm.ratio()*100)
    if debug: 
        print(truth.notes)
        print(predicted.notes)
        print()
    
    sm=difflib.SequenceMatcher(None,np.round(truth.onsets,precision),np.round(predicted.onsets,precision))
    print("Onset Evaluation(for precision",precision,") ->","%",sm.ratio()*100)
    
    if debug: 
        print(truth.onsets)
        print(predicted.onsets)
        print()
    
    sm=difflib.SequenceMatcher(None,np.round(truth.offsets,precision),np.round(predicted.offsets,precision))
    print("Offset Evaluation(for precision",precision,") ->","%",sm.ratio()*100)
    
    if debug: 
        print(truth.offsets)
        print(predicted.offsets)
        print()
        
    sm=difflib.SequenceMatcher(None,np.round(truth.durations,precision),np.round(predicted.durations,precision))
    print("Duration Evaluation (for precision",precision,") ->","%",sm.ratio()*100)
    
    if debug: 
        print(truth.durations)
        print(predicted.durations)
        print()


def main(argv,argv2):
    warnings.filterwarnings("ignore")
    cwd = os.getcwd()
    print(cwd)
    midi_class = Midi_Maker()
    midi_class.transcribe(cwd+argv)
    r = requests.post("http://"+argv2+"/midi/upload",files={'file': open(cwd+"/detected.mid", 'rb')})
    csv_string = pm.midi_to_csv(cwd+"/detected.mid")
    with open(cwd+"/detected.csv","w") as f:
        f.writelines(csv_string)
    r2 = requests.post("http://"+argv2+"/csv/upload",files={'file': open(cwd+"/detected.csv", 'rb')})
    r3 = requests.post("http://"+argv2+"/image/upload",files={'file': open(cwd+"/detected.jpeg", 'rb')})
    print(r.text)
    print(r2.text)
    print(r3.text)
    
if __name__ == "__main__":
    main(sys.argv[1],sys.argv[2])