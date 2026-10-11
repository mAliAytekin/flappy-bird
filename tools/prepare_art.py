"""Higgsfield çıktılarından Godot sprite karelerini çıkarır; Pillow gerekir.
Kaynak görseller korunur. Yalnızca atlas ayırma, alfa eşiği, hizalama ve
nearest-neighbor ölçekleme yapılır; yeni sanat çizilmez.
"""
from pathlib import Path
from PIL import Image, ImageOps
ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/art'
SRC = OUT / 'source'

def crisp(im):
    im = im.convert('RGBA')
    im.putalpha(im.getchannel('A').point(lambda a: 255 if a >= 128 else 0))
    return im

def fit_cell(im, size, padding=2):
    im = crisp(im)
    box = im.getchannel('A').getbbox()
    assert box, 'Boş sprite'
    im = im.crop(box)
    scale = min((size[0]-2*padding)/im.width, (size[1]-2*padding)/im.height)
    im = im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.NEAREST)
    canvas = Image.new('RGBA',size)
    canvas.paste(im,((size[0]-im.width)//2,(size[1]-im.height)//2))
    return canvas

sheet = crisp(Image.open(SRC/'crow_alpha.png'))
for i in range(4):
    x,y = (i%2)*512,(i//2)*512
    cell = sheet.crop((x,y,x+512,y+512))
    eye=[]
    for py in range(512):
        for px in range(256,470):
            r,g,b,a=cell.getpixel((px,py))
            if a and r>210 and g>200 and b>140: eye.append((px,py))
    assert eye
    ex=(min(p[0] for p in eye)+max(p[0] for p in eye))/2
    ey=(min(p[1] for p in eye)+max(p[1] for p in eye))/2
    frame=Image.new('RGBA',(64,64))
    cell=cell.resize((64,64),Image.Resampling.NEAREST)
    frame.paste(cell,(round(44-ex/8),round(28-ey/8)))
    frame.save(OUT/f'crow_{i}.png')
props=Image.open(SRC/'props.png')
items=[('cap',(24,24)),('spoon',(32,32)),('chimney',(32,32)),('nest',(128,96)),('nest_final',(128,96)),('chimney_cap',(64,24))]
for i,(name,size) in enumerate(items):
    x,y=i%3,i//3
    cell=props.crop((round(x*1024/3),y*512,round((x+1)*1024/3),(y+1)*512))
    if name=='chimney':
        cell=crisp(cell); cell=cell.crop(cell.getchannel('A').getbbox())
        cell=cell.resize(size,Image.Resampling.NEAREST)
    else: cell=fit_cell(cell,size)
    cell.save(OUT/(name+'.png'))
bg=Image.open(SRC/'rooftops.png').convert('RGB').resize((480,270),Image.Resampling.NEAREST).resize((960,540),Image.Resampling.NEAREST)
# Aynalama, iki uçta kusursuz tekrar sağlar; arka plan düşük hızda kayar.
panorama=Image.new('RGB',(1920,540))
panorama.paste(bg,(0,0)); panorama.paste(ImageOps.mirror(bg),(960,0))
panorama.save(OUT/'rooftops.png')
print('4 karga karesi, 6 nesne ve kesintisiz arka plan hazır.')
