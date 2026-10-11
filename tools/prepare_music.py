"""İki bölge için özgün, kısa ve döngüye uygun sentez müzikleri üretir."""
import math, struct, wave
from pathlib import Path
out=Path(__file__).resolve().parents[1]/'assets/audio'
out.mkdir(exist_ok=True)
for name,notes in [('rooftops',[60,64,67,71,67,64,62,67,60,64,69,67,64,62,59,62]),('harbor',[57,60,64,67,64,60,55,59,57,60,65,64,60,59,55,52])]:
 rate=22050; beat=.5; duration=16.0
 with wave.open(str(out/(name+'.wav')),'wb') as f:
  f.setparams((1,2,rate,0,'NONE','not compressed'))
  data=bytearray()
  for i in range(int(rate*duration)):
   t=i/rate; local=t%beat; note=notes[int(t/beat)%len(notes)]; hz=440*2**((note-69)/12)
   envelope=min(1,local/.025)*math.exp(-local*6)
   melody=(math.sin(math.tau*hz*local)+.18*math.sin(math.tau*hz*2*local))*envelope
   bass=math.sin(math.tau*(110 if name=='harbor' else 130.8128)*t)*.14
   fade=min(1,t/.05,(duration-t)/.15)
   data+=struct.pack('<h',int((melody*.3+bass)*fade*20000))
  f.writeframes(data)
print('İki özgün bölge müziği hazır.')
