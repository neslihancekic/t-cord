
import sys
import os
import requests

import py_midicsv as pm
import warnings

def main(argv,argv2):
    warnings.filterwarnings("ignore")
    cwd = os.getcwd()
    midi = pm.csv_to_midi(cwd+argv)
    with open(cwd+argv.replace(".csv",".mid"),"wb") as output_file:
        midi_writer = pm.FileWriter(output_file)
        midi_writer.write(midi)
    r2 = requests.post("http://"+argv2+"/midi/upload",files={'file': open(cwd+argv.replace(".csv",".mid"), 'rb')})
    print(r2.text)
    
if __name__ == "__main__":
    main(sys.argv[1],sys.argv[2])