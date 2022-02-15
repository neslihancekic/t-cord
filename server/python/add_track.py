
import sys
import os
import requests
import muspy

import py_midicsv as pm
import warnings
from pydub import AudioSegment
from mido import MidiFile

def main(argv,argv2,argv3):
    warnings.filterwarnings("ignore")
    cwd = os.getcwd()
    
    sound1 = AudioSegment.from_wav(cwd+argv+".wav")
    sound2 = AudioSegment.from_wav(cwd+argv2+".wav")
    combined = sound1.overlay(sound2)
    combined.export(cwd+"/combined.wav", format = 'wav')
    r = requests.post("http://"+argv3+"/wav/upload",files={'file': open(cwd+"/combined.wav", 'rb')})
    print(r.text)
    
    cv1 = MidiFile(cwd+argv+'.mid', clip=True)
    cv2 = MidiFile(cwd+argv2+'.mid', clip=True) 
    for a in cv2.tracks:
        cv1.tracks.append(a)
    cv1.save(cwd+'/combined.mid')
    r1 = requests.post("http://"+argv3+"/midi/upload",files={'file': open(cwd+"/combined.mid", 'rb')})
    print(r1.text)
    
    csv_string = pm.midi_to_csv(cwd+"/combined.mid")
    with open(cwd+"/combined.csv","w") as f:
        f.writelines(csv_string)
    r2 = requests.post("http://"+argv3+"/csv/upload",files={'file': open(cwd+"/combined.csv", 'rb')})
    print(r2.text)
    
    notes=[]
    muspy.download_bravura_font()
    clef="treble"
    p=muspy.read_midi(cwd+'/combined.mid')
    p.show_score(figsize=(50,5),clef=clef).fig.savefig('combined.jpeg')
    r3 = requests.post("http://"+argv3+"/image/upload",files={'file': open(cwd+"/combined.jpeg", 'rb')})
    print(r3.text)
    
    
if __name__ == "__main__":
    main(sys.argv[1],sys.argv[2],sys.argv[3])