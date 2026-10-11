"""Higgsfield Liman atlasından oyun dokularını çıkarır (Pillow)."""
from pathlib import Path
from PIL import Image, ImageOps
out=Path(__file__).resolve().parents[1]/'assets/art'
sheet=Image.open(out/'source/harbor_props.png').convert('RGBA')
assert sheet.getchannel('A').getextrema()[0]==0
for i,(name,size) in enumerate([('crate',64),('cloth',64),('ornament',64),('lantern',64),('chime',64),('medal',32)]):
 x,y=i%3,i//3
 cell=sheet.crop((round(x*sheet.width/3),y*sheet.height//2,round((x+1)*sheet.width/3),(y+1)*sheet.height//2))
 cell.putalpha(cell.getchannel('A').point(lambda a:255 if a>=128 else 0))
 cell=cell.crop(cell.getchannel('A').getbbox())
 scale=min((size-2)/cell.width,(size-2)/cell.height)
 cell=cell.resize((round(cell.width*scale),round(cell.height*scale)),Image.Resampling.NEAREST)
 target=Image.new('RGBA',(size,size));target.paste(cell,((size-cell.width)//2,(size-cell.height)//2));target.save(out/(name+'.png'))
bg=Image.open(out/'source/harbor.png').convert('RGB').resize((480,270),Image.Resampling.NEAREST).resize((960,540),Image.Resampling.NEAREST)
pano=Image.new('RGB',(1920,540));pano.paste(bg,(0,0));pano.paste(ImageOps.mirror(bg),(960,0));pano.save(out/'harbor.png')
collectibles=Image.open(out/'source/collectibles.png').convert('RGBA')
for i,name in enumerate(['dugme','yuzuk','boncuk','saat','kabuk','pusula','tas','madalya']):
 x,y=i%4,i//4;w,h=collectibles.size
 cell=collectibles.crop((round(x*w/4),y*h//2,round((x+1)*w/4),(y+1)*h//2))
 cell.putalpha(cell.getchannel('A').point(lambda a:255 if a>=128 else 0))
 cell=cell.crop(cell.getchannel('A').getbbox())
 scale=min(28/cell.width,28/cell.height)
 cell=cell.resize((round(cell.width*scale),round(cell.height*scale)),Image.Resampling.NEAREST)
 target=Image.new('RGBA',(32,32));target.paste(cell,((32-cell.width)//2,(32-cell.height)//2));target.save(out/('special_'+name+'.png'))
